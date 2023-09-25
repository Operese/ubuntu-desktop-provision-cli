// Mocks generated by Mockito 5.4.2 from annotations
// in ubuntu_provision/test/theme/test_theme.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;
import 'dart:ui' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:ubuntu_provision/src/theme/theme_model.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [ThemeModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockThemeModel extends _i1.Mock implements _i2.ThemeModel {
  MockThemeModel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<bool> init() => (super.noSuchMethod(
        Invocation.method(
          #init,
          [],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<void> setBrightness(_i4.Brightness? value) => (super.noSuchMethod(
        Invocation.method(
          #setBrightness,
          [value],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> setAccent(String? value) => (super.noSuchMethod(
        Invocation.method(
          #setAccent,
          [value],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}
