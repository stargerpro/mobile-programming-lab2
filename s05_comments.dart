// Section 5: Comments & Documentation  (problems 2, 3, 4, 5, 7)
import 'dart:math';

//5.2
double hypotenuse(double a, double b) {
  // Single-line: Pythagorean theorem, c = sqrt(a^2 + b^2)
  /* Multi-line: squaring first means the sign of a or b
     does not matter, so negative inputs give the same answer. */
  return sqrt(a * a + b * b);
}

//5.3
class Validator {
  const Validator._();

  /// Returns `true` if [email] looks like a valid email address.
  ///
  /// Throws an [ArgumentError] if [email] is empty.
  static bool isEmail(String email) {
    if (email.isEmpty) {
      throw ArgumentError.value(email, 'email', 'must not be empty');
    }
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  /// Parses [raw] into an age between 0 and 150.
  ///
  /// Returns the parsed age.
  /// Throws a [FormatException] if [raw] is not a number.
  /// Throws a [RangeError] if the number is outside 0-150.
  static int parseAge(String raw) {
    final age = int.tryParse(raw);
    if (age == null) throw FormatException('Not a number', raw);
    if (age < 0 || age > 150) throw RangeError.range(age, 0, 150, 'age');
    return age;
  }
}

//5.4
/// Calculates **compound interest** on a deposit.
///
/// Parameters:
/// * [principal] - the starting amount
/// * [rate] - yearly rate as a decimal (`0.05` means 5%)
/// * [years] - number of years the money stays invested
///
/// Example:
/// ```dart
/// final total = compound(1000, 0.05, 10);
/// print(total.toStringAsFixed(2)); // 1628.89
/// ```
double compound(double principal, double rate, int years) =>
    principal * pow(1 + rate, years);

// ---------- 5.5 @Deprecated and @override with doc comments ----------
/// Base class for anything that can send a message.
class Notifier {
  /// Sends [message] to the user.
  void send(String message) => print('Notifier: $message');

  /// Old name of [send].
  ///
  /// Deprecated: use [send] instead, this will be removed in v2.
  @Deprecated('Use send() instead')
  void push(String message) => send(message);
}

/// A [Notifier] that tags every message as an email.
class EmailNotifier extends Notifier {
  /// Overrides [Notifier.send] to add an `[email]` prefix.
  @override
  void send(String message) => super.send('[email] $message');
}

void main() {
  print(hypotenuse(3, 4)); // 5.0
  print(Validator.isEmail('abdu@nuu.uz')); // true
  print(Validator.parseAge('21')); // 21
  print(compound(1000, 0.05, 10).toStringAsFixed(2));
  EmailNotifier().send('Hello'); // [email] Hello
}
