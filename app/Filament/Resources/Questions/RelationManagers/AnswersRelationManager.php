<?php

namespace App\Filament\Resources\Questions\RelationManagers;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\CreateAction;
use Filament\Actions\DeleteAction;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\Toggle;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Schemas\Schema;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class AnswersRelationManager extends RelationManager
{
    protected static string $relationship = 'answers';

    protected static ?string $title = 'Jawaban Resmi';

    public function form(Schema $schema): Schema
    {
        return $schema
            ->components([
                Hidden::make('user_id')
                    ->default(fn () => auth()->id()),
                Textarea::make('body')
                    ->label('Isi Tanggapan / Jawaban')
                    ->rows(6)
                    ->required()
                    ->columnSpanFull(),
                Select::make('status')
                    ->label('Status')
                    ->options([
                        'draft' => 'Draft (Internal)',
                        'published' => 'Dipublikasikan',
                        'rejected' => 'Ditolak',
                    ])
                    ->default('published')
                    ->required(),
                Toggle::make('is_published')
                    ->label('Tampilkan ke Publik (Bisa dibaca di Aplikasi)')
                    ->default(true),
                DateTimePicker::make('answered_at')
                    ->label('Waktu Menjawab')
                    ->default(now()),
            ]);
    }

    public function table(Table $table): Table
    {
        return $table
            ->recordTitleAttribute('body')
            ->columns([
                TextColumn::make('user.name')
                    ->label('Petugas / Penjawab')
                    ->weight('bold'),
                TextColumn::make('body')
                    ->label('Jawaban')
                    ->limit(60)
                    ->searchable(),
                TextColumn::make('status')
                    ->label('Status')
                    ->badge()
                    ->colors([
                        'gray' => 'draft',
                        'success' => 'published',
                        'danger' => 'rejected',
                    ]),
                IconColumn::make('is_published')
                    ->label('Publik')
                    ->boolean(),
                TextColumn::make('answered_at')
                    ->label('Waktu Jawab')
                    ->dateTime()
                    ->sortable(),
            ])
            ->filters([
                //
            ])
            ->headerActions([
                CreateAction::make()
                    ->label('Tulis Jawaban')
                    ->after(function ($record) {
                        if ($record->is_published) {
                            $record->question->update(['status' => 'answered']);
                        }
                    }),
            ])
            ->recordActions([
                EditAction::make()
                    ->after(function ($record) {
                        if ($record->is_published) {
                            $record->question->update(['status' => 'answered']);
                        }
                    }),
                DeleteAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
