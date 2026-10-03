// Section 6: Classes & Constructors  (problems 2, 3, 4, 5, 7)

//6.2
class Person {
  final String name;
  final int age;
  Person(this.name, this.age);

  @override
  String toString() => 'Person($name, $age)';
}

//6.3
class ValidatedPerson {
  final String name;
  final int age;

  ValidatedPerson(String name, int age)
      : name = _checkName(name),
        age = _checkAge(age);

  static String _checkName(String n) {
    if (n.trim().isEmpty) throw ArgumentError('Name cannot be empty');
    return n.trim();
  }

  static int _checkAge(int a) {
    if (a < 0 || a > 120) throw RangeError.range(a, 0, 120, 'age');
    return a;
  }

  @override
  String toString() => 'ValidatedPerson($name, $age)';
}

//6.4
class AppConfig {
  AppConfig._internal();
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;

  String theme = 'light';
}

//6.5
class Temperature {
  double _celsius = 0;

  double get celsius => _celsius;
  set celsius(double value) {
    if (value < -273.15) throw ArgumentError('Below absolute zero');
    _celsius = value;
  }

  double get fahrenheit => _celsius * 9 / 5 + 32;
  set fahrenheit(double f) => celsius = (f - 32) * 5 / 9;
}

//6.7
class Rectangle {
  final double width, height;

  // primary ("master") constructor
  Rectangle(this.width, this.height);

  // redirect to the primary one
  Rectangle.square(double side) : this(side, side);

  // redirect to another redirecting constructor
  Rectangle.unit() : this.square(1);

  double get area => width * height;
}

void main() {
  print(Person('Abdu', 21));

  print(ValidatedPerson('  Ali ', 20));
  try {
    ValidatedPerson('', 20);
  } on ArgumentError catch (e) {
    print('Caught: $e');
  }

  final a = AppConfig();
  final b = AppConfig();
  a.theme = 'dark';
  print('Same instance? ${identical(a, b)}, theme via b: ${b.theme}');

  final t = Temperature()..celsius = 100;
  print('${t.celsius}C = ${t.fahrenheit}F');
  t.fahrenheit = 32;
  print('${t.celsius}C');
  try {
    t.celsius = -300;
  } on ArgumentError catch (e) {
    print('Caught: $e');
  }

  print(Rectangle(2, 3).area);
  print(Rectangle.square(4).area);
  print(Rectangle.unit().area);
}
