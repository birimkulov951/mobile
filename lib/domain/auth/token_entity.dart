import 'package:equatable/equatable.dart';

class TokenEntity with EquatableMixin {
  TokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        tokenType,
      ];
}
