class QuestionTopicModel {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? icon;

  QuestionTopicModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
  });

  factory QuestionTopicModel.fromJson(Map<String, dynamic> json) {
    return QuestionTopicModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString(),
      icon: json['icon']?.toString(),
    );
  }
}

class QuestionAnswerModel {
  final int id;
  final String body;
  final String? answeredAt;
  final String? answeredBy;

  QuestionAnswerModel({
    required this.id,
    required this.body,
    this.answeredAt,
    this.answeredBy,
  });

  factory QuestionAnswerModel.fromJson(Map<String, dynamic> json) {
    return QuestionAnswerModel(
      id: json['id'] ?? 0,
      body: json['body']?.toString() ?? '',
      answeredAt: json['answered_at']?.toString(),
      answeredBy: json['user']?['name']?.toString() ?? json['author']?.toString(),
    );
  }
}

class QuestionModel {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String subject;
  final String body;
  final String status;
  final String? createdAt;
  final QuestionTopicModel? topic;
  final QuestionAnswerModel? answer;

  QuestionModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    required this.subject,
    required this.body,
    required this.status,
    this.createdAt,
    this.topic,
    this.answer,
  });

  bool get isAnswered => status == 'answered' || answer != null;

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      subject: json['subject']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['created_at']?.toString(),
      topic: json['topic'] != null
          ? QuestionTopicModel.fromJson(json['topic'])
          : null,
      answer: json['answer'] != null
          ? QuestionAnswerModel.fromJson(json['answer'])
          : null,
    );
  }
}

