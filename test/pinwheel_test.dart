import 'package:flutter_test/flutter_test.dart';
import 'package:pinwheel/pinwheel.dart';
import 'package:pinwheel/pinwheel_platform_interface.dart';
import 'package:pinwheel/pinwheel_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPinwheelPlatform
    with MockPlatformInterfaceMixin
    implements PinwheelPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PinwheelPlatform initialPlatform = PinwheelPlatform.instance;

  test('$MethodChannelPinwheel is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPinwheel>());
  });

  test('getPlatformVersion', () async {
    Pinwheel pinwheelPlugin = Pinwheel();
    MockPinwheelPlatform fakePlatform = MockPinwheelPlatform();
    PinwheelPlatform.instance = fakePlatform;

    expect(await pinwheelPlugin.getPlatformVersion(), '42');
  });
}
