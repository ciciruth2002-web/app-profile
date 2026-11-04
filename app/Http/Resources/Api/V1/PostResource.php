<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

class PostResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'slug' => $this->slug,
            'summary' => $this->summary,
            'content' => $this->content,
            'image_url' => $this->image ? (str_starts_with($this->image, 'http') ? $this->image : Storage::disk('public')->url($this->image)) : null,
            'status' => $this->status,
            'published_at' => $this->published_at?->toIso8601String(),
            'view_count' => $this->view_count,
            'is_featured' => $this->is_featured,
            'category' => new CategoryResource($this->whenLoaded('category')),
            'author' => $this->whenLoaded('user', fn () => [
                'id' => $this->user->id,
                'name' => $this->user->name,
                'avatar_url' => $this->user->avatar ? Storage::disk('public')->url($this->user->avatar) : null,
            ]),
            'created_at' => $this->created_at?->toIso8601String(),
        ];
    }
}
