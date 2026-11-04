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
                    Section::make(__('Question Details'))
                        ->schema([
                            TextInput::make('subject')
                                ->label(__('Question Subject'))
                                ->required()
                                ->columnSpanFull(),
                            Textarea::make('body')
                                ->label(__('Full Question Content'))
                                ->rows(6)
                                ->required()
                                ->columnSpanFull(),
                        ])
                        ->columnSpan(2),

                    Section::make(__('Questioner Information & Status'))
                        ->schema([
                            Select::make('topic_id')
                                ->label(__('Topic'))
                                ->relationship('topic', 'name')
                                ->searchable()
                                ->preload(),
                            TextInput::make('name')
                                ->label(__('Full Name'))
                                ->required(),
                            TextInput::make('email')
                                ->label(__('Email Address'))
                                ->email()
                                ->required(),
                            TextInput::make('phone')
                                ->label(__('Phone Number / WhatsApp')),
                            Select::make('status')
                                ->label(__('Question Status'))
                                ->options([
                                    'pending' => __('Waiting for Answer'),
                                    'answered' => __('Answered'),
                                    'rejected' => __('Rejected'),
                                ])
                                ->default('pending')
                                ->required(),
                            TextInput::make('ip_address')
                                ->label(__('IP Address'))
                                ->disabled(),
                        ])
                        ->columnSpan(1),
                ])->columnSpanFull(),
            ]);
    }
}
