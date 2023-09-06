import 'package:json_annotation/json_annotation.dart';

part 'saved_transfers_response.g.dart';

@JsonSerializable()
class SavedTransfersResponse {
  const SavedTransfersResponse({required this.savedTransfersList});

  @JsonKey(name: 'pageResult', defaultValue: [])
  final List<SavedTransfer> savedTransfersList;

  factory SavedTransfersResponse.fromJson(Map<String, dynamic> json) =>
      _$SavedTransfersResponseFromJson(json);

  @override
  String toString() {
    return 'SavedTransfersResponse{savedTransfersList: $savedTransfersList,}';
  }
}

@JsonSerializable()
class SavedTransfer {
  const SavedTransfer(
    this.id,
    this.name,
    this.pan,
    this.maskedPan,
    this.type,
    this.userId,
    this.date,
    this.token,
    this.bankName,
    this.p2pCheckType,
  );

  final int id;
  final String name;
  final String? pan;
  final String maskedPan;
  final int type;
  final int userId;
  final String date;
  final String? token;
  final String? bankName;
  final String? p2pCheckType;

  factory SavedTransfer.fromJson(Map<String, dynamic> json) =>
      _$SavedTransferFromJson(json);

  @override
  String toString() {
    return 'SavedTransfer{id: $id, name: $name, pan: $pan, maskedPan: $maskedPan, type: $type, userId: $userId, date: $date,}';
  }
}
