import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mobile_ultra/data/repositories/charles_repository_impl.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/main_dev.dart' show proxy;
import 'package:mobile_ultra/net/qa/qa_presenter.dart';
import 'package:mobile_ultra/repositories/charles_repository.dart';
import 'package:mobile_ultra/resource/dimensions.dart';
import 'package:mobile_ultra/screens/main/navigation.dart';
import 'package:mobile_ultra/start_screen.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/u.dart';

const _attention = 'Attention';
const _couldNotDelete = 'Could not delete user profile!';
const _wantToDelete = 'Do you really want to delete the user profile?';
const _ok = 'OK';
const _cancel = 'Cancel';

/// Works only on development flavor
class QAPage extends StatefulWidget {
  static const Tag = '/qa';

  const QAPage({super.key});

  @override
  _QAPageState createState() => _QAPageState();
}

class _QAPageState extends State<QAPage> with DeleteView {
  late bool isPaintSizeEnabled;
  late bool isPaintBaselinesEnabled;
  late bool isPaintLayerBordersEnabled;
  late bool isPaintPointersEnabled;
  late bool isRepaintRainbowEnabled;
  late bool isRepaintTextRainbowEnabled;
  late bool isDisableClipLayers;
  late bool isDisablePhysicalShapeLayers;
  late bool isDisableOpacityLayers;

  bool isCharlesProxyEnabled = false;
  bool _isLoading = false;
  final TextEditingController textController = TextEditingController();
  final FocusNode textFocus = FocusNode();

  final CharlesRepository _charlesRepository = CharlesRepositoryImpl(inject());

  @override
  void initState() {
    super.initState();

    isPaintSizeEnabled = debugPaintSizeEnabled;
    isPaintBaselinesEnabled = debugPaintBaselinesEnabled;
    isPaintLayerBordersEnabled = debugPaintLayerBordersEnabled;
    isPaintPointersEnabled = debugPaintPointersEnabled;
    isRepaintRainbowEnabled = debugRepaintRainbowEnabled;
    isRepaintTextRainbowEnabled = debugRepaintTextRainbowEnabled;
    isDisableClipLayers = debugDisableClipLayers;
    isDisablePhysicalShapeLayers = debugDisablePhysicalShapeLayers;
    isDisableOpacityLayers = debugDisableOpacityLayers;

    if (_charlesRepository.isCharlesProxyEnabled()) {
      proxy?.enable();
    }

    final isProxyEnabled = proxy?.isProxyEnabled() ?? false;
    if (isProxyEnabled) {
      isCharlesProxyEnabled = true;
    }

    if (_charlesRepository.charlesIpAddress() != null) {
      textController.text = _charlesRepository.charlesIpAddress()!;
    }
  }

