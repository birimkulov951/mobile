import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class Contact with EquatableMixin {
  final Uint8List? photo;
  final String name;
  final String phone;

  Contact({
    this.photo,
    this.name = '',
    this.phone = '',
  });

  @override
  List<Object?> get props => [
        photo,
        name,
        phone,
      ];
}
