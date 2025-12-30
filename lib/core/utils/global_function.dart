import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class GlobalFunction {
  GlobalFunction._();

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showCustomSnackbar({
    required String message,
    required bool isSuccess,
    bool isTop = false,
  }) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      dismissDirection: isTop
          ? DismissDirection.startToEnd
          : DismissDirection.down,
      content: Text(message, style: TextStyle(fontSize: 12.sp)),
      margin: isTop
          ? EdgeInsets.only(
              bottom:
                  MediaQuery.of(
                    scaffoldMessengerKey.currentState!.context,
                  ).size.height -
                  160,
              right: 20,
              left: 20,
            )
          : null,
    );
    // ScaffoldMessenger.of(scaffoldMessengerKey.currentState!.context)
    //   ..hideCurrentSnackBar()
    //   ..showSnackBar(
    //     snackBar,
    //   );
    scaffoldMessengerKey.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /*Use this function in case if you are willing to print or debug something. This function will help you to hide your debug print in release mode.*/
  static void logDebug(String message) {
    if (kDebugMode) {
      debugPrint("🦊 $message");
    }
  }


  static ({String text, Color bgColor}) orderStatus(String orderStatus) {
    switch (orderStatus) {
      case 'pending':
        return (text: 'Pending', bgColor: const Color(0xffFFAB00));
      case 'completed':
        return (text: 'Delivered', bgColor: const Color(0xff36b37e));
      case 'cancelled':
        return (text: 'Cancelled', bgColor: const Color(0xffFF5630));
      default:
        return (text: 'Unknown', bgColor: Colors.grey);
    }
  }

  /// Safe way to show a dialog from anywhere
  static Future<void> showSafeDialog({
    required WidgetBuilder builder,
    BuildContext? fallbackContext,
  }) async {
    BuildContext? dialogContext;

    // Priority 1: fallbackContext (direct context from widget)
    if (fallbackContext != null) {
      dialogContext = fallbackContext;
    }

    // Priority 2: fallback to global scaffoldMessengerKey's context
    dialogContext ??= scaffoldMessengerKey.currentContext;

    if (dialogContext == null) {
      logDebug("Unable to find a valid context to show dialog.");
      return;
    }

    // Show dialog
    return showDialog(context: dialogContext, builder: builder);
  }
}