<?php

namespace App\Filament\Resources\Media\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class MediaTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                ImageColumn::make('file_path')
                    ->label(__('Preview'))
                    ->square(),
                TextColumn::make('file_name')
                    ->label(__('File Name'))
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),
                TextColumn::make('alt_text')
                    ->label(__('Alt Text'))
                    ->searchable(),
                TextColumn::make('user.name')
                    ->label(__('Uploader'))
                    ->badge()
                    ->color('gray'),
                TextColumn::make('created_at')
                    ->label(__('Uploaded At'))
                    ->dateTime()
                    ->sortable(),
            ])
            ->filters([
                //
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
