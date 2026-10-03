import 'package:task_api/task_api.dart';

void main() {
  final repo = InMemoryTaskRepository();

  final a = repo.add('Finish Lab 2');
  repo.add('Study for OS exam');
  repo.updateStatus(a.id, TaskStatus.done);

  print('All:  ${repo.getAll()}');
  print('Done: ${repo.getAll(status: TaskStatus.done)}');

  try {
    repo.getById(99);
  } on TaskNotFoundException catch (e) {
    print(e);
  }
}
