<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\PostResource;
use App\Models\Post;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class PostController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $posts = Post::query()
            ->with(['category', 'user'])
            ->published()
            ->when($request->filled('category'), function ($query) use ($request) {
                $query->whereHas('category', fn ($q) => $q->where('slug', $request->query('category')));
            })
            ->when($request->filled('search'), function ($query) use ($request) {
                $search = $request->query('search');
                $query->where(function ($q) use ($search) {
                    $q->where('title', 'like', "%{$search}%")
                        ->orWhere('summary', 'like', "%{$search}%");
                });
            })
            ->when($request->boolean('featured'), fn ($q) => $q->featured())
            ->latest('published_at')
            ->paginate($request->integer('per_page', 10));

        return PostResource::collection($posts);
    }

    public function show(string $slug): PostResource
    {
        $post = Post::query()
            ->with(['category', 'user'])
            ->published()
            ->where('slug', $slug)
            ->firstOrFail();

        $post->increment('view_count');

        return new PostResource($post);
    }

    public function featured(): AnonymousResourceCollection
    {
        $posts = Post::query()
            ->with(['category', 'user'])
            ->published()
            ->featured()
            ->latest('published_at')
            ->take(5)
            ->get();

        return PostResource::collection($posts);
    }
}
