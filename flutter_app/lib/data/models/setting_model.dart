class SettingModel {
  final int id;
  final String group;
  final String key;
  final dynamic value;
  final String type;

  SettingModel({
    required this.id,
    required this.group,
    required this.key,
    required this.value,
    required this.type,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel(
      id: json['id'] ?? 0,
      group: json['group']?.toString() ?? 'general',
      key: json['key']?.toString() ?? '',
      value: json['value'],
      type: json['type']?.toString() ?? 'text',
    );
  }
}

