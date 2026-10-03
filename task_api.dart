/// A tiny task-management API.
///
/// This library shows how to write documentation that `dart doc` turns into
/// a browsable website. It contains:
///
/// * [Task] - an immutable task object
/// * [TaskStatus] - the lifecycle of a task
/// * [TaskRepository] - the contract for storing tasks
/// * [InMemoryTaskRepository] - a simple implementation backed by a [Map]
/// * [TaskNotFoundException] - thrown when an id does not exist
///
/// ## Quick start
///
/// ```dart
/// import 'package:task_api/task_api.dart';
///
/// void main() {
///   final repo = InMemoryTaskRepository();
///   final task = repo.add('Finish Lab 2');
///   repo.updateStatus(task.id, TaskStatus.done);
///   print(repo.getAll(status: TaskStatus.done));
/// }
/// ```
library;

/// The lifecycle status of a [Task].
enum TaskStatus {
  /// The task was created but nobody started it yet.
  todo,

  /// The task is currently being worked on.
  inProgress,

  /// The task is finished.
  done,
}

/// Thrown when a task with a given [id] does not exist.
class TaskNotFoundException implements Exception {
  /// Creates an exception for the missing task [id].
  const TaskNotFoundException(this.id);

  /// The id that was looked up but not found.
  final int id;

  @override
  String toString() => 'TaskNotFoundException: no task with id $id';
}

/// An immutable unit of work.
///
/// Use [copyWith] to get a modified copy instead of changing a task in place.
class Task {
  /// Creates a task with the given [id] and [title].
  ///
  /// The [status] defaults to [TaskStatus.todo].
  ///
  /// Throws an [ArgumentError] if [title] is empty or only whitespace.
  Task({
    required this.id,
    required this.title,
    this.status = TaskStatus.todo,
  }) {
    if (title.trim().isEmpty) {
      throw ArgumentError.value(title, 'title', 'must not be empty');
    }
  }

  /// Unique identifier of this task.
  final int id;

  /// Short human-readable description of what has to be done.
  final String title;

  /// Current lifecycle [TaskStatus] of this task.
  final TaskStatus status;

  /// Returns a copy of this task with the given fields replaced.
  ///
  /// Fields left as `null` keep their current value. The [id] never changes.
  Task copyWith({String? title, TaskStatus? status}) => Task(
        id: id,
        title: title ?? this.title,
        status: status ?? this.status,
      );

  @override
  String toString() => 'Task(#$id, "$title", ${status.name})';
}

/// Contract for any place where [Task]s can be stored.
///
/// Implement this interface to back the API with a database, a file or a
/// REST service. See [InMemoryTaskRepository] for a working example.
abstract interface class TaskRepository {
  /// Creates and stores a new task with the given [title].
  ///
  /// Returns the stored [Task] with its generated id.
  /// Throws an [ArgumentError] if [title] is empty.
  Task add(String title);

  /// Returns the task with the given [id].
  ///
  /// Throws a [TaskNotFoundException] if no such task exists.
  Task getById(int id);

  /// Returns all stored tasks.
  ///
  /// If [status] is given, only tasks with that [TaskStatus] are returned.
  List<Task> getAll({TaskStatus? status});

  /// Changes the status of the task with the given [id].
  ///
  /// Returns the updated [Task].
  /// Throws a [TaskNotFoundException] if no such task exists.
  Task updateStatus(int id, TaskStatus status);

  /// Deletes the task with the given [id].
  ///
  /// Throws a [TaskNotFoundException] if no such task exists.
  void remove(int id);
}

/// A [TaskRepository] that keeps everything in memory.
///
/// Data is lost when the program ends, which makes this class perfect for
/// tests and demos.
class InMemoryTaskRepository implements TaskRepository {
  final Map<int, Task> _tasks = {};
  int _nextId = 1;

  @override
  Task add(String title) {
    final task = Task(id: _nextId++, title: title);
    _tasks[task.id] = task;
    return task;
  }

  @override
  Task getById(int id) => _tasks[id] ?? (throw TaskNotFoundException(id));

  @override
  List<Task> getAll({TaskStatus? status}) => _tasks.values
      .where((t) => status == null || t.status == status)
      .toList(growable: false);

  @override
  Task updateStatus(int id, TaskStatus status) {
    final updated = getById(id).copyWith(status: status);
    _tasks[id] = updated;
    return updated;
  }

  @override
  void remove(int id) {
    if (_tasks.remove(id) == null) throw TaskNotFoundException(id);
  }
}
