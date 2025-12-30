import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
    this.icon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        icon: Image.asset('assets/pngs/chevron.png', width: 20, height: 20),
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Color(0xffF6F7F9),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
