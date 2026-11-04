<?php

namespace App\Filament\Resources\Menus\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

class MenusTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('name')
                    ->label(__('Menu Name'))
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),
                TextColumn::make('location')
                    ->label(__('Location'))
                    ->badge()
                    ->colors([
                        'primary' => 'header',
                        'warning' => 'sidebar',
                        'gray' => 'footer',
                    ]),
                TextColumn::make('items_count')
                    ->label(__('Links Count'))
                    ->counts('items')
                    ->badge(),
                IconColumn::make('is_active')
                    ->label(__('Active Status'))
                    ->boolean(),
                TextColumn::make('updated_at')
                    ->label(__('Updated At'))
                    ->dateTime()
                    ->sortable(),
            ])
            ->filters([
                SelectFilter::make('location')
                    ->label(__('Location'))
                    ->options([
                        'header' => __('Header'),
                        'footer' => __('Footer'),
                        'sidebar' => __('Sidebar'),
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
