<?php

namespace App\Filament\Resources\Questions\Schemas;

use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Grid;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class QuestionForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Grid::make(3)->schema([
                    Section::make('Rincian Pertanyaan')
                        ->schema([
                            TextInput::make('subject')
                                ->label('Subjek Pertanyaan')
                                ->required()
                                ->columnSpanFull(),
                            Textarea::make('body')
                                ->label('Isi Pertanyaan Lengkap')
                                ->rows(6)
                                ->required()
                                ->columnSpanFull(),
                        ])
                        ->columnSpan(2),

                    Section::make('Informasi Penanya & Status')
                        ->schema([
                            Select::make('topic_id')
                                ->label('Topik')
                                ->relationship('topic', 'name')
                                ->searchable()
                                ->preload(),
                            TextInput::make('name')
                                ->label('Nama Lengkap')
                                ->required(),
                            TextInput::make('email')
                                ->label('Alamat Email')
                                ->email()
                                ->required(),
                            TextInput::make('phone')
                                ->label('No. Telepon / WhatsApp'),
                            Select::make('status')
                                ->label('Status Pertanyaan')
                                ->options([
                                    'pending' => 'Menunggu Jawaban',
                                    'answered' => 'Sudah Dijawab',
                                    'rejected' => 'Ditolak',
                                ])
                                ->default('pending')
                                ->required(),
                            TextInput::make('ip_address')
                                ->label('Alamat IP')
                                ->disabled(),
                        ])
                        ->columnSpan(1),
                ])->columnSpanFull(),
            ]);
    }
}
