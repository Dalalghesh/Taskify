import 'package:taskify/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../utils/validators.dart';

class TitledDropDown<T> extends StatelessWidget {
  final String title;
  final String? hint;
  final ValueChanged<T?>? onChanged;
  final List<String> titles;
  final List<T> items;
  final T? value;
  const TitledDropDown({
    Key? key,
    required this.title,
    this.hint,
    this.onChanged,
    required this.titles,
    required this.items,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(0.70),
            ),
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          value: value,
          dropdownColor: Color.fromARGB(255, 255, 255, 255),
          menuMaxHeight: MediaQuery.of(context).size.height * 0.6,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            fillColor: AppColors.grayshade,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          hint: Text(
            hint ?? 'Select $title',
            style: const TextStyle(color: Colors.black54),
          ),
          items: items.asMap().entries.map((e) {
            final key = e.key;
            final title = titles[key];
            return DropdownMenuItem(
              value: e.value,
              child: Text(title),
            );
          }).toList(),
          onChanged: onChanged,
          isExpanded: true,
          validator: (value) => Validators.emptyValidator((value) as String),
        ),
      ],
    );
  }
}
