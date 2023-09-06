import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ultra/main.dart' show homeData, locale;
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/history/history_presenter.dart';
import 'package:mobile_ultra/net/history/modal/filter_date.dart';
import 'package:mobile_ultra/net/history/modal/history.dart' as h;
import 'package:mobile_ultra/net/history/modal/tran_type.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/history/arguments/filter_btm_sheet_arg.dart';
import 'package:mobile_ultra/screens/main/history/arguments/history_down_container_arg.dart';
import 'package:mobile_ultra/screens/main/history/widgets/card_detail_btm_sheet.dart';
import 'package:mobile_ultra/screens/main/history/widgets/down_conteiner_header.dart';
import 'package:mobile_ultra/screens/main/history/widgets/filter_btm_sheet.dart';
import 'package:mobile_ultra/screens/main/history/widgets/history_transaction_item.dart';
import 'package:mobile_ultra/screens/main/history/widgets/history_up_container.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:ui_kit/ui_kit.dart';

const _appBarTitleScale = 1.6;

class HistoryDownContainer extends StatefulWidget {
  const HistoryDownContainer({super.key});

  @override
  State<HistoryDownContainer> createState() => _HistoryDownContainerState();
}

class _HistoryDownContainerState extends State<HistoryDownContainer>
    with HistoryView {
  bool identificationLoading = true;
  bool containerLoading = false;
  bool _filterIsPressed = false;
  bool _chargeIsPressed = false;
  bool _withdrawIsPressed = false;
  String debitOrCredit = '';
  List<bool> _isCardSelected = [];
  String defaultStartTime = DateFormat("yyyy-MM-ddT00:00:00").format(
    DateTime.now().subtract(const Duration(days: 3)),
  );
  String defaultEndTime = DateFormat("yyyy-MM-ddT23:59:00").format(
    DateTime.now(),
  );

  Completer? getHistoryCompleter;

  List<h.HistoryResponse> list = [];
  num debitSumMonth = 0;

  PeriodDateType? filterResult;

  bool get _filterApplied {
    return _chargeIsPressed || _withdrawIsPressed || filterResult != null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getCardInfo();
  }

  @override
  void onHistory({
    required bool isLoading,
    List<h.HistoryResponse>? history,
    String? error,
    dynamic errorBody,
  }) {
    if (history != null) {
      if (mounted) {
        setState(() {
          identificationLoading = isLoading;
          containerLoading = isLoading;
          list = history;
        });
      }
    } else {
      setState(() {
        identificationLoading = isLoading;
        containerLoading = isLoading;
      });
    }
    if (error != null) {
      onFail(_errorMessageDesc(error));
      return;
    }
    if (getHistoryCompleter != null && !getHistoryCompleter!.isCompleted) {
      getHistoryCompleter?.complete();
    }
  }

  void onMonthDebitSum({num? debitSum, String? error, dynamic errorBody}) {
    if (debitSum != null) {
      setState(() {
        debitSumMonth = debitSum;
      });
    }
  }

  void onFail(String error) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => showMessage(
            context, locale.getText('error'), error,
            onSuccess: () => Navigator.pop(context)),
      );

  String _errorMessageDesc(String message) {
    return message;
  }

  void checkType(PeriodDateType? type) {
    if (type!.headerButtonType != '') {
      if (type.headerButtonType == TranType.credit.value) {
        setState(() {
          _chargeIsPressed = true;
          _withdrawIsPressed = false;
        });
      } else if (type.headerButtonType == TranType.debit.value) {
        setState(() {
          _withdrawIsPressed = true;
          _chargeIsPressed = false;
        });
      }
    } else {
      setState(() {
        _chargeIsPressed = false;
        _withdrawIsPressed = false;
      });
    }
  }

  void getCardInfo({bool isRefreshScreen = false}) {
    final List<Carrd> cardData = [];
    Map<String, String> jsonMap = {};

    final cards = homeData?.cards ?? [];

    for (final i in cards) {
      cardData.add(Carrd(type: i.type, card: i.token));
    }

    setState(() {});

    debitOrCreditType();

    debitOrCredit.isNotEmpty
        ? jsonMap = {
            "date7.greaterThan":
                filterResult?.dates?.startDate ?? defaultStartTime + "Z",
            "date7.lessThan":
                filterResult?.dates?.endDate ?? defaultEndTime + "Z",
            "page": "0",
            "size": "500",
            "sort": "500",
            "type": debitOrCredit,
          }
        : jsonMap = {
            "date7.greaterThan":
                filterResult?.dates?.startDate ?? defaultStartTime + "Z",
            "date7.lessThan":
                filterResult?.dates?.endDate ?? defaultEndTime + "Z",
            "page": "0",
            "size": "500",
            "sort": "500",
          };

    final t = Uri.http("", "", jsonMap);

    HistoryPresenter.history(this, t.query)
        .postHistory(cardData: PeriodDateType(cardData: cardData));

    if (!isRefreshScreen) setState(() => containerLoading = true);
  }

  Future<void> getCardInfoByCards(List<Carrd> cardData) async {
    Map<String, String> jsonMap = {};

    setState(() {});

    debitOrCreditType();

    debitOrCredit.isNotEmpty
        ? jsonMap = {
            "date7.greaterThan":
                filterResult?.dates?.startDate ?? defaultStartTime + "Z",
            "date7.lessThan":
                filterResult?.dates?.endDate ?? defaultEndTime + "Z",
            "page": "0",
            "size": "500",
            "sort": "500",
            "type": debitOrCredit,
          }
        : jsonMap = {
            "date7.greaterThan":
                filterResult?.dates?.startDate ?? defaultStartTime + "Z",
            "date7.lessThan":
                filterResult?.dates?.endDate ?? defaultEndTime + "Z",
            "page": "0",
            "size": "500",
            "sort": "500",
          };

    final t = Uri.http("", "", jsonMap);

    HistoryPresenter.history(this, t.query)
        .postHistory(cardData: PeriodDateType(cardData: cardData));

    setState(() => containerLoading = true);
  }

  Future<void> getCardInfoWithResult(String filterType) async {
    final List<Carrd> cardData = [];
    Map<String, String> jsonMap;
    if (filterResult?.periodType?.type != "") {
      identificationLoading = true;

      filterType.isNotEmpty
          ? jsonMap = {
              "date7.greaterThan": filterResult?.dates?.startDate ?? '',
              "date7.lessThan": filterResult?.dates?.endDate ?? '',
              "page": "0",
              "size": "500",
              "sort": "500",
              "type": filterType,
            }
          : jsonMap = {
              "date7.greaterThan": filterResult?.dates?.startDate ?? '',
              "date7.lessThan": filterResult?.dates?.endDate ?? '',
              "page": "0",
              "size": "500",
              "sort": "500",
            };

      final cards = filterResult?.cardData ?? [];

      if (cards.isEmpty) {
        final userCards = homeData?.cards ?? [];

        for (final AttachedCard i in userCards) {
          cardData.add(Carrd(type: i.type, card: i.token));
        }
      } else {
        for (final i in cards) {
          cardData.add(Carrd(type: i.type, card: i.card));
        }
      }

      setState(() {});

      final t = Uri.http("", "", jsonMap);
      HistoryPresenter.history(this, t.query)
          .postHistory(cardData: PeriodDateType(cardData: cardData));

      setState(() => containerLoading = true);
    }
  }

  String debitOrCreditType() {
    if (_chargeIsPressed) {
      setState(() {
        debitOrCredit = TranType.credit.value;
      });
    } else if (_withdrawIsPressed) {
      setState(() {
        debitOrCredit = TranType.debit.value;
      });
    } else {
      debitOrCredit = '';
    }

    return debitOrCredit;
  }

  Future<void> onRefresh() async {
    getHistoryCompleter = Completer();

    getCardInfo(isRefreshScreen: true);

    await getHistoryCompleter?.future;
  }

  SliverChildDelegate get _itemListDelegate {
    final count = _actualListLength;
    return SliverChildBuilderDelegate(
      (context, index) {
        if (index == count - 1) {
          return Container(
            height: 24,
            decoration: const BoxDecoration(
              color: ColorNode.ContainerColor,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
          );
        }
        final h.HistoryResponse historyItem = list[index];

        if (index == 0 ||
            historyItem.date7?.split('T').first !=
                list[index - 1].date7?.split('T').first) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: ColorNode.ContainerColor,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 36,
                  right: 16,
                  bottom: 12,
                ),
                child: Text(
                  dateFormatHistory(list[index].date7),
                  style: TextStylesX.textMedium,
                ),
              ),
              HistoryTransactionItem(
                id: historyItem.id,
                pan: historyItem.pan ?? '',
                title: historyItem.merchantName ?? '',
                subtitle: historyItem.pin ?? '',
                price:
                    "${formatAmount((historyItem.amount?.toDouble() ?? 0) / 100)} ${locale.getText('sum')}",
                date7: historyItem.date7,
                tranType: historyItem.tranType ?? '',
                merchantHash: historyItem.merchantHash,
                status: historyItem.status ?? 'ROK',
                card1: historyItem.card1 ?? '',
                fio: historyItem.fio,
                account: historyItem.account,
                onTap: () => _onHistoryItemTap(historyItem),
              ),
            ],
          );
        } else {
          return HistoryTransactionItem(
            id: historyItem.id,
            pan: historyItem.pan ?? '',
            tranType: historyItem.tranType ?? '',
            title: historyItem.merchantName ?? '',
            subtitle: historyItem.pin ?? '',
            price:
                "${formatAmount((historyItem.amount?.toDouble() ?? 0) / 100)} ${locale.getText('sum')}",
            date7: historyItem.date7,
            merchantHash: historyItem.merchantHash,
            status: historyItem.status ?? 'ROK',
            card1: historyItem.card1 ?? '',
            fio: historyItem.fio,
            account: historyItem.account,
            onTap: () => _onHistoryItemTap(historyItem),
          );
        }
      },
      childCount: count,
    );
  }

  Widget get _filtersContainer {
    return Ink(
      decoration: const BoxDecoration(
        color: ColorNode.ContainerColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.only(
        top: 24,
      ),
      child: DownContainerHeader(
        historyDownContainerArg: HistoryDownContainerArg(
          filterResult: filterResult,
          selectedCards: _isCardSelected,
          filterIsPressed: _filterIsPressed,
          chargeIsPressed: _chargeIsPressed,
          withdrawIsPressed: _withdrawIsPressed,
          chargeOnTap: () {
            if (!containerLoading) {
              setState(() {
                _chargeIsPressed = !_chargeIsPressed;
                _withdrawIsPressed = false;
                filterResult == null
                    ? getCardInfo()
                    : getCardInfoWithResult(
                        _chargeIsPressed ? TranType.credit.value : "");
              });
            }
          },
          withdrawOnTap: () {
            if (!containerLoading) {
              setState(() {
                _withdrawIsPressed = !_withdrawIsPressed;
                _chargeIsPressed = false;
                filterResult == null
                    ? getCardInfo()
                    : getCardInfoWithResult(
                        _withdrawIsPressed ? TranType.debit.value : "");
              });
            }
          },
          onCalendarTap: () {
            if (!containerLoading) {
              setState(() {
                filterResult?.periodType?.type = 'none';
                filterResult?.dates?.startDate = defaultStartTime + 'Z';
                filterResult?.dates?.endDate = defaultEndTime + 'Z';
                if (filterResult!.cardData!.isEmpty) {
                  _isCardSelected = [];
                  getCardInfo();
                } else {
                  getCardInfoByCards(filterResult!.cardData!);
                }
              });
            }
          },
          onCardClose: (value) {
            if (homeData?.cards != null && !containerLoading) {
              setState(() {
                AttachedCard? cardToClose;
                int? cardToCloseIndex;

                for (int i = 0; i < homeData!.cards.length; i++) {
                  final card = homeData!.cards[i];
                  if (card.token == value) {
                    cardToClose = card;
                    cardToCloseIndex = i;
                    break;
                  }
                }

                if (cardToCloseIndex != null) {
                  _isCardSelected[cardToCloseIndex] = false;
                }
                if (cardToClose != null) {
                  filterResult?.cardData?.removeWhere(
                      (element) => element.card == cardToClose?.token);
                  if (filterResult!.cardData!.isEmpty) {
                    _isCardSelected = [];
                    getCardInfo();
                  } else {
                    getCardInfoByCards(filterResult!.cardData!);
                  }
                }
              });
            }
          },
          filterOnTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).viewPadding.top -
                    16,
              ),
              builder: (context) {
                return DraggableScrollableSheet(
                  initialChildSize: 1,
                  minChildSize: .6,
                  builder: (context, scrollController) => FilterBtmSheet(
                    selectedCards: _isCardSelected,
                    chargeIsPressed: _chargeIsPressed,
                    withdrawIsPressed: _withdrawIsPressed,
                    scrollController: scrollController,
                    endTime: DateFormat("yyyy-MM-ddTHH:mm:ss")
                        .parse(filterResult?.dates?.endDate ?? defaultEndTime),
                    startTime: DateFormat("yyyy-MM-ddTHH:mm:ss").parse(
                        filterResult?.dates?.startDate ?? defaultStartTime),
                    periodType: filterResult?.periodType?.type ?? '',
                    filterBtmSheetArg: FilterBtmSheetArg(
                      showOnTap: (result, selectedCards) async {
                        setState(() {
                          _isCardSelected = selectedCards;
                          filterResult = result;
                          _filterIsPressed = true;
                          checkType(result);
                        });
                        if (result!.periodType!.type != "") {
                          await getCardInfoWithResult(
                              filterResult?.headerButtonType ?? '');
                        }
                      },
                      resetOnTap: () {
                        setState(() {
                          _withdrawIsPressed = false;
                          _chargeIsPressed = false;
                          _filterIsPressed = false;
                        });
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget get _filledContainer {
    Widget child;
    if (containerLoading) {
      child = LoadingWidget(
        background: ColorNode.ContainerColor,
        showLoading: containerLoading,
        withProgress: true,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      );
    } else if (list.isEmpty) {
      final title =
          _filterApplied ? 'there_is_no_operation' : 'there_were_no_operations';
      final subTitle =
          _filterApplied ? 'try_changing_filters' : 'history_is_stored_here';
      child = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(Assets.emptyHistory),
          const SizedBox(height: 28),
          TextLocale(
            title,
            style: TextStylesX.title5,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextLocale(
            subTitle,
            style: TextStylesX.caption1,
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      child = const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: double.maxFinite,
      color: list.isEmpty ? ColorNode.ContainerColor : Colors.transparent,
      padding: const EdgeInsets.only(bottom: 80),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: IconAndOtherColors.accent,
      onRefresh: onRefresh,
      edgeOffset: MediaQuery.of(context).viewPadding.top,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            collapsedHeight: kToolbarHeight,
            expandedHeight: kToolbarHeight + 24,
            pinned: true,
            backgroundColor: ColorNode.Background,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
              expandedTitleScale: _appBarTitleScale,
              centerTitle: false,
              title: TextLocale(
                'history',
                style: TextStylesX.title5,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: HistoryUpContainer()),
          SliverToBoxAdapter(child: _filtersContainer),
          if (containerLoading || list.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _filledContainer,
            )
          else ...[
            SliverList(delegate: _itemListDelegate),
            SliverToBoxAdapter(
              child: SizedBox(
                  height: 80.0 + MediaQuery.of(context).viewPadding.bottom),
            ),
          ]
        ],
      ),
    );
  }

  int get _actualListLength =>
      identificationLoading || containerLoading || list.isEmpty
          ? 0
          : list.length + 1;

  void _onHistoryItemTap(h.HistoryResponse item) {
    bool hasQr = false;
    if (item.mobileQrDto != null) {
      setState(() {
        hasQr = true;
      });
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorNode.Background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return CardDetailBtmSheet(
          historyItem: item,
          hasShareIcon: true,
          hasQr: hasQr,
          hasUserCode: true,
        );
      },
    );
  }
}
