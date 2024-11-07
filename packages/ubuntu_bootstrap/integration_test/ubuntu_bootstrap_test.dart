import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:subiquity_client/subiquity_client.dart';
import 'package:subiquity_test/subiquity_test.dart';
import 'package:ubuntu_bootstrap/main.dart' as app;
import 'package:ubuntu_bootstrap/ubuntu_bootstrap.dart';
import 'package:ubuntu_provision/ubuntu_provision.dart';
import 'package:ubuntu_provision_test/ubuntu_provision_test.dart';
import 'package:ubuntu_test/ubuntu_test.dart';
import 'package:ubuntu_utils/ubuntu_utils.dart';
import 'package:yaml/yaml.dart';
import 'package:yaru_test/yaru_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(YaruTestWindow.ensureInitialized);

  setUp(() async {
    await cleanUpSubiquity();
    registerMockService<DesktopService>(FakeDesktopService());
  });
  tearDown(() async {
    await resetAllServices();
    rootBundle.clear();
  });

  testWidgets('minimal installation', (tester) async {
    const language = 'Français';
    const locale = 'fr_FR.UTF-8';
    const keyboard = KeyboardSetting(layout: 'fr', variant: 'latin9');
    const timezone = 'Europe/Paris';
    const identity = Identity(
      realname: 'User',
      hostname: 'ubuntu',
      username: 'user',
    );

    await tester.runApp(() => app.main(<String>[]));
    await tester.pumpAndSettle();

    await tester.testLocalePage(language: language, tester: tester);
    await expectLocale(locale);

    await tester.testAccessibilityPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testKeyboardPage(layout: language);
    await tester.tapNext();
    await tester.pumpAndSettle();
    await expectKeyboard(keyboard);

    await tester.testNetworkPage(mode: ConnectMode.none);
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testRefreshPage();
    await tester.tapSkip();
    await tester.pumpAndSettle();

    await tester.testAutoinstallPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testSourceSelectionPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testCodecsAndDriversPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testStoragePage(type: StorageType.erase);
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testIdentityPage(identity: identity, password: 'password');
    await tester.tapNext();
    await tester.pumpAndSettle();
    await expectIdentity(identity);

    await tester.testTimezonePage(timezone: timezone);
    await tester.tapNext();
    await tester.pumpAndSettle();
    await expectTimezone(timezone);

    await tester.testConfirmPage();
    await tester.tapConfirm();
    await tester.pumpAndSettle();

    await tester.testInstallPage();
    await tester.pumpAndSettle();

    final windowClosed = YaruTestWindow.waitForClosed();
    await tester.tapContinueTesting();
    await expectLater(windowClosed, completes);

    await verifySubiquityConfig(
      identity: identity,
      keyboard: keyboard,
      locale: locale,
      timezone: timezone,
    );
  });

  testWidgets('OEM', (tester) async {
    registerMockService<ConfigService>(
      FakeConfigService(mode: ProvisioningMode.oem),
    );

    await tester.runApp(() => app.main(<String>[]));
    await tester.pumpAndSettle();

    await tester.testLocalePage(tester: tester);

    await tester.testAccessibilityPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testKeyboardPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testNetworkPage(mode: ConnectMode.none);
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testRefreshPage();
    await tester.tapSkip();
    await tester.pumpAndSettle();

    await tester.testAutoinstallPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testSourceSelectionPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testCodecsAndDriversPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testStoragePage(type: StorageType.erase);
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testConfirmPage();
    await tester.tapConfirm();
    await tester.pumpAndSettle();

    await tester.testInstallPage();
    await tester.pumpAndSettle();

    final windowClosed = YaruTestWindow.waitForClosed();
    await tester.tapContinueTesting();
    await expectLater(windowClosed, completes);

    await verifySubiquityConfig(identity: const Identity());
  });

  testWidgets('LVM Encrypted', (tester) async {
    const identity = Identity(
      realname: 'User',
      hostname: 'ubuntu',
      username: 'user',
    );

    await tester.runApp(() => app.main(<String>[]));
    await tester.pumpAndSettle();

    await tester.testLocalePage(tester: tester);

    await tester.testAccessibilityPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testKeyboardPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testNetworkPage(mode: ConnectMode.none);
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testRefreshPage();
    await tester.tapSkip();
    await tester.pumpAndSettle();

    await tester.testAutoinstallPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testSourceSelectionPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testCodecsAndDriversPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testStoragePage(
      type: StorageType.erase,
      guidedCapability: GuidedCapability.LVM_LUKS,
    );
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testPassphrasePage(passphrase: 'password');
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testIdentityPage(identity: identity, password: 'password');
    await tester.tapNext();
    await tester.pumpAndSettle();
    await expectIdentity(identity);

    await tester.testTimezonePage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testConfirmPage();
    await tester.tapConfirm();
    await tester.pumpAndSettle();

    await tester.testInstallPage();
    await tester.pumpAndSettle();

    final windowClosed = YaruTestWindow.waitForClosed();
    await tester.tapContinueTesting();
    await expectLater(windowClosed, completes);

    await verifySubiquityConfig(
      identity: identity,
      capability: GuidedCapability.LVM_LUKS,
    );
  });

  testWidgets('ZFS unencrypted', (tester) async {
    const identity = Identity(
      realname: 'User',
      hostname: 'ubuntu',
      username: 'user',
    );

    await tester.runApp(() => app.main(<String>[]));
    await tester.pumpAndSettle();

    await tester.testLocalePage(tester: tester);

    await tester.testAccessibilityPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testKeyboardPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testNetworkPage(mode: ConnectMode.none);
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testRefreshPage();
    await tester.tapSkip();
    await tester.pumpAndSettle();

    await tester.testAutoinstallPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testSourceSelectionPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testCodecsAndDriversPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testStoragePage(
      type: StorageType.erase,
      guidedCapability: GuidedCapability.ZFS,
    );
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testIdentityPage(identity: identity, password: 'password');
    await tester.tapNext();
    await tester.pumpAndSettle();
    await expectIdentity(identity);

    await tester.testTimezonePage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testConfirmPage();
    await tester.tapConfirm();
    await tester.pumpAndSettle();

    await tester.testInstallPage();
    await tester.pumpAndSettle();

    final windowClosed = YaruTestWindow.waitForClosed();
    await tester.tapContinueTesting();
    await expectLater(windowClosed, completes);

    await verifySubiquityConfig(
      identity: identity,
      capability: GuidedCapability.ZFS,
    );
  });

  testWidgets('ZFS encrypted', (tester) async {
    const identity = Identity(
      realname: 'User',
      hostname: 'ubuntu',
      username: 'user',
    );

    await tester.runApp(() => app.main(<String>[]));
    await tester.pumpAndSettle();

    await tester.testLocalePage(tester: tester);

    await tester.testAccessibilityPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testKeyboardPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testNetworkPage(mode: ConnectMode.none);
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testRefreshPage();
    await tester.tapSkip();
    await tester.pumpAndSettle();

    await tester.testAutoinstallPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testSourceSelectionPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testCodecsAndDriversPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testStoragePage(
      type: StorageType.erase,
      guidedCapability: GuidedCapability.ZFS_LUKS_KEYSTORE,
    );
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testPassphrasePage(passphrase: 'password');
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testIdentityPage(identity: identity, password: 'password');
    await tester.tapNext();
    await tester.pumpAndSettle();
    await expectIdentity(identity);

    await tester.testTimezonePage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testConfirmPage();
    await tester.tapConfirm();
    await tester.pumpAndSettle();

    await tester.testInstallPage();
    await tester.pumpAndSettle();

    final windowClosed = YaruTestWindow.waitForClosed();
    await tester.tapContinueTesting();
    await expectLater(windowClosed, completes);

    await verifySubiquityConfig(
      identity: identity,
      capability: GuidedCapability.ZFS_LUKS_KEYSTORE,
    );
  });

  testWidgets('tpm', (tester) async {
    const identity = Identity(
      realname: 'User',
      hostname: 'ubuntu',
      username: 'user',
    );

    await tester.runApp(
      () => app.main([
        '--source-catalog=examples/sources/tpm.yaml',
        '--dry-run-config=examples/dry-run-configs/tpm.yaml',
        '--',
        '--bootloader=uefi',
      ]),
    );
    await tester.pumpAndSettle();

    await tester.testLocalePage(tester: tester);

    await tester.testAccessibilityPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testKeyboardPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testNetworkPage(mode: ConnectMode.none);
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testRefreshPage();
    await tester.tapSkip();
    await tester.pumpAndSettle();

    await tester.testAutoinstallPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testSourceSelectionPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testCodecsAndDriversPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testStoragePage(
      type: StorageType.erase,
      guidedCapability: GuidedCapability.CORE_BOOT_ENCRYPTED,
    );
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testRecoveryKeyPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testIdentityPage(identity: identity, password: 'password');
    await tester.tapNext();
    await tester.pumpAndSettle();
    await expectIdentity(identity);

    await tester.testTimezonePage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testConfirmPage();
    await tester.tapConfirm();
    await tester.pumpAndSettle();

    await tester.testInstallPage();
    await tester.pumpAndSettle();

    final windowClosed = YaruTestWindow.waitForClosed();
    await tester.tapContinueTesting();
    await expectLater(windowClosed, completes);

    await verifySubiquityConfig(
      identity: identity,
      capability: GuidedCapability.CORE_BOOT_ENCRYPTED,
    );
  });

  testWidgets('manual partitioning', (tester) async {
    final storage = [
      fakeDisk(
        path: '/dev/sda',
        partitions: [
          Partition(size: toBytes(6, DataUnit.gigabytes), mount: '/'),
          Partition(size: toBytes(2, DataUnit.gigabytes), mount: '/mnt/test'),
        ],
      ),
    ];

    await tester.runApp(() => app.main(<String>[]));
    await tester.pumpAndSettle();

    await tester.testLocalePage(tester: tester);

    await tester.testAccessibilityPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testKeyboardPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testNetworkPage(mode: ConnectMode.none);
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testRefreshPage();
    await tester.tapSkip();
    await tester.pumpAndSettle();

    await tester.testAutoinstallPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testSourceSelectionPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testCodecsAndDriversPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testStoragePage(type: StorageType.manual);
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testManualStoragePage(storage: storage);
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testIdentityPage(
      identity: const Identity(realname: 'a', hostname: 'b', username: 'c'),
      password: 'password',
    );
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testTimezonePage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testConfirmPage();
    await tester.tapConfirm();
    await tester.pumpAndSettle();

    await tester.testInstallPage();
    await tester.pumpAndSettle();

    final windowClosed = YaruTestWindow.waitForClosed();
    await tester.tapContinueTesting();
    await expectLater(windowClosed, completes);

    await verifySubiquityConfig(
      storage: [
        fakeDisk(
          path: '/dev/sda',
          partitions: [
            Partition(
              size: mibiAlign(toBytes(6, DataUnit.gigabytes)),
              mount: '/',
            ),
            Partition(
              size: mibiAlign(toBytes(2, DataUnit.gigabytes)),
              mount: '/mnt/test',
            ),
          ],
        ),
      ],
    );
  });

  testWidgets('alongside windows', (tester) async {
    await tester.runApp(
      () => app.main(<String>[
        '--machine-config=examples/machines/win10-along-ubuntu.json',
        '--',
        '--bootloader=uefi',
      ]),
    );
    await tester.pumpAndSettle();

    await tester.testLocalePage(tester: tester);

    await tester.testAccessibilityPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testKeyboardPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testNetworkPage(mode: ConnectMode.none);
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testRefreshPage();
    await tester.tapSkip();
    await tester.pumpAndSettle();

    await tester.testAutoinstallPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testSourceSelectionPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testCodecsAndDriversPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testStoragePage(type: StorageType.alongside);
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testGuidedResizePage(size: 30);
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testIdentityPage(
      identity: const Identity(realname: 'a', hostname: 'b', username: 'c'),
      password: 'password',
    );
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testTimezonePage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testConfirmPage();
    await tester.tapConfirm();
    await tester.pumpAndSettle();

    await tester.testInstallPage();
    await tester.pumpAndSettle();

    final windowClosed = YaruTestWindow.waitForClosed();
    await tester.tapContinueTesting();
    await expectLater(windowClosed, completes);

    const totalSize =
        512 * 166486126; // total size of sda3 from the machine config
    final newPartitionSize = mibiAlign(toBytes(30, DataUnit.gigabytes));

    await verifySubiquityConfig(
      storage: [
        fakeDisk(
          path: '/dev/sda',
          partitions: [
            Partition(
              number: 3,
              size: mibiAlign(totalSize - newPartitionSize, totalSize),
            ),
            Partition(number: 6, size: newPartitionSize, mount: '/'),
          ],
        ),
      ],
    );
  });

  testWidgets('turn off bitlocker', (tester) async {
    await tester.runApp(
      () => app.main(<String>[
        '--machine-config=examples/machines/win10.json',
      ]),
    );
    await tester.pumpAndSettle();

    await tester.testLocalePage(tester: tester);
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testAccessibilityPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testKeyboardPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testNetworkPage(mode: ConnectMode.none);
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testRefreshPage();
    await tester.tapSkip();
    await tester.pumpAndSettle();

    await tester.testAutoinstallPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testSourceSelectionPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testCodecsAndDriversPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testStoragePage(type: StorageType.alongside);
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testBitLockerPage();
    await tester.pumpAndSettle();

    final windowClosed = YaruTestWindow.waitForClosed();
    await tester.tapRestart();
    await expectLater(windowClosed, completes);
  });

  testWidgets('welcome', (tester) async {
    await tester.runApp(() => app.main(<String>['--welcome']));
    await tester.pumpAndSettle();

    await tester.testLocalePage(tester: tester);

    await tester.testAccessibilityPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testKeyboardPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testNetworkPage(mode: ConnectMode.none);
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testRefreshPage();
    await tester.tapSkip();
    await tester.pumpAndSettle();

    await tester.testTryOrInstallPage(option: TryOrInstallOption.installUbuntu);
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testAutoinstallPage();
    await tester.pumpAndSettle();
  });

  testWidgets('semi-automated autoinstall', (tester) async {
    await tester.runApp(
      () => app.main(<String>[
        '--',
        '--autoinstall=examples/autoinstall/interactive.yaml',
      ]),
    );
    await tester.pumpAndSettle();

    await tester.testNetworkPage();
    await tester.tapNext();
    await tester.pumpAndSettle();

    await tester.testConfirmPage();
    await tester.tapConfirm();
    await tester.pump();

    await tester.testInstallPage();
    await tester.pumpAndSettle();

    final windowClosed = YaruTestWindow.waitForClosed();
    await tester.tapRestartNow();
    await expectLater(windowClosed, completes);
  });
}

