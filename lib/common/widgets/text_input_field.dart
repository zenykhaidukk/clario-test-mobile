import 'package:clario_flutter_test/common/app_assets.dart';
import 'package:clario_flutter_test/common/app_colors.dart';
import 'package:clario_flutter_test/common/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

enum FieldType {
  email,
  password,
}

enum InputState {
  initial,
  success,
  error,
}

extension InputStateExt on InputState {
  Color get inputLineColor {
    switch (this) {
      case InputState.initial:
        return AppColors.inputLine;
      case InputState.success:
        return AppColors.successInputLine;
      case InputState.error:
        return AppColors.errorInputLine;
    }
  }

  Color get textColor {
    switch (this) {
      case InputState.initial:
        return AppColors.mainText;
      case InputState.success:
        return AppColors.successText;
      case InputState.error:
        return AppColors.errorText;
    }
  }
}

class TextInputField extends StatefulWidget {
  const TextInputField._({
    required this.controller,
    required this.hintText,
    required this.fieldType,
    required this.onChanged,
    this.inputState = InputState.initial,
  });

  factory TextInputField.email({
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    InputState inputState = InputState.initial,
  }) {
    return TextInputField._(
      controller: controller,
      onChanged: onChanged,
      fieldType: FieldType.email,
      hintText: 'Enter your email',
      inputState: inputState,
    );
  }

  factory TextInputField.password({
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    InputState inputState = InputState.initial,
  }) {
    return TextInputField._(
      controller: controller,
      onChanged: onChanged,
      fieldType: FieldType.password,
      hintText: 'Create your password',
      inputState: inputState,
    );
  }

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;
  final InputState inputState;
  final FieldType fieldType;

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.fieldType == FieldType.password;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size.fromHeight(48),
      child: TextFormField(
        controller: widget.controller,
        cursorColor: AppColors.inputLine,
        obscureText: _isObscured,
        style: GoogleFonts.inter(
          color: widget.inputState.textColor,
          fontSize: 16,
        ),
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: GoogleFonts.inter(
            color: AppColors.secondaryText,
            fontSize: 16,
          ),
          filled: true,
          fillColor: AppColors.white,
          errorStyle: GoogleFonts.inter(
            color: AppColors.errorText,
            fontSize: 16,
          ),
          errorBorder: _getInputBorder(const BorderSide(color: AppColors.errorInputLine)),
          border: widget.inputState == InputState.initial
              ? _getInputBorder(BorderSide.none)
              : _getInputBorder(BorderSide(color: widget.inputState.inputLineColor)),
          focusedBorder: _getInputBorder(BorderSide(color: widget.inputState.inputLineColor)),
          enabledBorder: widget.inputState == InputState.initial
              ? _getInputBorder(BorderSide.none)
              : _getInputBorder(BorderSide(color: widget.inputState.inputLineColor)),
          focusedErrorBorder: _getInputBorder(const BorderSide(color: AppColors.errorInputLine)),
          suffixIcon: widget.fieldType == FieldType.password
              ? GestureDetector(
                  onTap: () => setState(() => _isObscured = !_isObscured),
                  child: Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.medium),
                    child: SvgPicture.asset(
                      AppAssets.eye,
                      height: 24,
                      width: 24,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  InputBorder _getInputBorder(BorderSide borderSide) {
    return OutlineInputBorder(
      borderSide: borderSide,
      borderRadius: BorderRadius.circular(10),
    );
  }
}
