<?php

namespace App\Filament\Resources\Media\Schemas;

use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Grid;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class MediaForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make(__('Upload Media File'))
                    ->schema([
                        Hidden::make('user_id')
                            ->default(fn () => auth()->id()),
                        Hidden::make('disk')
                            ->default('public'),
                        FileUpload::make('file_path')
                            ->label(__('Choose File'))
                            ->directory('uploads')
                            ->visibility('public')
                            ->required()
                            ->columnSpanFull(),
                        Grid::make(2)->schema([
                            TextInput::make('file_name')
                                ->label(__('File Name'))
                                ->required(),
                            TextInput::make('alt_text')
                                ->label(__('Alternative Text (Alt Text)')),
                        ]),
                    ]),
            ]);
    }
}
