// Section 12: Exceptions & Error Handling  (problems 2, 3, 4, 5, 6)

//12.2
int safeDivide(int a, int b) {
  try {
    return a ~/ b;
  } on UnsupportedError catch (e) {
    print('Caught UnsupportedError: $e');
    return 0;
  } catch (e) {
    print('Caught something else: $e');
    return 0;
  }
}

//12.3
String greet(String? name) {
  if (name == null) throw ArgumentError.notNull('name');
  if (name.trim().isEmpty) {
    throw ArgumentError.value(name, 'name', 'must not be empty');
  }
  return 'Hello, ${name.trim()}!';
}

//12.4
void process(String input) {
  try {
    final n = int.parse(input);
    final list = [10, 20, 30];
    print('list[$n] = ${list[n]}');
  } on FormatException catch (e) {
    print('"$input" is not a number (${e.message})');
  } on RangeError catch (e) {
    print('Index out of range: ${e.message}');
  } catch (e) {
    print('Unexpected error: $e'); 
  } finally {
    print('finished processing "$input"');
  }
}
//12.5
void level3() => int.parse('not-a-number');
void level2() => level3();
void level1() => level2();

void stackTraceDemo() {
  try {
    level1();
  } catch (e, stackTrace) {
    print('Error: $e');
    print('Stack trace:\n$stackTrace');
  }
  print('Current stack:\n${StackTrace.current}');
}

//12.6
int parseOrLog(String s) {
  try {
    return int.parse(s);
  } on FormatException {
    print('LOG: failed to parse "$s"');
    rethrow; 
  }
}

void main() {
  print('--- 12.2 ---');
  print(safeDivide(10, 2));
  print(safeDivide(10, 0));

  print('--- 12.3 ---');
  for (final value in <String?>['Abdu', '', null]) {
    try {
      print(greet(value));
    } on ArgumentError catch (e) {
      print('ArgumentError: $e');
    }
  }

  print('--- 12.4 ---');
  process('1');
  process('abc');
  process('7');

  print('--- 12.5 ---');
  stackTraceDemo();

  print('--- 12.6 ---');
  try {
    parseOrLog('42x');
  } catch (e) {
    print('Caller received: $e');
  }
}
