import 'package:equatable/equatable.dart';

class PhoneContactEntity with EquatableMixin {
  PhoneContactEntity({
    required this.name,
    required this.phone,
  });

  final String name;
  final String phone;

  @override
  List<Object?> get props => [name, phone];
}
