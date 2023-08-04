import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// import 'package:dropdown_search/dropdown_search.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_duty/widgets/app_alerts.dart';
import 'package:on_duty/widgets/resetPassword_modal.dart';

import '../design/app_colors.dart';
import '../design/app_text.dart';
import '../utils/form_validation.dart';

class AppForm {
  static Widget appTextFormField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    bool isEmail = false,
    bool isRequired = false,
    bool isEnabled = true,
    bool isExpands = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppText.labelSemiBold),
            isRequired
                ? const Text("*",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightError,
                    ))
                : const Text(""),
          ],
        ),
        const SizedBox(height: 4),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "${label.toLowerCase()} alanı boş bırakılamaz.";
            } else if (isEmail) {
              return FormValidation.validateEmail(value);
            } else if (isPassword) {
              return FormValidation.validatePassword(value);
            } else {
              return null;
            }
          },
          expands: isExpands,
          maxLines: maxLines,
          enabled: isEnabled,
          controller: controller,
          keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.text,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
      ],
    );
  }

  static Widget appTextFormFieldIcon({
    required String label,
    required String hint,
    required Icon icon,
    required TextEditingController controller,
    bool isPassword = false,
    bool isEmail = false,
    bool isRequired = false,
    bool isPrefixIcon = true,
    bool isEnabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppText.labelSemiBold),
            isRequired
                ? const Text("*",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightError,
                    ))
                : const Text(""),
          ],
        ),
        const SizedBox(height: 4),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "${label.toLowerCase()} alanı boş bırakılamaz.";
            } else if (isEmail) {
              return FormValidation.validateEmail(value);
            } else if (isPassword) {
              return FormValidation.validatePassword(value);
            } else {
              return null;
            }
          },
          enabled: isEnabled,
          controller: controller,
          keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.text,
          obscureText: isPassword,
          decoration: InputDecoration(
            prefixIcon: isPrefixIcon ? icon : null,
            suffixIcon: !isPrefixIcon ? icon : null,
            hintText: hint,
          ),
        ),
      ],
    );
  }

  static Widget appAutoCompleteTextFormField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required GlobalKey<AutoCompleteTextFieldState<String>> key,
    required List<String> suggestions,
    bool isRequired = false,
    bool isEnabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppText.labelSemiBold),
            isRequired
                ? const Text("*",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightError,
                    ))
                : const Text(""),
          ],
        ),
        const SizedBox(height: 4),
        SimpleAutoCompleteTextField(
          key: key,
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
          ),
          suggestions: suggestions,
          textSubmitted: (String value) {},
          clearOnSubmit: false,
        ),
      ],
    );
  }

  static Widget appTextFormFieldRegex({
    required RegExp formatter,
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    bool isEmail = false,
    bool isRequired = false,
    bool isEnabled = true,
    bool isExpands = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppText.labelSemiBold),
            isRequired
                ? const Text("*",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightError,
                    ))
                : const Text(""),
          ],
        ),
        const SizedBox(height: 4),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "${label.toLowerCase()} alanı boş bırakılamaz.";
            } else if (isEmail) {
              return FormValidation.validateEmail(value);
            } else if (isPassword) {
              return FormValidation.validatePassword(value);
            } else {
              return null;
            }
          },
          expands: isExpands,
          maxLines: maxLines,
          enabled: isEnabled,
          controller: controller,
          keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.text,
          inputFormatters: [FilteringTextInputFormatter.allow(formatter)],
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
      ],
    );
  }

  static Widget appTextFormFieldRegexNumber({
    required String label,
    required String hint,
    required TextEditingController controller,
    required GlobalKey<AutoCompleteTextFieldState<String>> key,
    required TextInputType keyboardType,
    bool isRequired = false,
    bool isEnabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppText.labelSemiBold),
            isRequired
                ? const Text("*",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightError,
                    ))
                : const Text(""),
          ],
        ),
        const SizedBox(height: 4),
        TextFormField(
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]*)'))
          ],
          keyboardType: keyboardType,
          key: key,
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
        /*SimpleAutoCompleteTextField(
          keyboardType: keyboardType,
          key: key,
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
          ),
          suggestions: suggestions,
          textSubmitted: (String value) {},
          clearOnSubmit: false,
        ),*/
      ],
    );
  }

  // static Widget appSearchableDropDownField({
  //   required List<String> items,
  //   required String label,
  //   required Function(String?) onChanged,
  //   required selectedItem,
  //   bool isRequired = false,
  //   bool isEnabled = true,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         children: [
  //           Text(label, style: AppText.labelSemiBold),
  //           isRequired
  //               ? const Text("*",
  //               style: TextStyle(
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w600,
  //                 color: AppColors.lightError,
  //               ))
  //               : const Text(""),
  //         ],
  //       ),
  //       DropdownSearch<String>(
  //         enabled: isEnabled,
  //         popupProps: PopupProps.menu(
  //           menuProps: const MenuProps(
  //               backgroundColor: Color.fromRGBO(242, 242, 242, 1)),
  //           showSelectedItems: true,
  //           showSearchBox: true,
  //           disabledItemFn: (String s) => s.startsWith('I'),
  //         ),
  //         items: items,
  //         onChanged: onChanged,
  //         selectedItem: selectedItem,
  //       )
  //     ],
  //   );
  // }

}

class PasswordFieldWithVisibility extends StatefulWidget {
  const PasswordFieldWithVisibility({
    Key? key,
    required this.controller,
    this.content,
    required this.showForgotPassword,
  }) : super(key: key);
  final TextEditingController controller;
  final Widget? content;
  final bool showForgotPassword;

  @override
  State<PasswordFieldWithVisibility> createState() =>
      _PasswordFieldWithVisibilityState();
}

class _PasswordFieldWithVisibilityState
    extends State<PasswordFieldWithVisibility> {
  bool isObscure = true;

  void changePasswordVisibility() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Şifre", style: AppText.labelSemiBold),
            const SizedBox(height: 4),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "şifre alanı boş bırakılamaz.";
                } else if (value != null || value.isNotEmpty) {
                  return FormValidation.validatePassword(value);
                } else {
                  return null;
                }
              },
              controller: widget.controller,
              obscureText: isObscure,
              decoration: InputDecoration(
                hintText: "Şifre 6 ila 18 karakter olmalı",
                suffixIcon: IconButton(
                  onPressed: changePasswordVisibility,
                  icon: Icon(!isObscure
                      ? FluentIcons.eye_24_regular
                      : FluentIcons.eye_off_24_regular),
                ),
              ),
            ),
          ],
        ),

        widget.showForgotPassword ? Positioned(
          right: -10,
          top: -15,
          child: TextButton(
              child: Text("Şifremi Unuttum", style: AppText.label),
              onPressed: () => {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return widget.content!;
                        }),

                  }),
        ):Container()
      ],
    );
  }
}
