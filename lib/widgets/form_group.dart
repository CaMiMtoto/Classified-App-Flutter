import 'package:flutter/material.dart';

class TextFormGroup extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final String? Function(String?)? validator;
  final int? maxLines;
  final TextInputType? textInputType;
  final bool obscureText;
  final bool? enabled;
  final void Function()? onTap;

  const TextFormGroup({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.validator,
    this.maxLines,
    this.textInputType,
    this.obscureText = false,
    this.enabled, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: controller,
          onTap: onTap,
          maxLines: maxLines,
          keyboardType: textInputType,
          obscureText: obscureText,
          enabled: enabled,
          decoration: InputDecoration(
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            hintText: hintText,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            fillColor: Colors.white,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.secondary),
            ),
            errorBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.error),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
