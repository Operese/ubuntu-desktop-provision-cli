import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone_map/timezone_map.dart';
import 'package:ubuntu_init/src/error_page.dart';
import 'package:ubuntu_init/src/init_step.dart';
import 'package:ubuntu_init/ubuntu_init.dart';
import 'package:ubuntu_provision/ubuntu_provision.dart' hide ErrorPage;
import 'package:ubuntu_service/ubuntu_service.dart';
import 'package:ubuntu_test/ubuntu_test.dart';
import 'package:ubuntu_utils/ubuntu_utils.dart';
import 'package:ubuntu_wizard/ubuntu_wizard.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_test/yaru_test.dart';

// TODO: move to shared packages
import '../../ubuntu_provision/test/accessibility/test_accessibility.dart'
    hide MockThemeVariantService;
import '../../ubuntu_provision/test/identity/test_identity.dart'
    hide MockThemeVariantService;
import '../../ubuntu_provision/test/keyboard/test_keyboard.dart'
    hide MockThemeVariantService;
import '../../ubuntu_provision/test/locale/test_locale.dart'
    hide MockThemeVariantService;
import '../../ubuntu_provision/test/network/test_network.dart'
    hide MockThemeVariantService;
import '../../ubuntu_provision/test/timezone/test_timezone.dart'
    hide MockThemeVariantService;
import 'telemetry/test_telemetry.dart';
import 'ubuntu_pro/test_ubuntu_pro.dart';
import 'welcome/test_welcome.dart';

