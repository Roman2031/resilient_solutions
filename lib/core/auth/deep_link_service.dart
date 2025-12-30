import 'dart:async';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

/// Deep Link Service
/// Handles incoming deep links for OAuth redirect and other app links
/// 
/// Configured for: com.kingdomcall.app://oauth2redirect
class DeepLinkService {
  StreamSubscription? _sub;
  
  /// Callback for deep link handling
  Function(Uri)? onLinkReceived;

  /// Initialize deep link listening
  Future<void> initialize() async {
    // Handle initial deep link (when app is closed)
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        final uri = Uri.parse(initialLink);
        onLinkReceived?.call(uri);
      }
    } on PlatformException {
      // Handle exception
    }

    // Handle deep links while app is running
    _sub = linkStream.listen((String? link) {
      if (link != null) {
        final uri = Uri.parse(link);
        onLinkReceived?.call(uri);
      }
    }, onError: (err) {
      // Handle error
    });
  }

  /// Dispose stream subscription
  void dispose() {
    _sub?.cancel();
  }
}
