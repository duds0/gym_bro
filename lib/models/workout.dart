class Workout {
  final String id;
  final String name;
  final int orderIndex;
  final int frequency;
  int frequencyThisWeek;

  Workout({
    required this.frequency,
    required this.id,
    required this.name,
    required this.orderIndex,
    required this.frequencyThisWeek,
  });

  factory Workout.fromMap(Map<String, dynamic> map) => Workout(
    id: map['id'],
    name: map['name'],
    orderIndex: map['order_index'],
    frequency: map['frequency'],
    frequencyThisWeek: map['frequency_this_week'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'order_index': orderIndex,
    'frequency': frequency,
    'frequency_this_week': frequencyThisWeek,
  };

  @override
  String toString() =>
      'Workout(id: $id, name: $name, orderIndex: $orderIndex, frequency: $frequency, frequencyThisWeek: $frequencyThisWeek)';
}