void main() {
  LiveTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    YaruTestWindow.ensureInitialized(state: const YaruWindowState());
    setupMockPageConfig();
    registerMockService<ThemeVariantService>(MockThemeVariantService());
  });

  testWidgets('init', (tester) async {
    final initModel = buildInitModel();
    final localeModel = buildLocaleModel();
    final accessibilityModel = buildAccessibilityModel();
    final keyboardModel = buildKeyboardModel();
    final networkModel = buildNetworkModel();
    final ethernetModel = buildEthernetModel();
    final wifiModel = buildWifiModel();
    final hiddenWifiModel = buildHiddenWifiModel();
    final timezoneModel = buildTimezoneModel(
        selectedLocation: const GeoLocation(timezone: 'UTC'));
    final identityModel = buildIdentityModel(isValid: true);
    final ubuntuProModel =
        buildUbuntuProModel(skipPro: false, isAttached: true);
    final telemetryModel = buildTelemetryModel();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          initModelProvider.overrideWith((_) => initModel),
          localeModelProvider.overrideWith((_) => localeModel),
          accessibilityModelProvider.overrideWith((_) => accessibilityModel),
          keyboardModelProvider.overrideWith((_) => keyboardModel),
          networkModelProvider.overrideWith((_) => networkModel),
          ethernetModelProvider.overrideWith((_) => ethernetModel),
          wifiModelProvider.overrideWith((_) => wifiModel),
          hiddenWifiModelProvider.overrideWith((_) => hiddenWifiModel),
          timezoneModelProvider.overrideWith((_) => timezoneModel),
          identityModelProvider.overrideWith((_) => identityModel),
          ubuntuProModelProvider.overrideWith((_) => ubuntuProModel),
          telemetryModelProvider.overrideWith((_) => telemetryModel),
        ],
        child: tester.buildTestWizard(),
      ),
    );

    final windowClosed = YaruTestWindow.waitForClosed();

    await tester.pump(const Duration(seconds: 1));

    await tester.pumpAndSettle();
    expect(find.byType(LocalePage), findsOneWidget);

    await tester.tapNext();
    await tester.pumpAndSettle();
    expect(find.byType(AccessibilityPage), findsOneWidget);
    verify(accessibilityModel.init()).called(1);

    await tester.tapNext();
    await tester.pumpAndSettle();
    expect(find.byType(KeyboardPage), findsOneWidget);
    verify(keyboardModel.init()).called(1);

    await tester.tapNext();
    await tester.pumpAndSettle();
    expect(find.byType(NetworkPage), findsOneWidget);
    verify(networkModel.init()).called(1);

    await tester.tapNext();
    await tester.pumpAndSettle();
    final eulaPage = find.byType(EulaPage);
    expect(eulaPage, findsOneWidget);
    final l10n = EulaLocalizations.of(tester.element(eulaPage));
    final checkbox = find.checkButton(l10n.eulaAcceptTerms);
    expect(checkbox, findsOneWidget);
    expect(checkbox, isNotChecked);
    await tester.tap(checkbox);
    await tester.pumpAndSettle();

    await tester.tapNext();
    await tester.pumpAndSettle();
    expect(find.byType(IdentityPage), findsOneWidget);
    verify(identityModel.init()).called(1);

    await tester.tapNext();
    await tester.pumpAndSettle();
    expect(find.byType(UbuntuProOnboardingPage), findsOneWidget);

    await tester.tapNext();
    await tester.pumpAndSettle();
    expect(find.byType(UbuntuProPage), findsOneWidget);

    await tester.tapNext();
    await tester.pumpAndSettle();
    expect(find.byType(UbuntuProSuccessAttachPage), findsOneWidget);

    await tester.tapNext();
    await tester.pumpUntil(find.byType(TimezonePage));
    await tester.pumpAndSettle();
    expect(find.byType(TimezonePage), findsOneWidget);
    verify(timezoneModel.init()).called(1);

    await tester.tapNext();
    await tester.pumpAndSettle();
    expect(find.byType(TelemetryPage), findsOneWidget);
    verify(telemetryModel.init()).called(1);

    await tester.tapDone();
    await tester.pumpAndSettle();

    await expectLater(windowClosed, completes);
  });

  testWidgets('welcome', (tester) async {
    final initModel = buildInitModel();
    final welcomeModel = buildWelcomeModel();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          initModelProvider.overrideWith((_) => initModel),
          welcomeModelProvider.overrideWith((_) => welcomeModel),
        ],
        child: tester.buildTestWizard(welcome: true),
      ),
    );

    final windowClosed = YaruTestWindow.waitForClosed();

    await tester.pump(const Duration(seconds: 1));

    await tester.pumpAndSettle();
    expect(find.byType(WelcomePage), findsOneWidget);

    await tester.tapDone();
    await tester.pumpAndSettle();

    await expectLater(windowClosed, completes);
  });

  testWidgets('pages', (tester) async {
    final initModel = buildInitModel(pages: [
      InitStep.locale.route,
      InitStep.keyboard.route,
      InitStep.identity.route,
      InitStep.telemetry.route,
    ]);
    final localeModel = buildLocaleModel();
    final keyboardModel = buildKeyboardModel();
    final identityModel = buildIdentityModel(isValid: true);
    final telemetryModel = buildTelemetryModel();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          initModelProvider.overrideWith((_) => initModel),
          localeModelProvider.overrideWith((_) => localeModel),
          keyboardModelProvider.overrideWith((_) => keyboardModel),
          identityModelProvider.overrideWith((_) => identityModel),
          telemetryModelProvider.overrideWith((_) => telemetryModel),
        ],
        child: tester.buildTestWizard(),
      ),
    );

    await tester.pump(const Duration(seconds: 1));

    await tester.pumpAndSettle();
    expect(find.byType(LocalePage), findsOneWidget);

    await tester.tapNext();
    await tester.pumpAndSettle();
    expect(find.byType(KeyboardPage), findsOneWidget);
    verify(keyboardModel.init()).called(1);

    await tester.tapNext();
    await tester.pumpAndSettle();
    expect(find.byType(IdentityPage), findsOneWidget);
    verify(identityModel.init()).called(1);

    await tester.tapNext();
    await tester.pumpAndSettle();
    expect(find.byType(TelemetryPage), findsOneWidget);
    verify(telemetryModel.init()).called(1);

    final windowClosed = YaruTestWindow.waitForClosed();

    await tester.tapDone();
    await tester.pumpAndSettle();

    await expectLater(windowClosed, completes);
  });

  group('error page', () {
    testWidgets('init wizard', (tester) async {
      final initModel = buildInitModel(pages: [InitStep.locale.route]);
      final localeModel = buildLocaleModel(error: Exception());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            initModelProvider.overrideWith((_) => initModel),
            localeModelProvider.overrideWith((_) => localeModel),
          ],
          child: tester.buildTestWizard(),
        ),
      );
      await tester.pump(const Duration(seconds: 1));

      await tester.pumpAndSettle();
      expect(find.byType(LocalePage), findsNothing);
      expect(find.byType(ErrorPage), findsOneWidget);
    });

    testWidgets('welcome wizard', (tester) async {
      final initModel = buildInitModel(pages: [WelcomeStep.welcome.route]);
      final welcomeModel = buildWelcomeModel(error: Exception());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            initModelProvider.overrideWith((_) => initModel),
            welcomeModelProvider.overrideWith((_) => welcomeModel),
          ],
          child: tester.buildTestWizard(welcome: true),
        ),
      );
      await tester.pump(const Duration(seconds: 1));

      await tester.pumpAndSettle();
      expect(find.byType(WelcomePage), findsNothing);
      expect(find.byType(ErrorPage), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  Widget buildTestWizard({bool welcome = false}) {
    return WizardApp(
      localizationsDelegates: GlobalUbuntuInitLocalizations.delegates,
      supportedLocales: supportedLocales,
      home: DefaultAssetBundle(
        bundle: ProxyAssetBundle(rootBundle, package: 'ubuntu_init'),
        child: welcome ? const WelcomeWizard() : const InitWizard(),
      ),
    );
  }
}
