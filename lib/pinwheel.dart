import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pinwheel/pinwheel_platform_interface.dart';
import 'models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

typedef PinwheelExitCallback = void Function(PinwheelExitPayload? payload);
typedef PinwheelErrorCallback = void Function(PinwheelError error);
typedef PinwheelEventCallback = void Function(String name, PinwheelEventPayload? payload);
typedef PinwheelSuccessCallback = void Function(PinwheelSuccessPayload payload);
typedef PinwheelLoginCallback = void Function(PinwheelLoginPayload payload);
typedef PinwheelLoginAttemptCallback = void Function(PinwheelLoginAttemptPayload payload);

class PinwheelLink extends StatefulWidget {
  final String token;
  final PinwheelExitCallback? onExit;
  final PinwheelErrorCallback? onError;
  final PinwheelEventCallback? onEvent;
  final PinwheelSuccessCallback? onSuccess;
  final PinwheelLoginCallback? onLogin;
  final PinwheelLoginAttemptCallback? onLoginAttempt;

  const PinwheelLink ({ 
    Key? key, 
    required this.token,
    this.onExit,
    this.onError,
    this.onEvent,
    this.onSuccess,
    this.onLogin,
    this.onLoginAttempt
  }): super(key: key);

  @override
  PinwheelLinkState createState() => PinwheelLinkState();
}

class PinwheelLinkState extends State<PinwheelLink> {
  late int platformViewId;
  
  @override
  initState() {
    super.initState();
    
    PinwheelPlatform.instance.open(widget.token, widget.onLogin, widget.onSuccess, widget.onError, widget.onExit, widget.onEvent, widget.onLoginAttempt);
  }
  
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Container();
    }
    
    final String viewType = 'pinwheel-link-view';
    final Map<String, String> creationParams = {
      "token": widget.token
    };
    
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return PlatformViewLink(
          viewType: viewType,
          surfaceFactory: (BuildContext context, PlatformViewController controller) {

            return AndroidViewSurface(
              controller: controller as AndroidViewController,
              gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
              hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            );
          },
          onCreatePlatformView: (PlatformViewCreationParams params) {
            return PlatformViewsService.initSurfaceAndroidView(
              id: params.id,
              viewType: viewType,
              layoutDirection: TextDirection.ltr,
              creationParams: creationParams,
              creationParamsCodec: JSONMessageCodec(),
            )
            ..addOnPlatformViewCreatedListener((int id) {
              params.onPlatformViewCreated(id);
              _onPlatformViewCreated(id);
            })
            ..create();
          },
        );
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: viewType,
          onPlatformViewCreated: _onPlatformViewCreated,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: JSONMessageCodec(),
        );
      default:
        throw UnsupportedError("Unsupported platform view");
    }
  }

  void _onPlatformViewCreated(int id) {
    platformViewId = id;
  }
}
