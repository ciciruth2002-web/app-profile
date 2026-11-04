<?php

namespace App\Filament\Resources\Users\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

class UsersTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                ImageColumn::make('avatar')
                    ->label(__('Photo'))
                    ->circular(),
                TextColumn::make('name')
                    ->label(__('Username'))
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),
                TextColumn::make('email')
                    ->label(__('Email'))
                    ->searchable()
                    ->color('gray'),
                TextColumn::make('role')
                    ->label(__('Role'))
                    ->badge()
                    ->colors([
                        'danger' => 'admin',
                        'primary' => 'editor',
                        'gray' => 'viewer',
                    ]),
                TextColumn::make('created_at')
                    ->label(__('Registered'))
                    ->dateTime()
                    ->sortable(),
            ])
            ->filters([
                SelectFilter::make('role')
                    ->label(__('Role'))
                    ->options([
                        'admin' => __('Administrator'),
                        'editor' => __('Editor'),
                        'viewer' => __('Viewer'),
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
