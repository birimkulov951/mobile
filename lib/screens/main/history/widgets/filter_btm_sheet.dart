import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ultra/main.dart' show homeData, locale;
import 'package:mobile_ultra/net/history/modal/filter_date.dart';
import 'package:mobile_ultra/net/history/modal/tran_type.dart';
import 'package:mobile_ultra/screens/main/history/arguments/cards_item_arg.dart';
import 'package:mobile_ultra/screens/main/history/arguments/filter_btm_sheet_arg.dart';
import 'package:mobile_ultra/screens/main/history/arguments/period_item_arg.dart';
import 'package:mobile_ultra/screens/main/history/widgets/cards_item.dart';
import 'package:mobile_ultra/screens/main/history/widgets/filter_btm_sheet_footer.dart';
import 'package:mobile_ultra/screens/main/history/widgets/operation_item.dart';
import 'package:mobile_ultra/screens/main/history/widgets/period_item.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:ui_kit/ui_kit.dart';

class FilterBtmSheet extends StatefulWidget {
  final FilterBtmSheetArg filterBtmSheetArg;
  final bool chargeIsPressed;
  final bool withdrawIsPressed;
  final ScrollController scrollController;
  final DateTime? startTime;
  final DateTime? endTime;
  final String periodType;
  final List<bool> selectedCards;

  const FilterBtmSheet({
    required this.filterBtmSheetArg,
    required this.chargeIsPressed,
    required this.withdrawIsPressed,
    required this.scrollController,
    required this.endTime,
    required this.periodType,
    required this.selectedCards,
    this.startTime,
    super.key,
  });

  @override
  _FilterBtmSheetState createState() => _FilterBtmSheetState();
}

class _FilterBtmSheetState extends State<FilterBtmSheet> {
  final GlobalKey<PeriodItemState> _periodItemKey = GlobalKey();

  bool credit = false;
  bool debit = false;
  bool _selectAll = false;
  List<bool> _isCardSelected = [];
  List<Carrd> cardData = [];
  PeriodDateType? filterResult;
  DateTime _defaultStartTime = DateTime.now().subtract(const Duration(days: 3));
  DateTime _defaultEndTime = DateTime.now();
  PeriodType _periodType = PeriodType.calendar;
  String debitOrCredit = '';
  DateFormat startTimToFormat = DateFormat("yyyy-MM-ddT00:00:00");
  DateFormat endTimToFormat = DateFormat("yyyy-MM-ddT23:59:00");

  @override
  void initState() {
    initialize();
    checkPeriodType();
    super.initState();
  }

