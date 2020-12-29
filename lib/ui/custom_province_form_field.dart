import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/province.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomProvinceFormField extends StatelessWidget {
  final String title;
  final String initialValue;

  final void Function(int value) onSave;
  final Color color;

  final controller;

  CustomProvinceFormField({
    @required this.title,
    @required this.initialValue,
    @required this.onSave,
    @required this.color,
  }) : this.controller = new TextEditingController(text: initialValue);

  @override
  Widget build(BuildContext context) {
    final translator = AppTranslations.of(context);

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
            child: ScopedModelDescendant<StateModel>(
              builder: (context, child, model) {
                if (controller.text == null && model.provincesLoading ||
                    model.provinces == null ||
                    model.provinces.isEmpty) {
                  if (model.provinces == null || model.provinces.isEmpty) {
                    model.fetchProvinces();
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return TextFormField(
                    readOnly: true,
                    controller: controller,
                    minLines: 1,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: title,
                    ),
                    cursorColor: color,
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.done,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String province) {
                      if (province == null || province.isEmpty) {
                        return translator.text('required_field');
                      }
                      return null;
                    },
                    onTap: () =>
                        _openProvincesModal(
                          context,
                          translator.locale.languageCode,
                          model.provinces,
                        ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openProvincesModal(BuildContext context, String locale,
      List<Province> provinces) async {
    final result = await showDialog<Province>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: Text(title),
        children: provinces
            .map((e) => _createSimpleDialogOption(context, locale, e))
            .toList(),
      ),
    );
    onSave(result.id);
    controller.text = result.getName(locale);
  }

  Widget _createSimpleDialogOption(BuildContext context, String locale,
      Province e) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context, e);
      },
      child: Text(e.getName(locale)),
    );
  }
}
