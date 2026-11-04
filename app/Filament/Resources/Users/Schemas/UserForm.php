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
                Section::make('Informasi Pengguna')
                    ->schema([
                        Grid::make(2)->schema([
                            TextInput::make('name')
                                ->label('Nama Lengkap')
                                ->required(),
                            TextInput::make('email')
                                ->label('Email')
                                ->email()
                                ->required()
                                ->unique(ignoreRecord: true),
                            TextInput::make('password')
                                ->label('Kata Sandi')
                                ->password()
                                ->dehydrated(fn ($state) => filled($state))
                                ->required(fn (string $operation): bool => $operation === 'create'),
                            Select::make('role')
                                ->label('Peran (Role)')
                                ->options([
                                    'admin' => 'Administrator',
                                    'editor' => 'Editor (Pengelola Konten)',
                                    'viewer' => 'Viewer (Hanya Baca)',
                                ])
                                ->default('admin')
                                ->required(),
                        ]),
                        FileUpload::make('avatar')
                            ->label('Foto Profil (Avatar)')
                            ->image()
                            ->directory('avatars')
                            ->visibility('public')
                            ->columnSpanFull(),
                    ]),
            ]);
    }
}
