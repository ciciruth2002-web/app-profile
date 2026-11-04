<?php

namespace App\Filament\Resources\Posts\Schemas;

use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\RichEditor;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Components\Grid;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Components\Utilities\Set;
use Filament\Schemas\Schema;
use Illuminate\Support\Str;

class PostForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Grid::make(3)->schema([
                    Section::make('Konten Artikel')
                        ->schema([
                            TextInput::make('title')
                                ->label('Judul Artikel')
                                ->required()
                                ->live(onBlur: true)
                                ->afterStateUpdated(fn (Set $set, ?string $state) => $set('slug', Str::slug($state ?? ''))),
                            TextInput::make('slug')
                                ->label('Slug (URL)')
                                ->required()
                                ->unique(ignoreRecord: true),
                            Textarea::make('summary')
                                ->label('Ringkasan Singkat')
                                ->rows(3)
                                ->columnSpanFull(),
                            RichEditor::make('content')
                                ->label('Isi Artikel')
                                ->columnSpanFull(),
                        ])
                        ->columnSpan(2),

                    Section::make('Publikasi & Media')
                        ->schema([
                            Hidden::make('user_id')
                                ->default(fn () => auth()->id()),
                            Select::make('category_id')
                                ->label('Kategori')
                                ->relationship('category', 'name')
                                ->searchable()
                                ->preload()
                                ->required(),
                            FileUpload::make('image')
                                ->label('Gambar Utama')
                                ->image()
                                ->directory('posts')
                                ->visibility('public'),
                            Select::make('status')
                                ->label('Status')
                                ->options([
                                    'draft' => 'Draft',
                                    'published' => 'Diterbitkan',
                                    'archived' => 'Diarsipkan',
                                ])
                                ->default('draft')
                                ->required(),
                            DateTimePicker::make('published_at')
                                ->label('Waktu Publikasi')
                                ->default(now()),
                            Toggle::make('is_featured')
                                ->label('Artikel Unggulan')
                                ->default(false),
                        ])
                        ->columnSpan(1),
                ])->columnSpanFull(),
            ]);
    }
}
