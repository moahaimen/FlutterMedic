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
    return ScopedModelDescendant<StateModel>(
      builder: (BuildContext context, Widget child, StateModel model) {
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
                child: TextFormField(
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
                  autovalidate: true,
                  validator: (String v) {
                    if (v == null || v.isEmpty) {
                      return translator.text('required_field');
                    } else {
                      final index = model.provinces.data
                          .indexWhere((e) => e.enName == v || e.arName == v);
                      if (index < 0 || index >= model.provinces.data.length) {
                        return translator.text('province_must_be_valid');
                      } else {
                        return null;
                      }
                    }
                  },
                  onTap: () async {
                    final province = await _openProvincesModal(
                        context,
                        translator.text('select_province'),
                        model.provinces.data);
                    onSave(province.id);
                    controller.text = province.getName(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Province> _openProvincesModal(
      BuildContext context, String title, List<Province> provinces) async {
    return showDialog<Province>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
          title: Text(title),
          children: _getSimpleDialogChildren(context, provinces)),
    );
  }

  List<Widget> _getSimpleDialogChildren(
      BuildContext context, List<Province> provinces) {
    assert(provinces != null);

    return provinces
        .map((e) => SimpleDialogOption(
              onPressed: () => Navigator.pop(context, e),
              child: Text(e.getName(context)),
            ))
        .toList();
  }
}
