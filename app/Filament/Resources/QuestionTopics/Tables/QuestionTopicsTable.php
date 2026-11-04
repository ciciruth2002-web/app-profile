<?php

namespace App\Filament\Resources\QuestionTopics\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\TernaryFilter;
use Filament\Tables\Table;

class QuestionTopicsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('name')
                    ->label(__('Topic Name'))
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),
                TextColumn::make('slug')
                    ->label(__('Slug'))
                    ->color('gray'),
                TextColumn::make('questions_count')
                    ->label(__('Questions'))
                    ->counts('questions')
                    ->badge()
                    ->color('info'),
                TextColumn::make('faqs_count')
                    ->label(__('FAQ'))
                    ->counts('faqs')
                    ->badge()
                    ->color('success'),
                TextColumn::make('sort_order')
                    ->label(__('Sort Order'))
                    ->sortable(),
                IconColumn::make('is_active')
                    ->label(__('Active'))
                    ->boolean(),
            ])
            ->filters([
                TernaryFilter::make('is_active')
                    ->label(__('Active Status')),
            ])
            ->recordActions([
                EditAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
