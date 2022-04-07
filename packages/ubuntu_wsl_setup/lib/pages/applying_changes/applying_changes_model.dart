import 'package:subiquity_client/subiquity_client.dart';

import '../../installing_state.dart';

/// Implements the business logic of the WSL Applying Changes Page.
///
/// See also:
///  * [ApplyingChangesPage]
class ApplyingChangesModel {
  /// Creates a model for the 'applying changes' page.
  ApplyingChangesModel(SubiquityStatusMonitor monitor)
      : _isInstalling = monitor.onStatusChanged.map(
            (event) => event?.state?.isInstalling == true); // could be null

  final Stream<bool> _isInstalling;
  Stream<bool> isInstalling() => _isInstalling;
}