  @override
  void dispose() {
    textController.dispose();
    textFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: appTheme,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("QA Settings"),
          backgroundColor: Colors.white,
          elevation: 3,
          actions: [
            GestureDetector(
              onTap: saveOptions,
              child: const SizedBox(
                width: 50,
                child: Icon(
                  Icons.check,
                  size: 28,
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(Dimensions.unit2),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  maxLines: 1,
                  focusNode: textFocus,
                  controller: textController,
                  keyboardType: TextInputType.datetime,
                  onEditingComplete: textFocus.unfocus,
                  onSubmitted: (value) {
                    textFocus.unfocus();
                  },
                  decoration: const InputDecoration(
                      hintText: "111.111.11.11",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Charles Proxy'),
                    Checkbox(
                      value: isCharlesProxyEnabled,
                      onChanged: (v) {
                        setState(() {
                          isCharlesProxyEnabled = !isCharlesProxyEnabled;
                          _charlesRepository.setCharlesProxyEnabled(
                              isEnabled: isCharlesProxyEnabled);
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('debugPaintSizeEnabled'),
                    Checkbox(
                      value: isPaintSizeEnabled,
                      onChanged: (v) {
                        setState(() {
                          isPaintSizeEnabled = !isPaintSizeEnabled;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('debugPaintBaselinesEnabled'),
                    Checkbox(
                      value: isPaintBaselinesEnabled,
                      onChanged: (v) {
                        setState(() {
                          isPaintBaselinesEnabled = !isPaintBaselinesEnabled;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('debugPaintLayerBordersEnabled'),
                    Checkbox(
                      value: isPaintLayerBordersEnabled,
                      onChanged: (v) {
                        setState(() {
                          isPaintLayerBordersEnabled =
                              !isPaintLayerBordersEnabled;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('debugPaintPointersEnabled'),
                    Checkbox(
                      value: isPaintPointersEnabled,
                      onChanged: (v) {
                        setState(() {
                          isPaintPointersEnabled = !isPaintPointersEnabled;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('debugRepaintRainbowEnabled'),
                    Checkbox(
                      value: isRepaintRainbowEnabled,
                      onChanged: (v) {
                        setState(() {
                          isRepaintRainbowEnabled = !isRepaintRainbowEnabled;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('debugRepaintTextRainbowEnabled'),
                    Checkbox(
                      value: isRepaintTextRainbowEnabled,
                      onChanged: (v) {
                        setState(() {
                          isRepaintTextRainbowEnabled =
                              !isRepaintTextRainbowEnabled;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('debugDisableClipLayers'),
                    Checkbox(
                      value: isDisableClipLayers,
                      onChanged: (v) {
                        setState(() {
                          isDisableClipLayers = !isDisableClipLayers;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('debugDisablePhysicalShapeLayers'),
                    Checkbox(
                      value: isDisablePhysicalShapeLayers,
                      onChanged: (v) {
                        setState(() {
                          isDisablePhysicalShapeLayers =
                              !isDisablePhysicalShapeLayers;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('debugDisableOpacityLayers'),
                    Checkbox(
                        value: isDisableOpacityLayers,
                        onChanged: (v) {
                          setState(() {
                            isDisableOpacityLayers = !isDisableOpacityLayers;
                          });
                        })
                  ],
                ),
                const SizedBox(height: Dimensions.unit3),
                RoundedButton(
                  title: 'Delete User Profile',
                  loading: _isLoading,
                  onPressed: _isLoading ? null : onProfileDelete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveOptions() {
    var localhost = "localhost";

    if (textController.text.isNotEmpty) {
      localhost = textController.text.trim();
    }

    if (isCharlesProxyEnabled) {
      _charlesRepository.setCharlesIpAddress(ipAddress: localhost);
      proxy?.setIpAddress(localhost);
      proxy?.enable();
    } else {
      proxy?.setIpAddress(localhost);
      proxy?.disable();
    }

    debugPaintSizeEnabled = isPaintSizeEnabled;
    debugPaintBaselinesEnabled = isPaintBaselinesEnabled;
    debugPaintLayerBordersEnabled = isPaintLayerBordersEnabled;
    debugPaintPointersEnabled = isPaintPointersEnabled;
    debugRepaintRainbowEnabled = isRepaintRainbowEnabled;
    debugRepaintTextRainbowEnabled = isRepaintTextRainbowEnabled;
    debugDisableClipLayers = isDisableClipLayers;
    debugDisablePhysicalShapeLayers = isDisablePhysicalShapeLayers;
    debugDisableOpacityLayers = isDisableOpacityLayers;

    Navigator.pop(context);
  }

  void onProfileDelete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => showMessage(
        context,
        _attention,
        _wantToDelete,
        dismissTitle: _cancel,
        successTitle: _ok,
        onDismiss: () => Navigator.pop(context),
        onSuccess: () {
          onLoad();
          QaPresenter.deleteProfile(this).deleteProfile();
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  void onError(String? error, {errorBody}) {
    onLoad(isLoading: false);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => showMessage(
        context,
        _attention,
        error ?? _couldNotDelete,
        dismissTitle: _ok,
        onDismiss: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Future<void> onSuccess({result}) async {
    onLoad(isLoading: false);

    final body = jsonDecode(result);

    if (body['data'] != null && body['data']['result'] == false) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => showMessage(
          context,
          _attention,
          _couldNotDelete,
          dismissTitle: _ok,
          onDismiss: () => Navigator.pop(context),
        ),
      );
      return;
    }

    await Future.wait([
      pref!.setLaunchType(true),
      pref!.setAccessToken(null),
      pref!.setRefreshToken(null),
      pref!.setConfigUpdateTime(-1),
      pref!.setLogoUpdateTime(-1),
      pref!.setLogin(null),
      pref!.setViewLogin(null),
      pref!.setPin(null),
      pref!.setFullName(null),
      pref!.setActiveUser(null),
      pref!.setUserBirthDate(null),
      pref!.setUserDocument(null),
      pref!.madePay(false),
      pref!.setHiddenCardBalance(null),
      pref!.setLoginedAccount(null),
      pref!.saveSuggestions(null),
      pref!.setAccUpdTime(null),
      pref!.acceptPhoneScaleFactore(false),
    ]);

    homeData = null;
    accountList.clear();
    reminderList.clear();
    favoriteList.clear();
    suggestionList.clear();
    sharingData = null;
    requestedFavorites = false;
    startFrom = NavigationWidget.HOME;

    try {
      await firebaseMessaging.unsubscribeFromTopic('global');
      await firebaseMessaging.unsubscribeFromTopic(locale.prefix);
    } on Object catch (e) {
      printLog(e);
    }

    await db?.clearAll();
    await DefaultCacheManager().emptyCache();

    Navigator.pushReplacementNamed(context, StartWidget.Tag);
  }

  void onLoad({bool isLoading = true}) =>
      setState(() => _isLoading = isLoading);
}
