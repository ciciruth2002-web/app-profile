import 'question_model.dart';

class FaqModel {
  final int id;
  final String question;
  final String answer;
  final int sortOrder;
  final QuestionTopicModel? topic;

  FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.sortOrder,
    this.topic,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'] ?? 0,
      question: json['question']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      sortOrder: json['sort_order'] ?? 0,
      topic: json['topic'] != null
          ? QuestionTopicModel.fromJson(json['topic'])
          : null,
    );
  }
}

