import 'package:flutter/material.dart';
import 'package:money_planning_app/utils/base_colors.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final TextInputType? keyboardType;
  final String? hintText;
  final String? Function(String?)? validator;
  final int? maxLines;
  const TextFieldWidget(
      {super.key,
      this.controller,
      this.labelText,
      this.keyboardType,
      this.hintText,
      this.validator,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null)
          Text(labelText!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          autofocus: false,
          maxLines: maxLines,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Theme.of(context).colorScheme.surface),
          decoration: InputDecoration(
              hintText: hintText,
              errorStyle: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: BaseColors.textFieldError),
              fillColor: Theme.of(context).colorScheme.onSurface,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                      width: 0.5, color: BaseColors.textFieldError))),
          validator: validator,
        ),
      ],
    );
  }
}
