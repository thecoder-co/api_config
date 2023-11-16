/// The above class provides methods to show loading dialogs and snackbars with different types of
/// messages in a Flutter app.
library;
import 'package:flutter/foundation.dart';
import 'package:my_attorney/packages/packages.dart';

class Dialogs {
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: kDebugMode,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static void showErrorSnackbar(
    BuildContext context, {
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  static void showSnackbar(
    BuildContext context, {
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        // backgroundColor: Colors.red,
      ),
    );
  }

  static void showSuccessSnackbar(
    BuildContext context, {
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  static Future<bool> confirmDialog(
    BuildContext context, {
    required String message,
    String yesText = 'Confirm',
    String noText = 'No',
  }) async {
    final t = await openBottomSheet(
      context,
      children: [
        49.spacingH,
        Text(
          message,
          style: CustomTextStyle.displayXs24.w500.careerHeading,
        ),
        40.spacingH,
        AppButton.black(
          onPressed: () {
            pop(context, true);
          },
          label: yesText,
        ),
        16.0.spacingH,
        AppButton(
          onPressed: () {
            pop(context, false);
          },
          label: noText,
        ),
      ],
    );

    if (t.runtimeType != bool) return false;
    return t;
  }

  static Future openSuccessBottomsheet(
    BuildContext context, {
    required String message,
    Widget? child,
    String? buttonText,
    Function()? onPressed,
    String? buttonIcon,
  }) {
    return openBottomSheet(
      context,
      children: [
        49.spacingH,
        Text(
          message,
          style: CustomTextStyle.displayXs24.w500.careerHeading,
        ).alignLeft,
        20.spacingH,
        Container(
          width: 283,
          height: 172,
          decoration: ShapeDecoration(
            color: const Color(0x7FEFEFEF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 108,
            height: 102,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImagesAssets.check),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        40.spacingH,
        if (child != null) child,
        if (buttonText != null)
          AppButton.black(
            onPressed: () {
              pop(context);
              if (onPressed == null) return;
              onPressed();
            },
            label: buttonText,
            postIcon: buttonIcon,
          )
      ],
    );
  }

  static Future openErrorBottomsheet(
    BuildContext context, {
    required String message,
    String? buttonText,
    Function()? onPressed,
    String? buttonIcon,
    Widget? child,
  }) {
    return openBottomSheet(
      context,
      children: [
        49.spacingH,
        Text(
          message,
          style: CustomTextStyle.displayXs24.w500.careerHeading,
        ).alignLeft,
        20.spacingH,
        Container(
          width: 283,
          height: 172,
          decoration: ShapeDecoration(
            color: const Color(0x7FEFEFEF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 108,
            height: 102,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImagesAssets.cancel),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        40.spacingH,
        if (child != null) child,
        if (buttonText != null)
          AppButton.black(
            onPressed: () {
              pop(context);
              if (onPressed == null) return;
              onPressed();
            },
            label: buttonText,
            postIcon: buttonIcon,
          ),
      ],
    );
  }

  static Future openBottomSheet(
    BuildContext context, {
    List<Widget>? children,
    Widget? child,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(),
                    Container(
                      width: 130,
                      height: 3.49,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFC4C4C4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    if (children != null) ...children,
                    if (child != null) child,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
