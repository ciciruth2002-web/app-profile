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
                    Section::make(__('Page Content'))
                        ->schema([
                            TextInput::make('title')
                                ->label(__('Page Title'))
                                ->required()
                                ->live(onBlur: true)
                                ->afterStateUpdated(fn (Set $set, ?string $state) => $set('slug', Str::slug($state ?? ''))),
                            TextInput::make('slug')
                                ->label(__('Slug (URL)'))
                                ->required()
                                ->unique(ignoreRecord: true),
                            RichEditor::make('content')
                                ->label(__('Page Content Body'))
                                ->columnSpanFull(),
                        ])
                        ->columnSpan(2),

                    Section::make(__('Settings & Media'))
                        ->schema([
                            Hidden::make('user_id')
                                ->default(fn () => auth()->id()),
                            FileUpload::make('image')
                                ->label(__('Cover Image'))
                                ->image()
                                ->directory('pages')
                                ->visibility('public'),
                            Select::make('status')
                                ->label(__('Status'))
                                ->options([
                                    'draft' => __('Draft'),
                                    'published' => __('Published'),
                                ])
                                ->default('draft')
                                ->required(),
                            TextInput::make('sort_order')
                                ->label(__('Sort Order'))
                                ->numeric()
                                ->default(0),
                            Toggle::make('show_in_menu')
                                ->label(__('Show in Menu'))
                                ->default(false),
                        ])
                        ->columnSpan(1),
                ])->columnSpanFull(),
            ]);
    }
}
