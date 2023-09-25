// Mocks generated by Mockito 5.4.2 from annotations
// in ubuntu_provision/test/keyboard/test_keyboard.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;
import 'dart:ui' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:ubuntu_provision/src/keyboard/keyboard_model.dart' as _i2;

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

/// A class which mocks [KeyboardModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockKeyboardModel extends _i1.Mock implements _i2.KeyboardModel {
  MockKeyboardModel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  int get layoutCount => (super.noSuchMethod(
        Invocation.getter(#layoutCount),
        returnValue: 0,
      ) as int);

  @override
  bool get canDetectLayout => (super.noSuchMethod(
        Invocation.getter(#canDetectLayout),
        returnValue: false,
      ) as bool);

  @override
  int get selectedLayoutIndex => (super.noSuchMethod(
        Invocation.getter(#selectedLayoutIndex),
        returnValue: 0,
      ) as int);

  @override
  int get variantCount => (super.noSuchMethod(
        Invocation.getter(#variantCount),
        returnValue: 0,
      ) as int);

  @override
  int get selectedVariantIndex => (super.noSuchMethod(
        Invocation.getter(#selectedVariantIndex),
        returnValue: 0,
      ) as int);

  @override
  bool get isValid => (super.noSuchMethod(
        Invocation.getter(#isValid),
        returnValue: false,
      ) as bool);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);

  @override
  bool get isDisposed => (super.noSuchMethod(
        Invocation.getter(#isDisposed),
        returnValue: false,
      ) as bool);

  @override
  String layoutName(int? index) => (super.noSuchMethod(
        Invocation.method(
          #layoutName,
          [index],
        ),
        returnValue: '',
      ) as String);

  @override
  _i3.Future<void> selectLayout(
    int? index, [
    int? variant = 0,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #selectLayout,
          [
            index,
            variant,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> trySelectLayoutVariant(
    String? layout,
    String? variant,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #trySelectLayoutVariant,
          [
            layout,
            variant,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  int searchLayout(String? query) => (super.noSuchMethod(
        Invocation.method(
          #searchLayout,
          [query],
        ),
        returnValue: 0,
      ) as int);

  @override
  String variantName(int? index) => (super.noSuchMethod(
        Invocation.method(
          #variantName,
          [index],
        ),
        returnValue: '',
      ) as String);

  @override
  _i3.Future<void> selectVariant(int? index) => (super.noSuchMethod(
        Invocation.method(
          #selectVariant,
          [index],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> init() => (super.noSuchMethod(
        Invocation.method(
          #init,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> updateInputSource() => (super.noSuchMethod(
        Invocation.method(
          #updateInputSource,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> save() => (super.noSuchMethod(
        Invocation.method(
          #save,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  void addListener(_i4.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeListener(_i4.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
