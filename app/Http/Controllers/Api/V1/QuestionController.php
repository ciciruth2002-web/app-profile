<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\QuestionResource;
use App\Models\Question;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class QuestionController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $questions = Question::query()
            ->with(['topic', 'publishedAnswer.user'])
            ->answered()
            ->when($request->filled('topic'), function ($query) use ($request) {
                $query->whereHas('topic', fn ($q) => $q->where('slug', $request->query('topic')));
            })
            ->when($request->filled('search'), function ($query) use ($request) {
                $search = $request->query('search');
                $query->where(function ($q) use ($search) {
                    $q->where('subject', 'like', "%{$search}%")
                        ->orWhere('body', 'like', "%{$search}%");
                });
            })
            ->latest()
            ->paginate($request->integer('per_page', 10));

        return QuestionResource::collection($questions);
    }

    public function show(int $id): QuestionResource
    {
        $question = Question::query()
            ->with(['topic', 'publishedAnswer.user'])
            ->answered()
            ->findOrFail($id);

        return new QuestionResource($question);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'topic_id' => ['nullable', 'exists:question_topics,id'],
            'name' => ['required', 'string', 'max:100'],
            'email' => ['required', 'email', 'max:150'],
            'phone' => ['nullable', 'string', 'max:25'],
            'subject' => ['required', 'string', 'max:200'],
            'body' => ['required', 'string', 'min:10'],
        ]);

        $question = Question::create([
            ...$validated,
            'status' => 'pending',
            'ip_address' => $request->ip(),
        ]);

        return response()->json([
            'message' => 'Pertanyaan Anda berhasil dikirim dan akan segera ditinjau oleh petugas.',
            'data' => [
                'id' => $question->id,
                'subject' => $question->subject,
                'status' => $question->status,
                'created_at' => $question->created_at->toIso8601String(),
            ],
        ], 201);
    }
}
