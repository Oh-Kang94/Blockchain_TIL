import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';

enum _TextFieldState {
  enabled,
  focus,
  active,
  filled,
  disabled,
  errorFocus,
  errorActive,
  success
}

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hintText,
    this.onEditingComplete,
    this.onTap,
    this.onChanged,
    this.onClear,
    this.isEndTextField = false,
    this.isObscure = false,
    this.helperText,
    this.resultText,
    this.isSuccess,
    this.inputFormatters,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.isClear = false,
  })  : assert(
          !isObscure || onClear != null,
          'onClear cannot be null if isObscure is true',
        ),
        assert(
          !(isClear && onClear == null),
        );

  final FocusNode focusNode;
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final FutureOr<void> Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final bool isEndTextField;
  final bool isObscure;
  final bool isClear;
  final String? helperText;
  final String? resultText;
  final bool? isSuccess;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;
  final bool enabled;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  _TextFieldState _state = _TextFieldState.enabled;
  bool _canClear = false;
  bool _obscureValue = true;
  String? resultText;
  bool? isSuccess;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocusChange);
    widget.controller.addListener(_handleTextChange);
    resultText = widget.resultText ?? widget.helperText;
    isSuccess = widget.isSuccess;
    _updateState();
  }

  @override
  void didUpdateWidget(CustomTextfield oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.resultText != resultText) {
      resultText = widget.resultText ?? widget.helperText;
    }
    if (widget.isSuccess != isSuccess) {
      isSuccess = widget.isSuccess;
    }
    _updateState();
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleFocusChange() {
    _updateState();
  }

  void _handleTextChange() {
    _canClear = widget.controller.text.isNotEmpty || widget.isClear;
    setState(() {});
    _updateState();
  }

  // 상태를 결정하는 함수
  _TextFieldState _determineState() {
    if (!widget.enabled) {
      return _TextFieldState.disabled;
    }
    if (widget.isSuccess == false) {
      return widget.focusNode.hasFocus
          ? _TextFieldState.errorFocus
          : _TextFieldState.errorActive;
    }

    if (widget.isSuccess == true) {
      return _TextFieldState.success;
    }

    if (widget.controller.text.isNotEmpty &&
        widget.focusNode.hasFocus == false) {
      return _TextFieldState.filled;
    }
    if (widget.focusNode.hasFocus) {
      return _TextFieldState.focus;
    }
    return _TextFieldState.enabled;
  }

  void _updateState() {
    // 상태를 결정하고 UI 업데이트
    _state = _determineState();
    setState(() {});
  }

  Color _getBackgroundColor() {
    switch (_state) {
      case _TextFieldState.errorFocus:
      case _TextFieldState.errorActive:
        return AppColor.of.gray.withOpacity(0.3);
      case _TextFieldState.success:
        return AppColor.of.confirm;
      case _TextFieldState.focus:
      case _TextFieldState.active:
        return AppColor.of.gray;
      case _TextFieldState.enabled:
      case _TextFieldState.filled:
      case _TextFieldState.disabled:
        return AppColor.of.gray;
    }
  }

  Color _getBorderColor() {
    switch (_state) {
      case _TextFieldState.errorFocus:
      case _TextFieldState.errorActive:
        return AppColor.of.error;
      case _TextFieldState.success:
        return AppColor.of.confirm;
      case _TextFieldState.focus:
      case _TextFieldState.active:
        return AppColor.of.white;
      case _TextFieldState.enabled:
      case _TextFieldState.filled:
      case _TextFieldState.disabled:
        return Colors.transparent;
    }
  }

  Color _getLabelColor() {
    switch (_state) {
      case _TextFieldState.enabled:
      case _TextFieldState.focus:
      case _TextFieldState.active:
      case _TextFieldState.filled:
        return AppColor.of.black;
      case _TextFieldState.disabled:
        return AppColor.of.gray;
      case _TextFieldState.errorFocus:
      case _TextFieldState.errorActive:
        return AppColor.of.error;
      case _TextFieldState.success:
        return AppColor.of.confirm;
    }
  }

  Color _getResultColor() {
    switch (_state) {
      case _TextFieldState.enabled:
      case _TextFieldState.focus:
      case _TextFieldState.active:
        return AppColor.of.black;
      case _TextFieldState.errorFocus:
      case _TextFieldState.errorActive:
        return AppColor.of.error;
      case _TextFieldState.success:
        return AppColor.of.confirm;
      case _TextFieldState.disabled:
      case _TextFieldState.filled:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    switch (_state) {
      case _TextFieldState.active:
      case _TextFieldState.filled:
      case _TextFieldState.errorActive:
      case _TextFieldState.focus:
      case _TextFieldState.success:
        return AppColor.of.black;

      case _TextFieldState.enabled:
      case _TextFieldState.disabled:
      case _TextFieldState.errorFocus:
        return AppColor.of.gray;
    }
  }

  Widget _buildHelperText() {
    // final text = widget.resultText ?? widget.helperText;
    final text = resultText;
    if (text == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 4),
      child: Text(
        text,
        style: AppTextStyle.body1.copyWith(color: _getResultColor()),
      ),
    );
  }

  Widget _buildObscureButton() {
    if (!widget.isObscure) return const SizedBox.shrink();
    return Row(
      children: [
        if (_canClear) _buildClearButton(),
        GestureDetector(
          onTap: _toggleObscure,
          child: SizedBox(
            width: 24,
            child: Icon(
              _obscureValue
                  ? Icons.remove_red_eye_outlined
                  : Icons.remove_red_eye_rounded,
              color: AppColor.of.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClearButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: widget.onClear,
        child: const SizedBox(
          width: 24,
          child: Icon(
            Icons.delete_outline,
          ),
        ),
      ),
    );
  }

  void _toggleObscure() {
    setState(() {
      _obscureValue = !_obscureValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            border: Border.all(
              width: 1,
              color: _getBorderColor(),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.label,
                      style:
                          AppTextStyle.body1.copyWith(color: _getLabelColor()),
                    ),
                    TextField(
                      focusNode: widget.focusNode,
                      controller: widget.controller,
                      onChanged: (value) async {
                        final controller = widget.controller;
                        // 현재 커서 위치 저장
                        final cursorPos = controller.selection;
                        if (widget.onChanged != null) {
                          // onChanged가 비동기일 수도, 아닐 수도 있기 때문에 처리
                          var result = widget.onChanged!(value);

                          if (result is Future) {
                            await result;
                          }
                        }
                        if (cursorPos.start > controller.text.length) {
                          controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: controller.text.length),
                          );
                        } else {
                          // 기존 커서 위치로 복원
                          controller.selection = cursorPos;
                        }

                        setState(() {});
                      },
                      onEditingComplete: widget.onEditingComplete,
                      onTap: widget.onTap,
                      textInputAction: widget.isEndTextField
                          ? TextInputAction.done
                          : TextInputAction.next,
                      obscureText: widget.isObscure && _obscureValue,
                      inputFormatters: widget.inputFormatters,
                      keyboardType: widget.keyboardType,
                      style:
                          AppTextStyle.body1.copyWith(color: _getTextColor()),
                      enabled: widget.enabled,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: AppTextStyle.body1
                            .copyWith(color: AppColor.of.gray),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
              !widget.isClear ? _buildObscureButton() : _buildClearButton(),
            ],
          ),
        ),
        _buildHelperText(),
      ],
    );
  }
}
