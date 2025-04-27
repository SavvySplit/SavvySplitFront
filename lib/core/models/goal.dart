// class Goal {
//   final String id;
//   final String title;
//   final double targetAmount;
//   final double currentAmount;

//   Goal({
//     required this.id,
//     required this.title,
//     required this.targetAmount,
//     required this.currentAmount,
//   });

//   // Add a progress getter to compute the percentage
//   double get progress =>
//       (currentAmount / targetAmount.clamp(0.01, double.infinity)) * 100;
// }

class Goal {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;

  Goal({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
  });

  double get progress =>
      (currentAmount / targetAmount.clamp(0.01, double.infinity)) * 100;
}
