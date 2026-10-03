// Section 8: Inheritance  (problems 2, 3, 4, 5, 6)
import 'dart:math';

//8.2
class Animal {
  void makeSound() => print('Some generic sound');
}

class Dog extends Animal {
  @override
  void makeSound() => print('Woof!');
}

//8.3
class Vehicle {
  final String brand;
  Vehicle(this.brand);
}

class ElectricCar extends Vehicle {
  final int batteryKwh;
  ElectricCar(super.brand, this.batteryKwh); 
}

//8.4
abstract class Shape {
  String get name;
  double area();
}

abstract class Polygon extends Shape {
  int get sides;
  double perimeter();

  @override
  String get name => '$sides-sided polygon';
}

class Triangle extends Polygon {
  final double a, b, c;
  Triangle(this.a, this.b, this.c);

  @override
  int get sides => 3;

  @override
  String get name => 'Triangle';

  @override
  double perimeter() => a + b + c;

  @override
  double area() {
    final s = perimeter() / 2; 
    return sqrt(s * (s - a) * (s - b) * (s - c));
  }
}

//8.5
abstract class Employee {
  final String name;
  Employee(this.name);

  double monthlyPay();

  double yearlyPay() => monthlyPay() * 12; 

  void describe() =>
      print('$name earns \$${yearlyPay().toStringAsFixed(0)} a year');
}

class SalariedEmployee extends Employee {
  final double salary;
  SalariedEmployee(super.name, this.salary);

  @override
  double monthlyPay() => salary;
}

class HourlyEmployee extends Employee {
  final double rate;
  final int hours;
  HourlyEmployee(super.name, this.rate, this.hours);

  @override
  double monthlyPay() => rate * hours;
}

//8.6



final class AppSettings {
  final String language;
  const AppSettings(this.language);
}


base class Engine {
  void start() => print('Engine starts');
}

base class V8Engine extends Engine {} 

interface class Logger {
  void log(String m) => print(m);
}



void main() {
  Animal a = Dog();
  a.makeSound();

  final car = ElectricCar('Tesla', 75);
  print('${car.brand} ${car.batteryKwh} kWh');

  final t = Triangle(3, 4, 5);
  print('${t.name}: sides=${t.sides}, perimeter=${t.perimeter()}, area=${t.area()}');

  for (final e in <Employee>[
    SalariedEmployee('Aziz', 2500),
    HourlyEmployee('Dilya', 15, 160),
  ]) {
    e.describe();
  }

  V8Engine().start();
  print(const AppSettings('uz').language);
}
