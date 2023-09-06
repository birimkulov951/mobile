import 'package:equatable/equatable.dart';

class NotificationScreenArguments with EquatableMixin {
  const NotificationScreenArguments({this.newsId});

  final int? newsId;

  @override
  List<Object?> get props => [newsId];
}
