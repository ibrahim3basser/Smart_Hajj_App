import 'package:flutter/material.dart';
import 'package:hajj_app/constants.dart';
class CustomFormTextField extends StatefulWidget {
  const CustomFormTextField({
    super.key,
    this.labelText,
    this.onChanged,
    this.obscureText = false,
    required this.controller,
    this.icon,
  });

  final IconButton? icon;
  final String? labelText;
  final Function(String)? onChanged;
  final bool obscureText;
  final TextEditingController controller;

  @override
  _CustomFormTextFieldState createState() => _CustomFormTextFieldState();
}

class _CustomFormTextFieldState extends State<CustomFormTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _isObscured,
        validator: (data) {
          if (data!.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(color: Colors.white),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(color: Colors.white),
          ),
          hintText: widget.labelText,
          hintStyle: const TextStyle(color: Colors.white),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
