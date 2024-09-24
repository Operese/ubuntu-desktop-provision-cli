import 'dart:convert';

import 'package:crypt/crypt.dart';
import 'package:meta/meta.dart';
import 'package:subiquity_client/subiquity_client.dart';
import 'package:ubuntu_bootstrap/services/post_install_service.dart';
import 'package:ubuntu_provision/services.dart';

class SubiquityIdentityService implements IdentityService {
  const SubiquityIdentityService(
    this._subiquity,
    this._postInstall, {
    @visibleForTesting this.testSalt,
  });

  final SubiquityClient _subiquity;
  final PostInstallService _postInstall;
  final String? testSalt;

  /// The auto-login post-install config key for testing purposes.
  @visibleForTesting
  static const kAutoLoginUser = 'AutoLoginUser';

  @override
  Future<Identity> getIdentity() async {
    final data = await _subiquity.getIdentity();
    return Identity(
      realname: data.realname,
      username: data.username,
      hostname: data.hostname,
      autoLogin: await _postInstall.get(kAutoLoginUser) != null,
    );
  }

  @override
  Future<void> setIdentity(Identity identity) async {
    if (identity.autoLogin) {
      await _postInstall.set(kAutoLoginUser, identity.username);
    } else {
      await _postInstall.set(kAutoLoginUser, null);
    }

    return _subiquity.setIdentity(
      IdentityData(
        realname: identity.realname,
        username: identity.username,
        cryptedPassword: Crypt.sha512(
          String.fromCharCodes(utf8.encode(identity.password)),
          salt: testSalt,
        ).toString(),
        hostname: identity.hostname,
      ),
    );
  }

  @override
  Future<UsernameValidation> validateUsername(String username) {
    return _subiquity.validateUsername(username);
  }
}
