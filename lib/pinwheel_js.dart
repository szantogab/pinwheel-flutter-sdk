@JS()
library pinwheel;

import 'package:js/js.dart';
import 'package:pinwheel/models.dart' as m;

@JS('Pinwheel.open')
external dynamic openPinwheel(PinwheelOpenOptions options);

typedef PinwheelWebExitCallback = void Function(PinwheelExitPayload? payload);
typedef PinwheelWebErrorCallback = void Function(PinwheelError error);
typedef PinwheelWebEventCallback = void Function(String name, PinwheelEventPayload? payload);
typedef PinwheelWebSuccessCallback = void Function(PinwheelSuccessPayload payload);
typedef PinwheelWebLoginCallback = void Function(PinwheelLoginPayload payload);
typedef PinwheelWebLoginAttemptCallback = void Function(PinwheelLoginAttemptPayload payload);


@JS()
@anonymous
class PinwheelOpenOptions {
	external String get linkToken;
	external PinwheelWebLoginCallback? get onLogin;
	external PinwheelWebSuccessCallback? get onSuccess;
	external PinwheelWebErrorCallback? get onError;
	external PinwheelWebExitCallback? get onExit;
	external PinwheelWebEventCallback? get onEvent;
	
	// Must have an unnamed factory constructor with named arguments.
	external factory PinwheelOpenOptions({String linkToken, PinwheelWebLoginCallback? onLogin, PinwheelWebSuccessCallback? onSuccess, PinwheelWebErrorCallback? onError, PinwheelWebExitCallback? onExit, PinwheelWebEventCallback? onEvent});
}

@JS()
@anonymous
abstract class PinwheelEventPayload {}

@JS()
@anonymous
class PinhweelAllocation implements PinwheelEventPayload {
	external String get type;
	external double? get value;
	
	external factory PinhweelAllocation({String type, double? value});
}

@JS()
@anonymous
class PinwheelInputAllocationPayload implements PinwheelEventPayload {
	external String get action;
	external PinhweelAllocation? get allocation;
	
	external factory PinwheelInputAllocationPayload({String action, PinhweelAllocation? allocation});
}

@JS()
@anonymous
class PinwheelAmountPayload implements PinwheelEventPayload {
	external String get unit;
	external double get value;
	
	external factory PinwheelAmountPayload({String unit, double value});
}

@JS()
@anonymous
class PinwheelError implements PinwheelEventPayload {
	external String get type;
	external String get code;
	external String get message;
	external bool get pendingRetry;
	
	external factory PinwheelError({String type, String code, String message, bool pendingRetry});
}

@JS()
@anonymous
class PinwheelExitPayload implements PinwheelEventPayload {
	external PinwheelError? get error;
	
	external factory PinwheelExitPayload({PinwheelError? error});
}

@JS()
@anonymous
class PinwheelLoginPayload implements PinwheelEventPayload {
	external String get accountId;
	external String? get platformId;
	
	external factory PinwheelLoginPayload({String accountId, String? platformId});
}

@JS()
@anonymous
class PinwheelLoginAttemptPayload implements PinwheelEventPayload {
	external String get platformId;
	
	external factory PinwheelLoginAttemptPayload({String platformId});
}

@JS()
@anonymous
class PinwheelParams implements PinwheelEventPayload {
	external PinwheelAmountPayload? get amount;
	
	external factory PinwheelParams({PinwheelAmountPayload? amount});
}

@JS()
@anonymous
class PinwheelSelectedEmployerPayload implements PinwheelEventPayload {
	external String get selectedEmployerId;
	external String get selectedEmployerName;
	
	external factory PinwheelSelectedEmployerPayload({String selectedEmployerId, String selectedEmployerName});
}

@JS()
@anonymous
class PinwheelSelectedPlatformPayload implements PinwheelEventPayload {
	external String get selectedPlatformId;
	external String get selectedPlatformName;
	
	external factory PinwheelSelectedPlatformPayload({String selectedPlatformId, String selectedPlatformName});
}

@JS()
@anonymous
class PinwheelSuccessPayload implements PinwheelEventPayload {
	external String get accountId;
	external String get platformId;
	external String get job;
	external PinwheelParams get params;
	
	external factory PinwheelSuccessPayload({String accountId, String platformId, String job, PinwheelParams params});
}

@JS()
@anonymous
class PinwheelEventChannelArgument {
	external String get name;
	external String? get payload;
	
	external factory PinwheelEventChannelArgument({String name, String? payload});
}