<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Faq;
use App\Models\Menu;
use App\Models\MenuItem;
use App\Models\Page;
use App\Models\QuestionTopic;
use App\Models\Setting;
use App\Models\Slide;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ApiContentTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_get_settings(): void
    {
        Setting::setValue('site_name', 'Portal Profil Pemda');

        $response = $this->getJson(route('api.v1.settings'));

        $response->assertOk()
            ->assertJsonPath('data.site_name', 'Portal Profil Pemda');
    }

    public function test_can_get_slides(): void
    {
        Slide::create([
            'title' => 'Slide Selamat Datang',
            'image' => 'slides/test.jpg',
            'is_active' => true,
        ]);

        $response = $this->getJson(route('api.v1.slides'));

        $response->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.title', 'Slide Selamat Datang');
    }

    public function test_can_get_categories(): void
    {
        Category::factory()->create(['name' => 'Pengumuman']);

        $response = $this->getJson(route('api.v1.categories.index'));

        $response->assertOk()
            ->assertJsonCount(1, 'data');
    }

    public function test_can_get_pages(): void
    {
        Page::create([
            'title' => 'Tentang Kami',
            'slug' => 'tentang-kami',
            'content' => 'Halaman tentang kami.',
            'status' => 'published',
            'sort_order' => 1,
        ]);

        $response = $this->getJson(route('api.v1.pages.show', 'tentang-kami'));

        $response->assertOk()
            ->assertJsonPath('data.slug', 'tentang-kami');
    }

    public function test_can_get_menu_by_location(): void
    {
        $menu = Menu::create([
            'name' => 'Header Nav',
            'location' => 'header',
            'is_active' => true,
        ]);

        MenuItem::create([
            'menu_id' => $menu->id,
            'label' => 'Beranda',
            'url' => '/',
            'type' => 'custom',
            'sort_order' => 1,
            'is_active' => true,
        ]);

        $response = $this->getJson(route('api.v1.menus.show', 'header'));

        $response->assertOk()
            ->assertJsonPath('data.location', 'header')
            ->assertJsonCount(1, 'data.items');
    }

    public function test_can_get_faqs(): void
    {
        $topic = QuestionTopic::factory()->create();

        Faq::create([
            'topic_id' => $topic->id,
            'question' => 'Apa syarat pengurusan izin?',
            'answer' => 'Membawa KTP dan surat rekomendasi.',
            'sort_order' => 1,
            'is_active' => true,
        ]);

        $response = $this->getJson(route('api.v1.faqs.index'));

        $response->assertOk()
            ->assertJsonCount(1, 'data');
    }
}
