<?php

use App\Http\Controllers\Api\V1\CategoryController;
use App\Http\Controllers\Api\V1\FaqController;
use App\Http\Controllers\Api\V1\MenuController;
use App\Http\Controllers\Api\V1\PageController;
use App\Http\Controllers\Api\V1\PostController;
use App\Http\Controllers\Api\V1\QuestionController;
use App\Http\Controllers\Api\V1\QuestionTopicController;
use App\Http\Controllers\Api\V1\SettingController;
use App\Http\Controllers\Api\V1\SlideController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::prefix('v1')->group(function () {
    // Pengaturan Situs
    Route::get('/settings', [SettingController::class, 'index'])->name('api.v1.settings');

    // Slide Banner
    Route::get('/slides', [SlideController::class, 'index'])->name('api.v1.slides');

    // Kategori
    Route::get('/categories', [CategoryController::class, 'index'])->name('api.v1.categories.index');
    Route::get('/categories/{slug}', [CategoryController::class, 'show'])->name('api.v1.categories.show');

    // Artikel / Berita
    Route::get('/posts', [PostController::class, 'index'])->name('api.v1.posts.index');
    Route::get('/posts/featured', [PostController::class, 'featured'])->name('api.v1.posts.featured');
    Route::get('/posts/{slug}', [PostController::class, 'show'])->name('api.v1.posts.show');

    // Halaman Statis
    Route::get('/pages', [PageController::class, 'index'])->name('api.v1.pages.index');
    Route::get('/pages/{slug}', [PageController::class, 'show'])->name('api.v1.pages.show');

    // Menu Navigasi
    Route::get('/menus/{location}', [MenuController::class, 'show'])->name('api.v1.menus.show');

    // Layanan Pertanyaan & Aspirasi
    Route::get('/question-topics', [QuestionTopicController::class, 'index'])->name('api.v1.question-topics.index');
    Route::get('/questions', [QuestionController::class, 'index'])->name('api.v1.questions.index');
    Route::get('/questions/{id}', [QuestionController::class, 'show'])->name('api.v1.questions.show');
    Route::post('/questions', [QuestionController::class, 'store'])
        ->middleware('throttle:10,1')
        ->name('api.v1.questions.store');

    // FAQ (Pertanyaan yang sering diajukan)
    Route::get('/faqs', [FaqController::class, 'index'])->name('api.v1.faqs.index');
});
