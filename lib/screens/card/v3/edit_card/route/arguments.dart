import 'package:equatable/equatable.dart';
import 'package:mobile_ultra/net/card/model/card.dart';

class EditCardScreenArguments with EquatableMixin {
  final AttachedCard attachedCard;

  EditCardScreenArguments({required this.attachedCard});

  @override
  List<Object> get props => [attachedCard];
}
