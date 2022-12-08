import 'dart:convert';

import 'package:built_value/standard_json_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pinwheel/models.dart';
import 'package:pinwheel/pinwheel.dart';
import 'package:pinwheel/serializers.dart';

import 'pinwheel_platform_interface.dart';

/// An implementation of [PinwheelPlatform] that uses method channels.
class MethodChannelPinwheel extends PinwheelPlatform {
	PinwheelEventCallback? _onEvent;
	PinwheelExitCallback? _onExit;
	PinwheelLoginCallback? _onLogin;
	PinwheelErrorCallback? _onError;
	PinwheelSuccessCallback? _onSuccess;
	PinwheelLoginAttemptCallback? _onLoginAttempt;
	
	/// The method channel used to interact with the native platform.
	@visibleForTesting
	final methodChannel = const MethodChannel('pinwheel', JSONMethodCodec());
	
	MethodChannelPinwheel() {
		methodChannel.setMethodCallHandler(_handleMethod);
	}
	
	
	set onEvent(PinwheelEventCallback value) {
    _onEvent = value;
  }

  static final _standardSerializers = (serializers.toBuilder()
		..addPlugin(StandardJsonPlugin())).build();
	
	
	Future<dynamic> _handleMethod(MethodCall call) async {
		switch (call.method) {
			case 'onEvent':
				try {
					String name;
					PinwheelEventPayload? payload;
					if (call.arguments != null && call.arguments != "null") {
						var data = _standardSerializers.deserializeWith(
								PinwheelEventChannelArgument.serializer, json.decode(call.arguments))!;
						name = data.name;
						if (data.payload != null) {
							String payloadString = data.payload!;
							switch (name) {
								case 'select_employer':
									payload = _standardSerializers.deserializeWith(PinwheelSelectedEmployerPayload.serializer, json.decode(payloadString))!;
									break;
								case 'select_platform':
									payload = _standardSerializers.deserializeWith(PinwheelSelectedPlatformPayload.serializer, json.decode(payloadString))!;
									break;
								case 'login':
									payload = _standardSerializers.deserializeWith(PinwheelLoginPayload.serializer, json.decode(payloadString))!;
									break;
								case 'login_attempt':
									payload = _standardSerializers.deserializeWith(PinwheelLoginAttemptPayload.serializer, json.decode(payloadString))!;
									break;
								case 'input_amount':
									payload = _standardSerializers.deserializeWith(PinwheelAmountPayload.serializer, json.decode(payloadString));
									break;
								case 'input_allocation':
									payload = _standardSerializers.deserializeWith(PinwheelInputAllocationPayload.serializer, json.decode(payloadString));
									break;
								case 'exit':
									payload = _standardSerializers.deserializeWith(PinwheelSelectedEmployerPayload.serializer, json.decode(payloadString))!;
									break;
								case 'success':
									payload = _standardSerializers.deserializeWith(PinwheelSuccessPayload.serializer, json.decode(payloadString))!;
									break;
								case 'error':
									payload = _standardSerializers.deserializeWith(PinwheelError.serializer, json.decode(payloadString))!;
									break;
							}
						}
						if (_onEvent != null) {
							_onEvent!(name, payload);
						}
					}
				} catch (error) {
					print(error);
				}
				break;
			
			case 'onExit':
				try {
					PinwheelExitPayload? result;
					if (call.arguments != null && call.arguments != "null") {
						result = _standardSerializers.deserializeWith(PinwheelExitPayload.serializer, json.decode(call.arguments))!;
					}
					if (_onExit != null) {
						_onExit!(result);
					}
				} catch (error) {
					print(error);
				}
				break;
			case 'onError':
				try {
					var result = _standardSerializers.deserializeWith(PinwheelError.serializer, json.decode(call.arguments))!;
					if (_onError != null) {
						_onError!(result);
					}
				} catch (error) {}
				break;
			case 'onSuccess':
				try {
					var result = _standardSerializers.deserializeWith(PinwheelSuccessPayload.serializer, json.decode(call.arguments))!;
					if (_onSuccess != null) {
						_onSuccess!(result);
					}
				} catch (error) {
					print(error);
				}
				break;
			case 'onLogin':
				try {
					var result = _standardSerializers.deserializeWith(PinwheelLoginPayload.serializer, json.decode(call.arguments))!;
					if (_onLogin != null) {
						_onLogin!(result);
					}
				} catch (error) {
					print(error);
				}
				break;
			case 'onLoginAttempt':
				try {
					var result = _standardSerializers.deserializeWith(PinwheelLoginAttemptPayload.serializer, json.decode(call.arguments))!;
					if (_onLoginAttempt != null) {
						_onLoginAttempt!(result);
					}
				} catch (error) {
					print(error);
				}
				break;
		}
	}

  @override
  Future open(String linkToken, PinwheelLoginCallback? onLogin, PinwheelSuccessCallback? onSuccess, PinwheelErrorCallback? onError, PinwheelExitCallback? onExit, PinwheelEventCallback? onEvent, PinwheelLoginAttemptCallback? onLoginAttempt) async {
    this._onLogin = onLogin;
		this._onSuccess = onSuccess;
		this._onError = onError;
		this._onEvent = onEvent;
		this._onExit = onExit;
		this._onLoginAttempt = onLoginAttempt;
  }
}
