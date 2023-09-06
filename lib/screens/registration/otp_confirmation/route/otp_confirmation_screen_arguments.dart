import 'package:equatable/equatable.dart';

class OtpConfirmationScreenArguments with EquatableMixin {
  final String phoneNumber;

  /// true - флоу авторизации
  /// false - флоу регистрации
  final bool isAuth;

  const OtpConfirmationScreenArguments({
    required this.phoneNumber,
    required this.isAuth,
  });

  @override
  List<Object> get props => [
        phoneNumber,
        isAuth,
      ];
}
