import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/screens/main/profile/pin_change_widget.dart';
import 'package:mobile_ultra/screens/main/profile/settings/settings_screen.dart';
import 'package:mobile_ultra/screens/main/profile/settings/settings_screen_model.dart';
import 'package:mobile_ultra/utils/inject.dart';

abstract class ISettingsScreenWidgetModel extends IWidgetModel {
  Future<void> changePin();

  void changeBiometricUseStatus();

  ValueNotifier<bool> get isBiometricsEnabled;

  Future<void> clearAllPaymentData();
}

class SettingsScreenWidgetModel
    extends WidgetModel<SettingsScreen, SettingsScreenModel>
    implements ISettingsScreenWidgetModel {
  SettingsScreenWidgetModel(SettingsScreenModel model) : super(model);

  late final ValueNotifier<bool> _isBiometricsEnabled;

  @override
  ValueNotifier<bool> get isBiometricsEnabled => _isBiometricsEnabled;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _isBiometricsEnabled = ValueNotifier(model.isBiometricsEnabled());
  }

  @override
  void dispose() {
    _isBiometricsEnabled.dispose();
    super.dispose();
  }

  @override
  Future<void> changePin() async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (_) => PinChangeWidget()));

    if (result != null) {
      Navigator.pop(context, result);
    }
  }

  @override
  void changeBiometricUseStatus() {
    model.changeBiometricUseStatus();
    _isBiometricsEnabled.value = model.isBiometricsEnabled();
  }

  @override
  Future<void> clearAllPaymentData() async {
    await model.clearAllPaymentData();
  }
}

SettingsScreenWidgetModel settingsScreenWidgetModelFactory(_) =>
    SettingsScreenWidgetModel(
      SettingsScreenModel(
        inject(),
        inject(),
      ),
    );
