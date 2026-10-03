// Section 11: Async Operations  (problems 2, 3, 4, 5, 6)
import 'dart:async';

//11.2
Future<Map<String, Object>> lookupUser(int id) async {
  await Future.delayed(const Duration(seconds: 2));
  return {'id': id, 'name': 'Abduraxmon', 'role': 'student'};
}

//11.3
Future<String> task(String name, int seconds) async {
  await Future.delayed(Duration(seconds: seconds));
  print('$name finished');
  return '$name result';
}

Future<void> runConcurrently() async {
  final sw = Stopwatch()..start();
  final results = await Future.wait([
    task('A', 1),
    task('B', 2),
    task('C', 3),
  ]);
  print('$results in ${sw.elapsed.inSeconds}s');
}

//11.4
Future<void> tickDemo() {
  final done = Completer<void>();
  late StreamSubscription<int> sub;
  var count = 0;

  sub = Stream.periodic(const Duration(milliseconds: 400), (i) => i).listen(
    (tick) {
      count++;
      print('tick #$count (value $tick)');
      if (count == 5) {
        sub.cancel();
        print('Cancelled after 5 emissions');
        done.complete();
      }
    },
  );
  return done.future;
}

//11.5
Future<void> transformDemo() async {
  final source = Stream.fromIterable([1, 1, 2, 3, 3, 4, 5, 5, 6]);

  final result = source
      .distinct() //          
      .where((n) => n.isEven) 
      .map((n) => n * n); 

  await for (final v in result) {
    print('value: $v');
  }
}

//11.6
Future<void> errorDemo() async {
  final source = Stream<int>.fromFutures([
    Future.value(1),
    Future<int>.error(const FormatException('bad data')),
    Future.value(3),
  ]);

  final safe = source.handleError((Object e, StackTrace st) {
    print('Handled error: $e');
  });

  await for (final v in safe) {
    print('got $v');
  }
  print('Stream finished');
}

Future<void> main() async {
  print('--- 11.2 ---');
  print(await lookupUser(1024));

  print('--- 11.3 ---');
  await runConcurrently();

  print('--- 11.4 ---');
  await tickDemo();

  print('--- 11.5 ---');
  await transformDemo();

  print('--- 11.6 ---');
  await errorDemo();
}
