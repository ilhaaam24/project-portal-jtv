import 'package:flutter/material.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';

class CustomFormField extends StatefulWidget {
  final String label;
  final String placeholder;
  final bool isObsecure;
  final TextEditingController? controller;

  const CustomFormField({
    super.key,
    required this.label,
    required this.placeholder,
    this.isObsecure = false,
    this.controller,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late bool _isObsecure;

  @override
  void initState() {
    super.initState();
    _isObsecure = widget.isObsecure;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w600,
            color: PortalColors.black,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: widget.controller,
          obscureText: _isObsecure,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: PortalColors.grey500, width: 1),
            ),
            hintText: widget.placeholder,
            fillColor: Colors.transparent,
            suffixIcon: widget.isObsecure
                ? IconButton(
                    icon: Icon(
                      _isObsecure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObsecure = !_isObsecure;
                      });
                    },
                  )
                : null,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return "Field wajib diisi";
            }
            return null;
          },
        ),
      ],
    );
  }
}
