// Section 7: Enums  (problems 2, 3, 4, 5, 7)

//7.2
enum Day { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

//7.3
String dayLabel(Day d) => switch (d) {
      Day.saturday || Day.sunday => 'Weekend',
      Day.friday => 'Almost weekend',
      _ => 'Work day',
    };

//7.4
abstract interface class Describable {
  String describe();
}

enum Coffee implements Describable {
  espresso(30, 1.5),
  latte(240, 3.0),
  cappuccino(180, 2.8);

  final int ml;
  final double price;
  const Coffee(this.ml, this.price);

  double get pricePerMl => price / ml; 

  @override
  String describe() => '$name: ${ml}ml for \$${price.toStringAsFixed(2)}';
}

//7.5
Day? parseDay(String raw) => Day.values.asNameMap()[raw.toLowerCase()];

//7.7
enum OrderState {
  created,
  paid,
  shipped,
  delivered,
  cancelled;

  Set<OrderState> get next => switch (this) {
        created => {paid, cancelled},
        paid => {shipped, cancelled},
        shipped => {delivered},
        delivered || cancelled => <OrderState>{},
      };

  bool get isFinal => next.isEmpty;
  bool canGoTo(OrderState to) => next.contains(to);
}

class Order {
  OrderState state = OrderState.created;

  void moveTo(OrderState to) {
    if (!state.canGoTo(to)) {
      throw StateError('Cannot go from ${state.name} to ${to.name}');
    }
    print('${state.name} -> ${to.name}');
    state = to;
  }
}

void main() {
  for (final d in Day.values) {
    print('${d.index}: ${d.name} (${dayLabel(d)})');
  }

  for (final c in Coffee.values) {
    print('${c.describe()} | ${c.pricePerMl.toStringAsFixed(3)} per ml');
  }

  print(parseDay('Friday')); 
  print(parseDay('funday')); 
  try {
    Day.values.byName('funday'); 
  } on ArgumentError catch (e) {
    print('byName failed: ${e.message}');
  }

  final order = Order();
  order.moveTo(OrderState.paid);
  order.moveTo(OrderState.shipped);
  order.moveTo(OrderState.delivered);
  try {
    order.moveTo(OrderState.cancelled);
  } on StateError catch (e) {
    print('Blocked: ${e.message}');
  }
}