Future<void> verifySubiquityConfig({
  Identity? identity,
  KeyboardSetting? keyboard,
  String? locale,
  String? timezone,
  List<Disk>? storage,
  GuidedCapability? capability,
}) async {
  final path = await getSubiquityLogFile('autoinstall-user-data');
  await expectLater(path, existsLater);

  final yaml = loadYaml(File(path).readAsStringSync());

  if (identity == const Identity()) {
    // OEM case: no idendity should be configured
    expect(yaml['autoinstall']['identity'], isNull);
  } else if (identity != null) {
    final actualIdentity = yaml['autoinstall']['identity'];
    expect(actualIdentity['hostname'], equals(identity.hostname));
    expect(actualIdentity['realname'], equals(identity.realname));
    expect(actualIdentity['username'], equals(identity.username));
  }

  if (keyboard != null) {
    final actualKeyboard = yaml['autoinstall']['keyboard'];
    if (keyboard.layout.isNotEmpty) {
      expect(actualKeyboard['layout'], equals(keyboard.layout));
    }
    if (keyboard.variant.isNotEmpty) {
      expect(actualKeyboard['variant'], equals(keyboard.variant));
    }
  }

  if (locale != null) {
    final actualLocale = yaml['autoinstall']['locale'];
    expect(actualLocale, equals(locale));
  }

  if (timezone != null) {
    final actualTimezone = yaml['autoinstall']['timezone'];
    expect(actualTimezone, equals(timezone));
  }

  final actualStorage = yaml['autoinstall']['storage']['config'] as YamlList;

  if (storage != null) {
    for (final disk in storage) {
      final actualDisk = actualStorage.firstWhereOrNull(
        (d) => d['type'] == 'disk' && d['path'] == disk.path,
      );
      expect(actualDisk, isNotNull);

      for (final partition in disk.partitions.whereType<Partition>()) {
        final actualPartition = actualStorage.firstWhereOrNull(
          (d) => d['type'] == 'partition' && d['size'] == partition.size,
        );
        expect(actualPartition, isNotNull);

        if (partition.mount != null) {
          final actualMount = actualStorage.firstWhereOrNull(
            (d) => d['type'] == 'mount' && d['path'] == partition.mount,
          );
          expect(actualMount, isNotNull);
        }
      }
    }
  }

  if (capability != null) {
    switch (capability) {
      case GuidedCapability.LVM:
        expect(
          actualStorage.where((config) => config['type'] == 'lvm_volgroup'),
          isNotEmpty,
        );
        break;
      case GuidedCapability.LVM_LUKS:
        expect(
          actualStorage.where((config) => config['type'] == 'lvm_volgroup'),
          isNotEmpty,
        );
        expect(
          actualStorage.where((config) => config['type'] == 'dm_crypt'),
          isNotEmpty,
        );
      case GuidedCapability.ZFS:
        expect(
          actualStorage.where((config) => config['type'] == 'zpool'),
          isNotEmpty,
        );
        break;
      case GuidedCapability.ZFS_LUKS_KEYSTORE:
        expect(
          actualStorage.where((config) => config['type'] == 'zpool'),
          isNotEmpty,
        );
        expect(
          actualStorage.where((config) => config['type'] == 'dm_crypt'),
          isNotEmpty,
        );
        break;
      case GuidedCapability.CORE_BOOT_ENCRYPTED:
        expect(
          actualStorage
              .where((config) => config['path'] == '/dev/mapper/ubuntu-data'),
          isNotEmpty,
        );
        expect(
          actualStorage
              .where((config) => config['path'] == '/dev/mapper/ubuntu-save'),
          isNotEmpty,
        );
        break;
      default:
        break;
    }
  }
}

class FakeDesktopService implements DesktopService {
  @override
  Future<void> inhibit() async {}

  @override
  Future<void> close() async {}
}

class FakeConfigService extends ConfigService {
  FakeConfigService({this.mode = ProvisioningMode.standard});
  final ProvisioningMode mode;

  @override
  Future<ProvisioningMode> get provisioningMode async => mode;
}
