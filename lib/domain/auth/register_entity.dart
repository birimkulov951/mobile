import 'package:equatable/equatable.dart';

class RegisterEntity with EquatableMixin {
  RegisterEntity({
    required this.login,
    required this.email,
    required this.langKey,
  });

  final String login;
  final String email;
  final String langKey;

  @override
  List<Object> get props => [
        login,
        email,
        langKey,
      ];
}
