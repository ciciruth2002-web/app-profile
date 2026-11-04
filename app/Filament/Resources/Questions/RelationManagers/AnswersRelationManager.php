<?php

namespace App\Filament\Resources\Questions\RelationManagers;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\CreateAction;
use Filament\Actions\DeleteAction;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\Toggle;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Schemas\Schema;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Model;

class AnswersRelationManager extends RelationManager
{
    protected static string $relationship = 'answers';

    public static function getTitle(Model $ownerRecord, string $pageClass): string
    {
        return __('Official Answers');
    }

    public function form(Schema $schema): Schema
    {
        return $schema
            ->components([
                Hidden::make('user_id')
                    ->default(fn () => auth()->id()),
                Textarea::make('body')
                    ->label(__('Response / Answer Content'))
                    ->rows(6)
                    ->required()
                    ->columnSpanFull(),
                Select::make('status')
                    ->label(__('Status'))
                    ->options([
                        'draft' => __('Draft (Internal)'),
                        'published' => __('Published'),
                        'rejected' => __('Rejected'),
                    ])
                    ->default('published')
                    ->required(),
                Toggle::make('is_published')
                    ->label(__('Published to Public (Readable in App)'))
                    ->default(true),
                DateTimePicker::make('answered_at')
                    ->label(__('Answer Time'))
                    ->default(now()),
            ]);
    }

    public function table(Table $table): Table
    {
        return $table
            ->recordTitleAttribute('body')
            ->columns([
                TextColumn::make('user.name')
                    ->label(__('Officer / Responder'))
                    ->weight('bold'),
                TextColumn::make('body')
                    ->label(__('Answer'))
                    ->limit(60)
                    ->searchable(),
                TextColumn::make('status')
                    ->label(__('Status'))
                    ->badge()
                    ->colors([
                        'gray' => 'draft',
                        'success' => 'published',
                        'danger' => 'rejected',
                    ]),
                IconColumn::make('is_published')
                    ->label(__('Public'))
                    ->boolean(),
                TextColumn::make('answered_at')
                    ->label(__('Answered At'))
                    ->dateTime()
                    ->sortable(),
            ])
            ->filters([
                //
            ])
            ->headerActions([
                CreateAction::make()
                    ->label(__('Write Answer'))
                    ->after(function ($record) {
                        if ($record->is_published) {
                            $record->question->update(['status' => 'answered']);
                        }
                    }),
            ])
            ->recordActions([
                EditAction::make()
                    ->after(function ($record) {
                        if ($record->is_published) {
                            $record->question->update(['status' => 'answered']);
                        }
                    }),
                DeleteAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
