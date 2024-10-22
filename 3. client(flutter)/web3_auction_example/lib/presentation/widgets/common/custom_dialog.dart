import 'package:flutter/material.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';

class CustomDialog extends Dialog {
  final String title;
  final String message;
  // OneButton
  final VoidCallback? onPressed;
  final String? okMessage;
  // Two Button
  final VoidCallback? leftOnPressed;
  final VoidCallback? rightOnPressed;
  final String? leftMessage;
  final String? rightMessage;
  // Common
  final VoidCallback? onClosed;
  final bool isTwoButton;

  const CustomDialog({
    super.key,
    required this.title, // ''
    required this.message, // ''
    this.onPressed,
    this.okMessage,
    this.leftOnPressed,
    this.rightOnPressed,
    this.leftMessage,
    this.rightMessage,
    required this.isTwoButton,
    this.onClosed,
  }) : assert(
          isTwoButton
              ? (leftOnPressed != null &&
                  leftMessage != null &&
                  rightOnPressed != null &&
                  rightMessage != null)
              : (onPressed != null && okMessage != null),
          "If isTwoButton is not true, you must provide onPressed and okMessage.",
        );

  factory CustomDialog.oneButton({
    required String title, // ''
    required String message, // ''
    required VoidCallback onPressed,
    required String okMessage,
    VoidCallback? onClosed,
  }) {
    return CustomDialog(
      title: title,
      message: message,
      onPressed: onPressed,
      okMessage: okMessage,
      onClosed: onClosed,
      isTwoButton: false,
    );
  }

  factory CustomDialog.twoButton({
    required String title, // ''
    required String message, // ''
    required VoidCallback leftOnPressed,
    required VoidCallback rightOnPressed,
    required String leftMessage,
    required String rightMessage,
    VoidCallback? onClosed,
  }) {
    return CustomDialog(
      title: title,
      message: message,
      leftOnPressed: leftOnPressed,
      leftMessage: leftMessage,
      rightOnPressed: rightOnPressed,
      rightMessage: rightMessage,
      isTwoButton: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        _ifClosed(onClosed);
        return;
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        insetPadding: EdgeInsets.zero,
        elevation: 0,
        child: Container(
          width: 316,
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyle.title1.copyWith(color: AppColor.of.confirm),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyle.body1,
                maxLines: 10,
              ),
              const SizedBox(height: 24),
              isTwoButton
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 137,
                          height: 46,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FilledButton(
                              onPressed: leftOnPressed,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColor.of.gray,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                leftMessage!,
                                style: AppTextStyle.headline1
                                    .copyWith(color: AppColor.of.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 137,
                          height: 46,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FilledButton(
                              onPressed: rightOnPressed,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColor.of.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                rightMessage!,
                                style: AppTextStyle.headline1
                                    .copyWith(color: AppColor.of.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  :
                  // OneButton
                  SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FilledButton(
                          onPressed: onPressed,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColor.of.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            okMessage!,
                            style: AppTextStyle.headline1
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  bool _ifClosed(VoidCallback? onClosed) {
    if (onClosed == null) {
      return true;
    } else {
      return false;
    }
  }
}
