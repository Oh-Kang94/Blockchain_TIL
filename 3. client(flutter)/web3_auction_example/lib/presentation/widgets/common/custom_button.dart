import 'package:flutter/material.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';

enum ButtonState {
  able,
  pressed,
  disable,
}

enum ButtonSize {
  large,
  medium,
  small,
  xs,
  tiny,
}

enum ButtonHierarchy {
  primary,
  secondary,
}

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.content,
    required this.onPressed,
    required this.buttonSize,
    required this.buttonHierarchy,
    this.canSelect = true,
  });
  final String content;
  final VoidCallback onPressed;
  final ButtonSize buttonSize;
  final ButtonHierarchy buttonHierarchy;
  final bool canSelect;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  late ValueNotifier<ButtonState> buttonStateNotifier;

  @override
  void initState() {
    super.initState();
    buttonStateNotifier = ValueNotifier(_getButtonState);
  }

  @override
  void didUpdateWidget(covariant CustomButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    buttonStateNotifier.value = _getButtonState;
  }

  @override
  void dispose() {
    buttonStateNotifier.dispose();
    super.dispose();
  }

  ButtonState get _getButtonState {
    return widget.canSelect ? ButtonState.able : ButtonState.disable;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ButtonState>(
      valueListenable: buttonStateNotifier,
      builder: (context, buttonState, child) {
        return SizedBox(
          width: double.infinity,
          height: _getHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: FilledButton(
              onPressed: buttonState == ButtonState.disable
                  ? null
                  : () async => await _handleOnPressed(),
              style: FilledButton.styleFrom(
                disabledBackgroundColor: _getBackGroundColor(buttonState),
                backgroundColor: _getBackGroundColor(buttonState),
                padding: EdgeInsets.only(
                  top: _getPadding - 2,
                  bottom: _getPadding,
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: _getBorderColor(buttonState),
                    width: 1,
                  ),
                  borderRadius: _getRadius,
                ),
                overlayColor: WidgetStateColor.resolveWith(
                  (states) {
                    if (states.contains(WidgetState.pressed)) {
                      return _getBackGroundColor(buttonState);
                    }
                    if (states.contains(WidgetState.hovered)) {
                      return _getBackGroundColor(ButtonState.pressed);
                    }
                    return Colors.transparent;
                  },
                ),
              ),
              child: Text(
                widget.content,
                style:
                    _getTextStyle.copyWith(color: _getTextColor(buttonState)),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleOnPressed() async {
    buttonStateNotifier.value = ButtonState.pressed;
    await Future.delayed(const Duration(milliseconds: 300));
    buttonStateNotifier.value = ButtonState.able;
    widget.onPressed();
  }

  double get _getHeight {
    switch (widget.buttonSize) {
      case ButtonSize.large:
        return 56;
      case ButtonSize.medium:
        return 52;
      case ButtonSize.small:
        return 46;
      case ButtonSize.xs:
        return 38;
      case ButtonSize.tiny:
        return 28;
    }
  }

  double get _getPadding {
    switch (widget.buttonSize) {
      case ButtonSize.large:
        return 16.5;
      case ButtonSize.medium:
        return 14.5;
      case ButtonSize.small:
        return 13;
      case ButtonSize.xs:
        return 9;
      case ButtonSize.tiny:
        return 4;
    }
  }

  BorderRadius get _getRadius {
    switch (widget.buttonSize) {
      case ButtonSize.large:
      case ButtonSize.medium:
        return BorderRadius.circular(12);
      case ButtonSize.small:
      case ButtonSize.xs:
        return BorderRadius.circular(10);
      case ButtonSize.tiny:
        return BorderRadius.circular(8);
    }
  }

  Color _getBackGroundColor(ButtonState buttonState) {
    switch (widget.buttonHierarchy) {
      case ButtonHierarchy.primary:
        switch (buttonState) {
          case ButtonState.able:
            return AppColor.of.confirm;

          case ButtonState.pressed:
            return AppColor.of.white;
          case ButtonState.disable:
            return const Color(0xffFAFAFA);
        }

      case ButtonHierarchy.secondary:
        switch (buttonState) {
          case ButtonState.able:
            return AppColor.of.white;

          case ButtonState.pressed:
            return AppColor.of.secondary.withRed(100);

          case ButtonState.disable:
            return const Color(0xffFAFAFA);
        }
    }
  }

  Color _getBorderColor(ButtonState buttonState) {
    switch (widget.buttonHierarchy) {
      case ButtonHierarchy.primary:
        switch (buttonState) {
          case ButtonState.able:
            return Colors.transparent;

          case ButtonState.pressed:
            return AppColor.of.confirm.withRed(100);

          case ButtonState.disable:
            return AppColor.of.confirm.withRed(100);
        }

      case ButtonHierarchy.secondary:
        switch (buttonState) {
          case ButtonState.able:
            return AppColor.of.secondary;

          case ButtonState.pressed:
            return AppColor.of.secondary.withRed(100);

          case ButtonState.disable:
            return AppColor.of.secondary.withRed(100);
        }
    }
  }

  Color _getTextColor(ButtonState buttonState) {
    switch (widget.buttonHierarchy) {
      case ButtonHierarchy.primary:
        switch (buttonState) {
          case ButtonState.able:
            return AppColor.of.white;

          case ButtonState.pressed:
            return AppColor.of.confirm;

          case ButtonState.disable:
            return const Color(0xffE1E1E1);
        }

      case ButtonHierarchy.secondary:
        switch (buttonState) {
          case ButtonState.able:
            return AppColor.of.secondary;

          case ButtonState.pressed:
            return AppColor.of.white;

          case ButtonState.disable:
            return const Color(0xffE1E1E1);
        }
    }
  }

  TextStyle get _getTextStyle {
    switch (widget.buttonSize) {
      case ButtonSize.medium:
      case ButtonSize.large:
        return AppTextStyle.title1;
      case ButtonSize.small:
      case ButtonSize.xs:
        return AppTextStyle.body1;
      case ButtonSize.tiny:
        return AppTextStyle.body3;
    }
  }
}
