import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:get_storage/get_storage.dart';

/// Provides methods to manage dynamic links.
final class DynamicLinkHandler {
  DynamicLinkHandler._();

  static final instance = DynamicLinkHandler._();

  final _appLinks = AppLinks();

  Future<void> initialize() async {
    _appLinks.uriLinkStream.listen(_handleLinkData).onError((error) {
      log('$error', name: 'Dynamic Link Handler');
    });
    _checkInitialLink();
  }

  /// Handle navigation if initial link is found on app start.
  Future<void> _checkInitialLink() async {
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleLinkData(initialLink);
    }
  }

  void _handleLinkData(Uri data) {
    final queryParams = data.queryParameters;
    if (queryParams.isNotEmpty) {
      final code = queryParams['code'];
      if (code != null) {
        final box = GetStorage('rodocalc');
        box.write('indicador', code);
      }
    }
  }
}
