import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String title;
  final String initialValue;

  final void Function(String value) onSave;
  final void Function(String value) onChanged;
  final String Function(String value) validator;

  final Color color;
  final int maxLines;
  final TextInputType keyboardType;

  CustomFormField({
    @required this.title,
    @required this.initialValue,
    @required this.onSave,
    @required this.onChanged,
    @required this.validator,
    @required this.color,
    int maxLines,
    TextInputType keyboardType,
  })  : this.maxLines = maxLines ?? 1,
        this.keyboardType = keyboardType ?? TextInputType.text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Container(
            decoration: BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15)),
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            child: TextFormField(
              initialValue: initialValue,
              maxLines: maxLines,
              minLines: 1,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: title,
              ),
              cursorColor: color,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.done,
              keyboardType: keyboardType,
              autovalidate: true,
              validator: validator,
              onSaved: onSave,
              onChanged: onSave,
            ),
          ),
        ],
      ),
    );
  }
}
