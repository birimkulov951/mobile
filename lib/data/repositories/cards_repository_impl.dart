import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/cards_api.dart';
import 'package:mobile_ultra/data/api/dto/requests/cards/track_payments_request.dart';
import 'package:mobile_ultra/data/mappers/cards/cards_balance_mapper.dart';
import 'package:mobile_ultra/data/mappers/cards/cards_mapper.dart';
import 'package:mobile_ultra/data/mappers/cards/track_payments_mapper.dart';
import 'package:mobile_ultra/data/storages/cards_storage.dart';
import 'package:mobile_ultra/data/storages/database.dart';
import 'package:mobile_ultra/domain/cards/card_addition_entity.dart';
import 'package:mobile_ultra/domain/cards/card_addition_req_entity.dart';
import 'package:mobile_ultra/domain/cards/card_beans_entity.dart';
import 'package:mobile_ultra/domain/cards/card_edit_entity.dart';
import 'package:mobile_ultra/domain/cards/cards_balance_entity.dart';
import 'package:mobile_ultra/domain/cards/track_payments_entity.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/card/model/main_data.dart';
import 'package:mobile_ultra/net/request_error.dart';
import 'package:mobile_ultra/repositories/cards_repository.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/exceptions/card_already_exists_exception.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/exceptions/card_not_active_exception.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/exceptions/card_not_found_exception.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/exceptions/card_not_found_or_sms_info_is_off_exception.dart';

@Singleton(as: CardsRepository)
class CardsRepositoryImpl implements CardsRepository {
  CardsRepositoryImpl(
    this._cardsApi,
    this._cardsStorage,
    this._muDatabase,
  );

  final CardsApi _cardsApi;
  final CardsStorage _cardsStorage;
  final MUDatabase _muDatabase;

  @override
  Future<CardAdditionEntity> cardAdditionHumo(
    CardAdditionReqEntity request,
  ) async {
    try {
      final response = await _cardsApi.cardAdditionHumo(request.toRequest());
      return response.toEntity();
    } on DioError catch (error) {
      final requestError = _getRequestError(error: error);
      throw requestError ?? error;
    }
  }

  @override
  Future<CardAdditionEntity> cardAdditionUzcard(
    CardAdditionReqEntity request,
  ) async {
    try {
      final response = await _cardsApi.cardAdditionUzcard(request.toRequest());
      return response.toEntity();
    } on DioError catch (error) {
      final requestError = _getRequestError(error: error);
      throw requestError ?? error;
    }
  }

  @override
  Future<CardBeansEntity> getCardBeans({bool isFromDB = true}) async {
    if (isFromDB) {
      final savedBeans = await _cardsStorage.readCardBeans();

      if (savedBeans != null &&
          savedBeans.humo!.isNotEmpty &&
          savedBeans.uzcard!.isNotEmpty) {
        return savedBeans;
      }
    }

    final dto = await _cardsApi.getCardBeans();

    final entity = dto.toEntity();

    await _cardsStorage.storeCardBeans(entity);

    return entity;
  }

  @override
  void saveCardToDB(CardAdditionEntity entity) =>
      _cardsStorage.saveCard(entity);

  Exception? _getRequestError({required DioError error}) {
    final errorBody = error.response?.data;
    if (errorBody != null && errorBody is Map<String, dynamic>) {
      final requestError = RequestError.fromJson(errorBody);
      if (requestError.status == 400) {
        if (requestError.detail == 'card_not_found_or_sms_info_is_off') {
          if (requestError.title != null) {
            return CardNotFountOrSmsInfoIsOffException(
              title: requestError.getTitleByLanguage ?? requestError.title!,
            );
          }
        } else if (requestError.detail == 'card_not_found') {
          if (requestError.title != null) {
            return CardNotFoundException(
              title: requestError.getTitleByLanguage ?? requestError.title!,
            );
          }
        } else if (requestError.detail == 'card_already_exists') {
          if (requestError.title != null) {
            return CardAlreadyExistsException(
              title: requestError.getTitleByLanguage ?? requestError.title!,
            );
          }
        } else if (requestError.detail == 'card_not_active') {
          if (requestError.title != null) {
            return CardNotActiveException(
              title: requestError.getTitleByLanguage ?? requestError.title!,
            );
          }
        }
      }
    }
    return null;
  }

  @override
  Future<void> editCard(CardEditEntity cardEditEntity) async {
    await _cardsApi.editCard(cardEditEntity.toRequest());
  }

  @override
  Future<MainData> getAttachedCards() async {
    return await _cardsApi.getAttachedCards();
  }

  @override
  Future<void> removeCards() async {
    await _muDatabase.removeCards();
  }

  @override
  void saveCards(List<AttachedCard> cards) {
    _muDatabase.saveCards(cards);
  }

  @override
  Future<List<AttachedCard>?> readStoredCards() async {
    return await _muDatabase.readStoredCards();
  }

  @override
  Future<CardsBalanceEntity> getCardsBalance() async {
    return (await _cardsApi.getCardsBalance()).toEntity();
  }

  @override
  void updateCardsBalance(CardsBalanceEntity cardsBalanceEntity) {
    _muDatabase.updateCardsBalance(cardsBalanceEntity);
  }

  @override
  Future<void> deleteCard(String token) async {
    await _cardsApi.deleteCard(token);
  }

  @override
  Future<TrackPaymentsEntity> trackPayments({
    required String token,
    required String account,
    required bool subscribe,
  }) async {
    final response = await _cardsApi.trackPayments(TrackPaymentsRequest(
      token: token,
      subscribe: subscribe,
      account: account,
    ));
    return response.toEntity();
  }
}
