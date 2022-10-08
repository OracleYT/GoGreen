import 'package:flutter/material.dart';

import '../constant.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {this.icon,
      this.hint,
      this.obsecure = false,
      this.validator,
      this.onSaved,
      this.textController,
      this.maxLength,
      this.sufficText,
      this.readOnly = false,
      this.initialValue,
      this.onTap,
      this.textAlign = TextAlign.left,
      this.maxLines = 1,
      this.minLines = 1,
      this.autofocus,
      this.keyboardType = TextInputType.text,
      this.key});
  final FormFieldSetter<String> onSaved;
  final Icon icon;
  final String hint, sufficText;
  final bool obsecure, readOnly;
  final FormFieldValidator<String> validator;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final int maxLength;
  final TextAlign textAlign;
  final onTap;
  final String initialValue;
  final int maxLines, minLines;
  final bool autofocus;
  final Key key;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: key,
        onTap: onTap,
        keyboardType: keyboardType,
        onSaved: onSaved,
        validator: validator,
        autofocus: autofocus ?? false,
        obscureText: obsecure,
        maxLength: maxLength,
        readOnly: readOnly,
        textAlign: textAlign,
        initialValue: initialValue,
        minLines: minLines,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: 20,
        ),
        decoration: InputDecoration(
            hintStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 0.27,

              color: Color.fromARGB(
                  255, 199, 201, 207), // Color.fromARGB(255, 107, 108, 114),
            ), //TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            hintText: hint,
            contentPadding: EdgeInsets.all(24),
            errorStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
                color: Color.fromARGB(215, 255, 45, 45)),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Color.fromARGB(
                    215, 255, 45, 45), // Color.fromARGB(255, 206, 63, 53),
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Color.fromARGB(
                    215, 255, 45, 45), //Color.fromARGB(255, 210, 81, 71),
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Color.fromRGBO(231, 236, 243, 1),
                width: 2,
              ),
            ),
            // focusColor: MyColors.resolveCompanyCOlour(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Color.fromRGBO(231, 236, 243, 1),
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Utils.themeColor,
                width: 2,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Color.fromRGBO(231, 236, 243, 1),
                width: 2,
              ),
            ),
            suffixIcon: sufficText != null
                ? Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        sufficText,
                        style: TextStyle(
                          color: Color.fromARGB(215, 255, 45, 45),
                        ),

                        ///Color.fromARGB(255, 210, 81, 71),
                      ),
                    ),
                  )
                : null,
            prefixIcon: icon != null
                ? Padding(
                    child: IconTheme(
                      data: IconThemeData(color: Utils.themeColor),
                      child: icon,
                    ),
                    padding: EdgeInsets.only(left: 26, right: 16),
                  )
                : null),
        controller: textController,
      ),
    );
  }
}
