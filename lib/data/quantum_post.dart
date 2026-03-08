

enum TaskType { math, colorSequence, wordMatch, tapTarget }

class QuantumPost {
  final String id;
  final String teaserText;
  final String fullFactText;
  final TaskType taskType;

  QuantumPost({
    required this.id,
    required this.teaserText,
    required this.fullFactText,
    required this.taskType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teaserText': teaserText,
      'fullFactText': fullFactText,
      'taskType': taskType.index,
    };
  }

  factory QuantumPost.fromJson(Map<String, dynamic> json) {
    return QuantumPost(
      id: json['id'] as String,
      teaserText: json['teaserText'] as String,
      fullFactText: json['fullFactText'] as String,
      taskType: TaskType.values[json['taskType'] as int],
    );
  }
}
