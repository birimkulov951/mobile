import 'package:equatable/equatable.dart';

class TrackPaymentsEntity with EquatableMixin {
  final bool success;
  final String? subscribedDate;

  const TrackPaymentsEntity({
    required this.success,
    required this.subscribedDate,
  });

  @override
  List<Object?> get props => [
        success,
        subscribedDate,
      ];
}
