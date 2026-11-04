<?php

namespace App\Filament\Resources\Menus\Schemas;

use Filament\Forms\Components\Repeater;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Components\Grid;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class MenuForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make(__('Menu Information'))
                    ->schema([
                        Grid::make(3)->schema([
                            TextInput::make('name')
                                ->label(__('Menu Name'))
                                ->required(),
                            Select::make('location')
                                ->label(__('Menu Location'))
                                ->options([
                                    'header' => __('Header (Top)'),
                                    'footer' => __('Footer (Bottom)'),
                                    'sidebar' => __('Sidebar (Side)'),
                                ])
                                ->default('header')
                                ->required(),
                            Toggle::make('is_active')
                                ->label(__('Active'))
                                ->default(true)
                                ->inline(false),
                        ]),
                    ]),

                Section::make(__('Menu Links List'))
                    ->schema([
                        Repeater::make('items')
                            ->label(__('Menu Items'))
                            ->relationship('items')
                            ->orderColumn('sort_order')
                            ->schema([
                                Grid::make(4)->schema([
                                    TextInput::make('label')
                                        ->label(__('Label'))
                                        ->required(),
                                    TextInput::make('url')
                                        ->label(__('URL / Link'))
                                        ->required(),
                                    Select::make('type')
                                        ->label(__('Type'))
                                        ->options([
                                            'custom' => __('Custom (URL)'),
                                            'page' => __('Static Page'),
                                            'post' => __('Article'),
                                            'category' => __('Category'),
                                        ])
                                        ->default('custom'),
                                    Toggle::make('is_active')
                                        ->label(__('Active'))
                                        ->default(true)
                                        ->inline(false),
                                ]),
                            ])
                            ->defaultItems(1)
                            ->columnSpanFull(),
                    ]),
            ]);
    }
}
