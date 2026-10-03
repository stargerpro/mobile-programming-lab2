// Section 9: Mixins & Interfaces  (problems 2, 3, 4, 5, 6)

//9.2
abstract interface class DBConnector {
  void connect(String host);
  List<Map<String, Object?>> query(String sql);
  void close();
}

class MySQLConnector implements DBConnector {
  bool _open = false;

  @override
  void connect(String host) {
    _open = true;
    print('MySQL connected to $host');
  }

  @override
  List<Map<String, Object?>> query(String sql) {
    if (!_open) throw StateError('Not connected');
    print('Running: $sql');
    return [
      {'id': 1, 'name': 'Alice'},
    ];
  }

  @override
  void close() {
    _open = false;
    print('MySQL connection closed');
  }
}

//9.3
mixin Flyable {
  void fly() => print('$runtimeType is flying');
}

class Bird with Flyable {}

//9.4
mixin Walker {
  void walk() => print('$runtimeType walks');
}

mixin Swimmer {
  void swim() => print('$runtimeType swims');
}

class Duck with Walker, Swimmer, Flyable {}

//9.5
class Animal {
  final String name;
  Animal(this.name);
}

mixin Diver on Animal {
  void dive() => print('$name dives deep'); 
}

class Dolphin extends Animal with Diver {
  Dolphin() : super('Dolphin');
}



//9.6
class Motor {
  void start() => print('Motor starts');
  void stop() => print('Motor stops');
}
class FakeMotor implements Motor {
  @override
  void start() => print('Fake start');
  @override
  void stop() => print('Fake stop');
}

mixin Turbo {
  void boost() => print('Turbo boost!');
}
class SportsMotor extends Motor with Turbo {}

void main() {
  final db = MySQLConnector()..connect('localhost');
  print(db.query('SELECT * FROM users'));
  db.close();

  Bird().fly();

  final d = Duck();
  d
    ..walk()
    ..swim()
    ..fly();

  Dolphin().dive();

  FakeMotor().start();
  SportsMotor()
    ..start()
    ..boost()
    ..stop();
}
