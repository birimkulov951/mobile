import 'package:equatable/equatable.dart';
import 'package:mobile_ultra/domain/favorite/favorite.dart';

class TransferTemplateRouteArguments with EquatableMixin {
  const TransferTemplateRouteArguments(this.template);

  final FavoriteEntity template;

  @override
  List<Object> get props => [template];
}
