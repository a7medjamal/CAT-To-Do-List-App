// lib/features/tasks/domain/entities/task.dart
import 'package:equatable/equatable.dart'; // Import equatable

class Task extends Equatable { // Extend Equatable for easier comparison
  final String id;
  final String title;
  final String description;
  final String category;
  final bool isCompleted;
  final DateTime timestamp;

  const Task({ // Make constructor const
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.isCompleted,
    required this.timestamp,
  });

  // Add copyWith method (implementation moved to extension in repository file for simplicity here)
  // Or define it directly here if preferred
   Task copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    bool? isCompleted,
    DateTime? timestamp,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      timestamp: timestamp ?? this.timestamp,
    );
  }


  @override
  List<Object?> get props => [id, title, description, category, isCompleted, timestamp];
}

