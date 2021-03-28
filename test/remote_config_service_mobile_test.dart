// @dart=2.9
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pap_firebase_remote_config/pap_firebase_remote_config.dart';
import 'package:pap_firebase_remote_config/services/platform_service.dart';

class MockPlatformService extends Mock implements IPlatformService {}

class MockRemoteConfig extends Mock implements RemoteConfig {}

void main() {
  MockPlatformService mockPlatformService;
  MockRemoteConfig mockRemoteConfig;
  IPapRemoteConfigService papRemoteConfigServiceMobile;

  setUp(() async {
    mockPlatformService = MockPlatformService();
    mockRemoteConfig = MockRemoteConfig();
  });

  test('getBoolean should get boolean value when platform is mobile', () {
    // Arrange
    when(MockPlatformService().isAndroid())
        .thenAnswer((realInvocation) => true);
    when(mockPlatformService.isIOS()).thenAnswer((realInvocation) => true);
    when(mockPlatformService.isWeb()).thenAnswer((realInvocation) => false);
    when(MockRemoteConfig().getBool(any)).thenAnswer((realInvocation) => true);

    papRemoteConfigServiceMobile = PapFirebaseRemoteConfigFactory(
            platformService: mockPlatformService,
            remoteConfig: mockRemoteConfig)
        .getInstance();
    // Act
    bool output =
        papRemoteConfigServiceMobile.getBoolean(variableName: 'config_name');

    // Assert
    expect(output, isNot(Null));
  });

  test('getString should get string value when platform is mobile', () {
    // Arrange
    when(mockPlatformService.isAndroid()).thenAnswer((realInvocation) => true);
    when(mockPlatformService.isIOS()).thenAnswer((realInvocation) => true);
    when(mockPlatformService.isWeb()).thenAnswer((realInvocation) => false);
    when(MockRemoteConfig().getString(any))
        .thenAnswer((realInvocation) => 'value');

    papRemoteConfigServiceMobile = PapFirebaseRemoteConfigFactory(
            platformService: mockPlatformService,
            remoteConfig: mockRemoteConfig)
        .getInstance();
    // Act
    String output =
        papRemoteConfigServiceMobile.getString(variableName: 'config_name');

    // Assert
    expect(output, isNot(Null));
  });

  test('getInteger should get integer value when platform is mobile', () {
    // Arrange
    when(mockPlatformService.isAndroid()).thenAnswer((realInvocation) => true);
    when(mockPlatformService.isIOS()).thenAnswer((realInvocation) => true);
    when(mockPlatformService.isWeb()).thenAnswer((realInvocation) => false);
    when(MockRemoteConfig().getInt(any)).thenAnswer((realInvocation) => 1);

    papRemoteConfigServiceMobile = PapFirebaseRemoteConfigFactory(
            platformService: mockPlatformService,
            remoteConfig: mockRemoteConfig)
        .getInstance();
    // Act
    int output =
        papRemoteConfigServiceMobile.getInt(variableName: 'config_name');

    // Assert
    expect(output, isNot(Null));
  });
}
