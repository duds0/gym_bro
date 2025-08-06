class WorkoutExercise {
  final String id;
  final String workoutId;
  final String exerciseName;
  int exerciseOrderIndex;
  final int series;
  final String repetitions;
  final double weight;
  final double restMinutes;

  WorkoutExercise({
    required this.id,
    required this.workoutId,
    required this.exerciseName,
    required this.exerciseOrderIndex,
    required this.series,
    required this.repetitions,
    required this.weight,
    required this.restMinutes,
  });

  factory WorkoutExercise.fromMap(Map<String, dynamic> map) => WorkoutExercise(
    id: map['id'],
    workoutId: map['workout_id'],
    exerciseName: map['exercise_name'],
    exerciseOrderIndex: map['exercise_order_index'],
    series: map['series'],
    repetitions: map['repetitions'],
    weight: map['weight'],
    restMinutes: map['rest_minutes'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'workout_id': workoutId,
    'exercise_name': exerciseName,
    'exercise_order_index': exerciseOrderIndex,
    'series': series,
    'repetitions': repetitions,
    'weight': weight,
    'rest_minutes': restMinutes,
  };

  @override
  String toString() =>
      'WorkoutExercise(id: $id, workoutId: $workoutId, exerciseName: $exerciseName, exerciseOrderIndex: $exerciseOrderIndex, series: $series, reps: $repetitions, weight: $weight, rest: $restMinutes)';
}
