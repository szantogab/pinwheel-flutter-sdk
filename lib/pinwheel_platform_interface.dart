import 'package:pinwheel/pinwheel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pinwheel_method_channel.dart';

abstract class PinwheelPlatform extends PlatformInterface {
  /// Constructs a PinwheelPlatform.
  PinwheelPlatform() : super(token: _token);

  static final Object _token = Object();

  static PinwheelPlatform _instance = MethodChannelPinwheel();

  /// The default instance of [PinwheelPlatform] to use.
  ///
  /// Defaults to [MethodChannelPinwheel].
  static PinwheelPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PinwheelPlatform] when
  /// they register themselves.
  static set instance(PinwheelPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// This method should not be directly used by consumers. Use the [PinwheelLink] widget instead.
  ///
  /// Opens the Pinwheel flow. On mobile, this will set the callbacks, but won't actually start the flow.
  /// On Web, it'll start the flow.
  Future open(String linkToken, PinwheelLoginCallback? onLogin, PinwheelSuccessCallback? onSuccess, PinwheelErrorCallback? onError, PinwheelExitCallback? onExit, PinwheelEventCallback? onEvent, PinwheelLoginAttemptCallback? onLoginAttempt);
}
