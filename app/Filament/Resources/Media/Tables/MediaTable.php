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
                    ->label('Pratinjau')
                    ->square(),
                TextColumn::make('file_name')
                    ->label('Nama Berkas')
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),
                TextColumn::make('alt_text')
                    ->label('Alt Text')
                    ->searchable(),
                TextColumn::make('user.name')
                    ->label('Pengunggah')
                    ->badge()
                    ->color('gray'),
                TextColumn::make('created_at')
                    ->label('Diupload')
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
