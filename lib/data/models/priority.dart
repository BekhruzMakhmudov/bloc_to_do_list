import 'package:hive/hive.dart';

part 'priority.g.dart';

@HiveType(typeId: 1)
enum Priority {
  @HiveField(0)
  high,
  @HiveField(1)
  medium,
  @HiveField(2)
  low,
}