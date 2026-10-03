// Section 10: Polymorphism  (problems 2, 3, 4, 5, 6)
import 'dart:math';

//10.2
abstract class Shape {
  double area();
}

class Circle extends Shape {
  final double r;
  Circle(this.r);
  @override
  double area() => pi * r * r;
}

class Rectangle extends Shape {
  final double w, h;
  Rectangle(this.w, this.h);
  @override
  double area() => w * h;
}

//10.3
void inspect(Object o) {
  if (o is int) {
    print('int, next is ${o + 1}'); // o is auto-promoted to int
  } else if (o is String) {
    print('String of length ${o.length}');
  } else if (o is! Shape) {
    print('Something else: $o');
  } else {
    print('A shape with area ${o.area().toStringAsFixed(2)}');
  }
}

//10.4
class Repository<T> {
  final Map<int, T> _items = {};
  int _nextId = 1;

  int add(T item) {
    _items[_nextId] = item;
    return _nextId++;
  }

  T? getById(int id) => _items[id];
  List<T> all() => List.unmodifiable(_items.values);
}

//10.5
sealed class PaymentResult {}

class Approved extends PaymentResult {
  final String transactionId;
  Approved(this.transactionId);
}

class Declined extends PaymentResult {
  final String reason;
  Declined(this.reason);
}

class Pending extends PaymentResult {}

String describeResult(PaymentResult r) => switch (r) {
      Approved(:final transactionId) => 'Approved #$transactionId',
      Declined(:final reason) => 'Declined: $reason',
      Pending() => 'Still pending...',
    };

//10.6
abstract interface class DiscountStrategy {
  double apply(double price);
}

class NoDiscount implements DiscountStrategy {
  @override
  double apply(double price) => price;
}

class PercentDiscount implements DiscountStrategy {
  final double percent;
  PercentDiscount(this.percent);
  @override
  double apply(double price) => price * (1 - percent / 100);
}

class FlatDiscount implements DiscountStrategy {
  final double amount;
  FlatDiscount(this.amount);
  @override
  double apply(double price) => max(0, price - amount);
}

class Cart {
  DiscountStrategy strategy; // swappable at runtime
  Cart(this.strategy);
  double total(double price) => strategy.apply(price);
}

void main() {
  final shapes = <Shape>[Circle(2), Rectangle(3, 4)];
  for (final s in shapes) {
    print('${s.runtimeType}: ${s.area().toStringAsFixed(2)}');
  }

  inspect(41);
  inspect('hello');
  inspect(Circle(1));
  inspect(3.14);

  Object x = 42;
  try {
    final s = x as String; 
    print(s);
  } catch (e) {
    print('Cast failed: $e');
  }

  final repo = Repository<String>();
  final id = repo.add('Dart');
  repo.add('Flutter');
  print('${repo.getById(id)} | ${repo.all()}');
  final numbers = Repository<int>()..add(10);
  print(numbers.all());

  for (final r in <PaymentResult>[Approved('A1'), Declined('No funds'), Pending()]) {
    print(describeResult(r));
  }

  final cart = Cart(NoDiscount());
  print(cart.total(100)); // 100.0
  cart.strategy = PercentDiscount(20);
  print(cart.total(100)); // 80.0
  cart.strategy = FlatDiscount(30);
  print(cart.total(100)); // 70.0
}
