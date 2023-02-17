import 'package:flutter/material.dart';

class DropdownFormGroup extends StatelessWidget {
  final String label;
  final String hintText;
  final String? Function(String?)? validator;
  final int? maxLines;
  final TextInputType? textInputType;
  final bool obscureText;

  final List<DropdownMenuItem<String>>? items;
  final Function(String?)? onChange;
  final String? defaultValue;

  const DropdownFormGroup({
    super.key,
    required this.label,
    required this.hintText,
    this.validator,
    this.maxLines,
    this.textInputType,
    this.obscureText = false,
    this.items,
    this.onChange,
    this.defaultValue,
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
        DropdownButtonFormField(
          hint: Text(hintText),
          value: defaultValue,
          decoration: InputDecoration(
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            fillColor: Colors.grey.shade100,
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
          items: items,
          onChanged: onChange,
        ),
      ],
    );
  }
}
