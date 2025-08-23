import "package:flutter/material.dart";
import "package:internship_tracker/core/app_theme.dart";
import "package:internship_tracker/core/widgets/item_weidgt.dart";

class Field extends StatefulWidget {
  final String fieldName;
  final String hintText;
  final bool password;
  final TextEditingController controller;

  const Field({
    super.key,
    required this.fieldName,
    required this.hintText,
    this.password = false,
    required this.controller,
  });

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.fieldName,
          style: styleText(
            15,
            FontWeight.w400,
          ).copyWith(fontStyle: FontStyle.normal, wordSpacing: 1.5),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: widget.controller,
          obscureText: _obscureText,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            filled: true,
            fillColor: AppTheme.boxFeild,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: AppTheme.grayDark,
                width: 1.5,
              ),
            ),
            hintText: widget.hintText,
            hintStyle: styleText(
              15,
              FontWeight.w300,
            ).copyWith(color: AppTheme.ggray),
            suffixIcon: widget.password
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppTheme.ggray,
                    ),
                  )
                : null,
          ),
          style: styleText(15, FontWeight.w400),
        ),
      ],
    );
  }
}
