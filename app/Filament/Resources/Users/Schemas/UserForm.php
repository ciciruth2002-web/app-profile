<?php

namespace App\Filament\Resources\Users\Schemas;

use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Grid;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class UserForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make(__('User Information'))
                    ->schema([
                        Grid::make(2)->schema([
                            TextInput::make('name')
                                ->label(__('Full Name'))
                                ->required(),
                            TextInput::make('email')
                                ->label(__('Email'))
                                ->email()
                                ->required()
                                ->unique(ignoreRecord: true),
                            TextInput::make('password')
                                ->label(__('Password'))
                                ->password()
                                ->dehydrated(fn ($state) => filled($state))
                                ->required(fn (string $operation): bool => $operation === 'create'),
                            Select::make('role')
                                ->label(__('Role (User Role)'))
                                ->options([
                                    'admin' => __('Administrator'),
                                    'editor' => __('Editor (Content Manager)'),
                                    'viewer' => __('Viewer (Read Only)'),
                                ])
                                ->default('admin')
                                ->required(),
                        ]),
                        FileUpload::make('avatar')
                            ->label(__('Profile Photo (Avatar)'))
                            ->image()
                            ->directory('avatars')
                            ->visibility('public')
                            ->columnSpanFull(),
                    ]),
            ]);
    }
}
