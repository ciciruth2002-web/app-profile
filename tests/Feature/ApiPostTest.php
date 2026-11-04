<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Post;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ApiPostTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_list_published_posts(): void
    {
        $user = User::factory()->create();
        $category = Category::factory()->create();

        Post::factory()->create([
            'user_id' => $user->id,
            'category_id' => $category->id,
            'status' => 'published',
            'published_at' => now()->subDay(),
        ]);

        Post::factory()->create([
            'user_id' => $user->id,
            'category_id' => $category->id,
            'status' => 'draft',
            'published_at' => null,
        ]);

        $response = $this->getJson(route('api.v1.posts.index'));

        $response->assertOk()
            ->assertJsonStructure([
                'data' => [
                    '*' => [
                        'id',
                        'title',
                        'slug',
                        'summary',
                        'content',
                        'image_url',
                        'status',
                        'published_at',
                        'view_count',
                        'is_featured',
                    ],
                ],
                'links',
                'meta',
            ])
            ->assertJsonCount(1, 'data');
    }

    public function test_can_get_post_detail_and_increments_views(): void
    {
        $user = User::factory()->create();
        $category = Category::factory()->create();

        $post = Post::factory()->create([
            'user_id' => $user->id,
            'category_id' => $category->id,
            'status' => 'published',
            'published_at' => now()->subHour(),
            'view_count' => 5,
        ]);

        $response = $this->getJson(route('api.v1.posts.show', $post->slug));

        $response->assertOk()
            ->assertJsonPath('data.title', $post->title)
            ->assertJsonPath('data.view_count', 6);

        $this->assertDatabaseHas('posts', [
            'id' => $post->id,
            'view_count' => 6,
        ]);
    }
}
