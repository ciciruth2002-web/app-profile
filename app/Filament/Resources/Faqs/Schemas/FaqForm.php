<?php

namespace App\Filament\Resources\Faqs\Schemas;

use Filament\Forms\Components\RichEditor;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Components\Grid;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class FaqForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Informasi FAQ')
                    ->schema([
                        Grid::make(2)->schema([
                            Select::make('topic_id')
                                ->label('Topik Kategori')
                                ->relationship('topic', 'name')
                                ->searchable()
                                ->preload(),
                            TextInput::make('sort_order')
                                ->label('Urutan Tampil')
                                ->numeric()
                                ->default(0),
                        ]),
                        TextInput::make('question')
                            ->label('Pertanyaan (FAQ)')
                            ->required()
                            ->columnSpanFull(),
                        RichEditor::make('answer')
                            ->label('Jawaban Lengkap')
                            ->required()
                            ->columnSpanFull(),
                        Toggle::make('is_active')
                            ->label('Aktif Ditampilkan')
                            ->default(true),
                    ]),
            ]);
    }
}
