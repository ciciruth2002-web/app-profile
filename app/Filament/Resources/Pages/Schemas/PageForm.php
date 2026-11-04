<?php

namespace App\Filament\Resources\Pages\Schemas;

use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\RichEditor;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Components\Grid;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Components\Utilities\Set;
use Filament\Schemas\Schema;
use Illuminate\Support\Str;

class PageForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Grid::make(3)->schema([
                    Section::make('Konten Halaman')
                        ->schema([
                            TextInput::make('title')
                                ->label('Judul Halaman')
                                ->required()
                                ->live(onBlur: true)
                                ->afterStateUpdated(fn (Set $set, ?string $state) => $set('slug', Str::slug($state ?? ''))),
                            TextInput::make('slug')
                                ->label('Slug (URL)')
                                ->required()
                                ->unique(ignoreRecord: true),
                            RichEditor::make('content')
                                ->label('Isi Halaman')
                                ->columnSpanFull(),
                        ])
                        ->columnSpan(2),

                    Section::make('Pengaturan & Media')
                        ->schema([
                            Hidden::make('user_id')
                                ->default(fn () => auth()->id()),
                            FileUpload::make('image')
                                ->label('Gambar Sampul')
                                ->image()
                                ->directory('pages')
                                ->visibility('public'),
                            Select::make('status')
                                ->label('Status')
                                ->options([
                                    'draft' => 'Draft',
                                    'published' => 'Diterbitkan',
                                ])
                                ->default('draft')
                                ->required(),
                            TextInput::make('sort_order')
                                ->label('Urutan')
                                ->numeric()
                                ->default(0),
                            Toggle::make('show_in_menu')
                                ->label('Tampilkan di Menu')
                                ->default(false),
                        ])
                        ->columnSpan(1),
                ])->columnSpanFull(),
            ]);
    }
}
