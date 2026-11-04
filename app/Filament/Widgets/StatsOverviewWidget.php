<?php

namespace App\Filament\Widgets;

use App\Models\Faq;
use App\Models\Page;
use App\Models\Post;
use App\Models\Question;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class StatsOverviewWidget extends BaseWidget
{
    protected function getStats(): array
    {
        $pendingQuestions = Question::pending()->count();

        return [
            Stat::make('Total Artikel', Post::count())
                ->description(Post::published()->count().' artikel terpublikasi')
                ->descriptionIcon('heroicon-m-document-text')
                ->color('primary'),

            Stat::make('Pertanyaan Menunggu', $pendingQuestions)
                ->description($pendingQuestions > 0 ? 'Perlu tanggapan segera' : 'Semua pertanyaan terjawab')
                ->descriptionIcon('heroicon-m-chat-bubble-left-right')
                ->color($pendingQuestions > 0 ? 'danger' : 'success'),

            Stat::make('Halaman Statis', Page::count())
                ->description(Page::published()->count().' halaman aktif')
                ->descriptionIcon('heroicon-m-document-duplicate')
                ->color('info'),

            Stat::make('Total FAQ', Faq::active()->count())
                ->description('Tanya-jawab publik')
                ->descriptionIcon('heroicon-m-question-mark-circle')
                ->color('success'),
        ];
    }
}
