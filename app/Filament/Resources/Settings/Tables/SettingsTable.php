<?php

namespace App\Filament\Resources\Settings\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

class SettingsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('group')
                    ->label(__('Group'))
                    ->badge()
                    ->sortable()
                    ->searchable(),
                TextColumn::make('key')
                    ->label(__('Key'))
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),
                TextColumn::make('type')
                    ->label(__('Type'))
                    ->badge()
                    ->color('gray'),
                TextColumn::make('value')
                    ->label(__('Value'))
                    ->limit(60)
                    ->searchable(),
                TextColumn::make('updated_at')
                    ->label(__('Last Updated'))
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                SelectFilter::make('group')
                    ->label(__('Group Filter'))
                    ->options([
                        'general' => __('General'),
                        'contact' => __('Contact'),
                        'social' => __('Social Media'),
                        'appearance' => __('Appearance'),
                    ]),
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