  void checkPeriodType() {
    if (widget.periodType == 'month') {
      _periodType = PeriodType.month;
    } else if (widget.periodType == 'week') {
      _periodType = PeriodType.week;
    } else if (widget.periodType == 'calendar') {
      _periodType = PeriodType.calendar;
    } else {
      _periodType = PeriodType.none;
    }
    if (widget.selectedCards.isNotEmpty &&
        widget.selectedCards != _isCardSelected) {
      _isCardSelected = widget.selectedCards;
    }
    credit = widget.chargeIsPressed;
    debit = widget.withdrawIsPressed;
    _defaultStartTime =
        widget.startTime ?? DateTime.now().subtract(const Duration(days: 3));
    _defaultEndTime = widget.endTime ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: BackgroundColors.primary,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Stack(
        /// Замена overflow: Overflow.visible,
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 4,
                width: 36,
                margin: EdgeInsets.only(
                  top: 6,
                  left: MediaQuery.of(context).size.width / 2 - 18,
                ),
                decoration: const BoxDecoration(
                  color: BackgroundColors.Default,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: TextLocale(
                  "set_filter",
                  style: Typographies.title4,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  controller: widget.scrollController,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 12),
                    PeriodItem(
                      key: _periodItemKey,
                      type: _periodType,
                      isTableCalendarShown: false,
                      onTap: (t) {
                        setState(() => _periodType = t);
                      },
                      periodItemArg: PeriodItemArg(
                        startDate: _defaultStartTime,
                        endDate: _defaultEndTime,
                        selectTime: (startTime, endTime) {
                          _defaultStartTime = startTime;
                          _defaultEndTime = endTime ?? startTime;
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    CardsItem(
                      cardsItemArg: CardsItemArg(
                        selectedCards: _isCardSelected,
                        selectCard: (index) => selectedCards(index),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OperationItem(
                      chargeOnTap: () {
                        setState(() {
                          credit = !credit;
                          debit = false;
                        });
                      },
                      chargeIsPressed: credit,
                      withdrawOnTap: () {
                        setState(() {
                          debit = !debit;
                          credit = false;
                        });
                      },
                      withdrawIsPressed: debit,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).viewPadding.bottom + 96,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FilterBtmSheetFooter(
              resetOnTap: () {
                widget.filterBtmSheetArg.resetOnTap();
                clearAll();
              },
              showOnTap: () {
                cardData.clear();
                for (var i = 0; i < _isCardSelected.length; i++) {
                  if (_isCardSelected[i] == true) {
                    cardData.add(
                      Carrd(
                        card: homeData?.cards[i].token,
                        type: homeData?.cards[i].type,
                      ),
                    );
                  }
                }
                getFilterResult();
              },
            ),
          ),
        ],
      ),
    );
  }

  void getFilterResult() {
    if (cardData.isNotEmpty) {
      debitOrCreditCheck();
      if (_periodType == PeriodType.week) {
        setState(() {
          filterResult = PeriodDateType(
            periodType: PeriodTypee(type: "week"),
            cardData: cardData,
            headerButtonType: debitOrCredit,
            dates: Dates(
                startDate: startTimToFormat.format(
                        DateTime.now().subtract(const Duration(days: 7))) +
                    "Z",
                endDate: endTimToFormat.format(DateTime.now()) + "Z"),
          );
        });
        widget.filterBtmSheetArg.showOnTap(filterResult, _isCardSelected);
        Navigator.of(context).pop();
      } else if (_periodType == PeriodType.month) {
        setState(() {
          filterResult = PeriodDateType(
            periodType: PeriodTypee(type: "month"),
            cardData: cardData,
            headerButtonType: debitOrCredit,
            dates: Dates(
                startDate: startTimToFormat.format(
                        DateTime.now().subtract(const Duration(days: 30))) +
                    "Z",
                endDate: endTimToFormat.format(DateTime.now()) + "Z"),
          );
        });
        widget.filterBtmSheetArg.showOnTap(filterResult, _isCardSelected);
        Navigator.of(context).pop(filterResult);
      } else if (_periodType == PeriodType.calendar) {
        setState(() {
          filterResult = PeriodDateType(
            periodType: PeriodTypee(type: "calendar"),
            cardData: cardData,
            headerButtonType: debitOrCredit,
            dates: Dates(
                startDate: startTimToFormat.format(_defaultStartTime) + "Z",
                endDate: endTimToFormat.format(_defaultEndTime) + "Z"),
          );
        });
        widget.filterBtmSheetArg.showOnTap(filterResult, _isCardSelected);
        Navigator.of(context).pop(filterResult);
      } else if (_periodType == PeriodType.none) {
        setState(() {
          filterResult = PeriodDateType(
            periodType: PeriodTypee(type: "calendar"),
            cardData: cardData,
            headerButtonType: debitOrCredit,
            dates: Dates(
              startDate: startTimToFormat.format(
                      DateTime.now().subtract(const Duration(days: 3))) +
                  "Z",
              endDate: endTimToFormat.format(DateTime.now()) + "Z",
            ),
          );
        });
        widget.filterBtmSheetArg.showOnTap(filterResult, _isCardSelected);
        Navigator.of(context).pop(filterResult);
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => showMessage(context,
            locale.getText('error'), locale.getText('select_period_and_map'),
            onSuccess: () => Navigator.pop(context)),
      );
    }
  }

  void debitOrCreditCheck() {
    if (credit == true) {
      debitOrCredit = TranType.credit.value;
    } else if (debit == true) {
      debitOrCredit = TranType.debit.value;
    }
    setState(() {});
  }

  void selectedCards(int index) {
    setState(() {
      _isCardSelected[index] = !_isCardSelected[index];
      for (final i in _isCardSelected) {
        if (i == false) {
          _selectAll = false;
          return;
        } else {
          _selectAll = true;
        }
      }
    });
  }

  void selectAll() {
    cardData.clear();
    _selectAll = !_selectAll;
    for (var i = 0; i < _isCardSelected.length; i++) {
      _isCardSelected[i] = _selectAll;
      cardData.add(
        Carrd(card: homeData?.cards[i].token, type: homeData?.cards[i].type),
      );
    }
    setState(() {});
  }

  void clearAll() async {
    cardData.clear();
    _periodType = PeriodType.none;
    debit = false;
    credit = false;
    for (var i = 0; i < _isCardSelected.length; i++) {
      _isCardSelected[i] = true;
    }
    _defaultStartTime = DateTime.now().subtract(const Duration(days: 3));
    _defaultEndTime = DateTime.now();
    _periodItemKey.currentState!.hideTableCalendar();
    setState(() {});
  }

  void initialize() {
    final cards = homeData?.cards ?? [];

    for (final _ in cards) {
      _isCardSelected.add(false);
    }
    if (widget.selectedCards.isEmpty) {
      selectAll();
    } else {
      for (final i in widget.selectedCards) {
        if (i == false) {
          _selectAll = false;
        } else {
          _selectAll = true;
        }
      }
    }
  }
}
