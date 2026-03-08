

enum TaskType { math, colorSequence, wordMatch, tapTarget }

class QuantumPost {
  final String id;
  final String teaserText;
  final String fullFactText;
  final TaskType taskType;
  final bool isUnlocked;
  final bool isBookmarked;

  QuantumPost({
    required this.id,
    required this.teaserText,
    required this.fullFactText,
    required this.taskType,
    this.isUnlocked = false,
    this.isBookmarked = false,
  });

  /// Returns a copy with updated interaction state.
  QuantumPost copyWith({
    bool? isUnlocked,
    bool? isBookmarked,
  }) {
    return QuantumPost(
      id: id,
      teaserText: teaserText,
      fullFactText: fullFactText,
      taskType: taskType,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teaserText': teaserText,
      'fullFactText': fullFactText,
      'taskType': taskType.index,
      'isUnlocked': isUnlocked,
      'isBookmarked': isBookmarked,
    };
  }

  factory QuantumPost.fromJson(Map<String, dynamic> json) {
    return QuantumPost(
      id: json['id'] as String,
      teaserText: json['teaserText'] as String,
      fullFactText: json['fullFactText'] as String,
      taskType: TaskType.values[json['taskType'] as int],
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }
}
