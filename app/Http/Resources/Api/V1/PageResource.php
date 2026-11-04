<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

class PageResource extends JsonResource
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
            'content' => $this->content,
            'image_url' => $this->image ? (str_starts_with($this->image, 'http') ? $this->image : Storage::disk('public')->url($this->image)) : null,
            'sort_order' => $this->sort_order,
            'show_in_menu' => $this->show_in_menu,
            'updated_at' => $this->updated_at?->toIso8601String(),
        ];
    }
}
