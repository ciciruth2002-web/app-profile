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
            Stat::make(__('Total Articles'), Post::count())
                ->description(__(':count articles published', ['count' => Post::published()->count()]))
                ->descriptionIcon('heroicon-m-document-text')
                ->color('primary'),

            Stat::make(__('Pending Questions'), $pendingQuestions)
                ->description($pendingQuestions > 0 ? __('Needs immediate response') : __('All questions answered'))
                ->descriptionIcon('heroicon-m-chat-bubble-left-right')
                ->color($pendingQuestions > 0 ? 'danger' : 'success'),

            Stat::make(__('Static Pages'), Page::count())
                ->description(__(':count pages active', ['count' => Page::published()->count()]))
                ->descriptionIcon('heroicon-m-document-duplicate')
                ->color('info'),

            Stat::make(__('Total FAQs'), Faq::active()->count())
                ->description(__('Public Q&A'))
                ->descriptionIcon('heroicon-m-question-mark-circle')
                ->color('success'),
        ];
    }
}
