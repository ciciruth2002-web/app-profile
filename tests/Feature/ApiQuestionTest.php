<?php

namespace Tests\Feature;

use App\Models\Question;
use App\Models\QuestionTopic;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ApiQuestionTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_list_answered_questions(): void
    {
        $topic = QuestionTopic::factory()->create();

        Question::factory()->create([
            'topic_id' => $topic->id,
            'status' => 'answered',
        ]);

        Question::factory()->create([
            'topic_id' => $topic->id,
            'status' => 'pending',
        ]);

        $response = $this->getJson(route('api.v1.questions.index'));

        $response->assertOk()
            ->assertJsonCount(1, 'data');
    }

    public function test_can_submit_new_question(): void
    {
        $topic = QuestionTopic::factory()->create();

        $payload = [
            'topic_id' => $topic->id,
            'name' => 'Warga Peduli',
            'email' => 'warga@gmail.com',
            'phone' => '08123456789',
            'subject' => 'Tanya Jam Buka Pelayanan',
            'body' => 'Mohon info mengenai jam operasional pelayanan dinas.',
        ];

        $response = $this->postJson(route('api.v1.questions.store'), $payload);

        $response->assertStatus(201)
            ->assertJsonPath('data.subject', $payload['subject'])
            ->assertJsonPath('data.status', 'pending');

        $this->assertDatabaseHas('questions', [
            'email' => 'warga@gmail.com',
            'subject' => 'Tanya Jam Buka Pelayanan',
            'status' => 'pending',
        ]);
    }

    public function test_validates_question_submission(): void
    {
        $response = $this->postJson(route('api.v1.questions.store'), []);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['name', 'email', 'subject', 'body']);
    }
}
