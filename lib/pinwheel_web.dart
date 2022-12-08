
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:js';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:pinwheel/pinwheel.dart' as p;
import 'package:pinwheel/models.dart' as m;
import 'package:pinwheel/pinwheel_js.dart';
import 'package:pinwheel/pinwheel_platform_interface.dart';

/// A web implementation of the SocureFlutterSdkPlatform of the SocureFlutterSdk plugin.
class PinwheelWeb extends PinwheelPlatform {
  static void registerWith(Registrar registrar) {
	  PinwheelPlatform.instance = PinwheelWeb();
  }

  @override
  Future open(String linkToken, p.PinwheelLoginCallback? onLogin, p.PinwheelSuccessCallback? onSuccess, p.PinwheelErrorCallback? onError, p.PinwheelExitCallback? onExit, p.PinwheelEventCallback? onEvent, p.PinwheelLoginAttemptCallback? onLoginAttempt) async {
		openPinwheel(PinwheelOpenOptions(
				linkToken: linkToken,
				onError: onError != null ? allowInterop((error) => onError(m.PinwheelError((b) => b..type = error.type..code = error.code..message = error.message..pendingRetry = error.pendingRetry))) : null,
				onLogin: onLogin != null ? allowInterop((login) => onLogin(m.PinwheelLoginPayload((b) => b..accountId = login.accountId..platformId = login.platformId))) : null,
				onSuccess: onSuccess != null ? allowInterop((success) => onSuccess(m.PinwheelSuccessPayload((b) => b..platformId = success.platformId..accountId = success.accountId..job = success.job..params = (m.PinwheelParamsBuilder()..amount = (success.params.amount == null ? null : (m.PinwheelAmountPayloadBuilder()..value = success.params.amount?.value..unit = success.params.amount?.unit)))))) : null,
				onEvent: onEvent != null ? allowInterop((name, payload) => onEvent(name, null)) : null,
				onExit: onExit != null ? allowInterop((exit) => onExit(exit == null ? null : (m.PinwheelExitPayload((b) => b..error = exit.error == null ? null : (m.PinwheelErrorBuilder()..pendingRetry = exit.error?.pendingRetry..message = exit.error?.message..code = exit.error?.code..type = exit.error?.type) )))) : null
		));
  }
}