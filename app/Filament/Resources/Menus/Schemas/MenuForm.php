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
                Section::make('Informasi Menu')
                    ->schema([
                        Grid::make(3)->schema([
                            TextInput::make('name')
                                ->label('Nama Menu')
                                ->required(),
                            Select::make('location')
                                ->label('Lokasi Menu')
                                ->options([
                                    'header' => 'Header (Atas)',
                                    'footer' => 'Footer (Bawah)',
                                    'sidebar' => 'Sidebar (Samping)',
                                ])
                                ->default('header')
                                ->required(),
                            Toggle::make('is_active')
                                ->label('Aktif')
                                ->default(true)
                                ->inline(false),
                        ]),
                    ]),

                Section::make('Daftar Tautan Menu')
                    ->schema([
                        Repeater::make('items')
                            ->label('Item Menu')
                            ->relationship('items')
                            ->orderColumn('sort_order')
                            ->schema([
                                Grid::make(4)->schema([
                                    TextInput::make('label')
                                        ->label('Label')
                                        ->required(),
                                    TextInput::make('url')
                                        ->label('URL / Tautan')
                                        ->required(),
                                    Select::make('type')
                                        ->label('Tipe')
                                        ->options([
                                            'custom' => 'Kustom (URL)',
                                            'page' => 'Halaman Statis',
                                            'post' => 'Artikel',
                                            'category' => 'Kategori',
                                        ])
                                        ->default('custom'),
                                    Toggle::make('is_active')
                                        ->label('Aktif')
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
