import 'package:equatable/equatable.dart';

class PhoneNumberLoginScreenArguments with EquatableMixin {
  final bool forgotPassword;

  const PhoneNumberLoginScreenArguments({
    this.forgotPassword = false,
  });

  @override
  List<Object> get props => [forgotPassword];
}
