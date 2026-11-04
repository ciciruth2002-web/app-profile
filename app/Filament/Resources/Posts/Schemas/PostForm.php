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
                    Section::make(__('Article Content'))
                        ->schema([
                            TextInput::make('title')
                                ->label(__('Article Title'))
                                ->required()
                                ->live(onBlur: true)
                                ->afterStateUpdated(fn (Set $set, ?string $state) => $set('slug', Str::slug($state ?? ''))),
                            TextInput::make('slug')
                                ->label(__('Slug (URL)'))
                                ->required()
                                ->unique(ignoreRecord: true),
                            Textarea::make('summary')
                                ->label(__('Short Summary'))
                                ->rows(3)
                                ->columnSpanFull(),
                            RichEditor::make('content')
                                ->label(__('Article Content Body'))
                                ->columnSpanFull(),
                        ])
                        ->columnSpan(2),

                    Section::make(__('Publication & Media'))
                        ->schema([
                            Hidden::make('user_id')
                                ->default(fn () => auth()->id()),
                            Select::make('category_id')
                                ->label(__('Category'))
                                ->relationship('category', 'name')
                                ->searchable()
                                ->preload()
                                ->required(),
                            FileUpload::make('image')
                                ->label(__('Main Image'))
                                ->image()
                                ->directory('posts')
                                ->visibility('public'),
                            Select::make('status')
                                ->label(__('Status'))
                                ->options([
                                    'draft' => __('Draft'),
                                    'published' => __('Published'),
                                    'archived' => __('Archived'),
                                ])
                                ->default('draft')
                                ->required(),
                            DateTimePicker::make('published_at')
                                ->label(__('Publication Time'))
                                ->default(now()),
                            Toggle::make('is_featured')
                                ->label(__('Featured Article'))
                                ->default(false),
                        ])
                        ->columnSpan(1),
                ])->columnSpanFull(),
            ]);
    }
}
