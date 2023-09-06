import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/screens/base/mwwm/auth/auth_wm.dart';
import 'package:mobile_ultra/screens/registration/phone_number_login/phone_number_login_model.dart';
import 'package:mobile_ultra/screens/registration/phone_number_login/phone_number_login_screen.dart';
import 'package:mobile_ultra/utils/inject.dart';

abstract class IPhoneNumberLoginScreenWidgetModel extends IWidgetModel
    with IAuthWidgetModelMixin {
  abstract final TextEditingController phoneController;

  abstract final FocusNode focusNode;

  ValueNotifier<bool> get isContinueEnabled;

  ValueNotifier<bool> get isLoading;

  double get bottomPadding;

  Widget? get leading;
}

class PhoneNumberLoginScreenWidgetModel
    extends WidgetModel<PhoneNumberLoginScreen, PhoneNumberLoginModel>
    with AuthWidgetModelMixin
    implements IPhoneNumberLoginScreenWidgetModel {
  PhoneNumberLoginScreenWidgetModel(
    super.model,
  );

  @override
  final TextEditingController phoneController = TextEditingController();

  @override
  final FocusNode focusNode = FocusNode();

  @override
  ValueNotifier<bool> get isContinueEnabled => _isContinueEnabled;

  @override
  ValueNotifier<bool> get isLoading => _isLoading;

  @override
  double get bottomPadding {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    if (bottomPadding == 0) {
      return 16.0;
    }
    return bottomPadding;
  }

  @override
  Widget? get leading =>
      widget.arguments.forgotPassword ? const SizedBox.shrink() : null;

  @override
  Future<void> fetchLoginOtp({String? passedPhoneNumber}) async {
    _isLoading.value = true;
    AnalyticsInteractor.instance.registrationTracker
        .trackPhoneNumberEntered(isError: false);
    await super.fetchLoginOtp(passedPhoneNumber: _validatedPhoneNumber);
    if (accessDenied) {
      _isContinueEnabled.value = false;
    }
    _isLoading.value = false;
  }

  late final ValueNotifier<bool> _isLoading;
  late final ValueNotifier<bool> _isContinueEnabled;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _isLoading = ValueNotifier(false);
    _isContinueEnabled = ValueNotifier(false);
    phoneController.addListener(() {
      _isContinueEnabled.value = _checkIfPhoneNumberIsValid() &&
          !accessDenied;
    });
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    _isLoading.dispose();
    _isContinueEnabled.dispose();
    phoneController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  bool _checkIfPhoneNumberIsValid() => _validatedPhoneNumber.length == 12;

  String get _validatedPhoneNumber =>
      phoneController.text.replaceAll(RegExp(r'\D'), '');

  bool get accessDenied => super.authStatus == AuthStatus.accessDenied;
}

PhoneNumberLoginScreenWidgetModel phoneNumberLoginScreenWidgetModelFactory(_) =>
    PhoneNumberLoginScreenWidgetModel(
      PhoneNumberLoginModel(inject()),
    );
