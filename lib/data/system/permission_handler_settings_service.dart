import 'package:big_call_app/domain/ports/system_settings_service.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class PermissionHandlerSettingsService implements SystemSettingsService {
  const PermissionHandlerSettingsService();

  @override
  Future<void> openAppSettings() async {
    try {
      await ph.openAppSettings();
    } on Object catch (error) {
      debugPrint('openAppSettings: $error');
    }
  }
}
