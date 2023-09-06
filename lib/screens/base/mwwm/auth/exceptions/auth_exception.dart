abstract class AuthException implements Exception {}

class AccessDeniedException extends AuthException {}

class ActivationCodeSentException extends AuthException {}

class BadCredentialsException extends AuthException {}

class InvalidTokenException extends AuthException {}
