// @dart=2.9
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pap_firebase_remote_config/pap_firebase_remote_config.dart';
import 'package:pap_firebase_remote_config/services/platform_service.dart';

class MockPlatformService extends Mock implements IPlatformService {}

void main() {
  MockPlatformService mockPlatformService;
  PapFirebaseRemoteConfigFactory papFirebaseRemoteConfig;

  setUp(() async {
    mockPlatformService = MockPlatformService();
    papFirebaseRemoteConfig =
        PapFirebaseRemoteConfigFactory(platformService: mockPlatformService);
  });

  TestWidgetsFlutterBinding.ensureInitialized();

  test('should return instance of IPapRemoteConfigService when platform is Web',
      () {
    // Arrange
    when(mockPlatformService.isAndroid()).thenAnswer((realInvocation) => false);
    when(mockPlatformService.isIOS()).thenAnswer((realInvocation) => false);
    when(mockPlatformService.isWeb()).thenAnswer((realInvocation) => true);
    // Act
    var output = papFirebaseRemoteConfig.getInstance();

    // Assert
    expect(output, isA<IPapRemoteConfigService>());
  });
}
