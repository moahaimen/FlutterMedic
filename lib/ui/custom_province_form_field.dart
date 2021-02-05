import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/province.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

class CustomProvinceFormField extends StatefulWidget {
  final String title;
  final int initialValue;

  final void Function(int value) onSave;
  final Color color;

  CustomProvinceFormField({
    @required this.title,
    @required this.initialValue,
    @required this.onSave,
    @required this.color,
  });

  @override
  State<StatefulWidget> createState() {
    return _CustomProvinceFormFieldState();
  }
}

class _CustomProvinceFormFieldState extends State<CustomProvinceFormField> {
  final TextEditingController controller = new TextEditingController();

  void _setInitialValue() {
    final provinces = ScopedModel.of<StateModel>(context).provinces;

    Province province;

    if (provinces == null || provinces.length == 0) {
      print('Provinces null or empty');
    } else {
      final id = this.widget.initialValue;
      province = provinces.firstWhere((p) => p.id == id, orElse: () => null);

      if (province == null) {
        province = provinces.first;
      }
    }

    if (province != null) {
      final lang = "en";

      this.widget.onSave(province.id);
      this.controller.text = province.getName(lang);
    } else {
      this.widget.onSave(null);
      this.controller.text = '';
    }
  }

  @override
  void initState() {
    super.initState();

    _setInitialValue();
  }

  @override
  Widget build(BuildContext context) {
    final translator = AppTranslations.of(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(this.widget.title),
          Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            child: ScopedModelDescendant<StateModel>(
              builder: (context, child, model) {
                if (model.provincesLoading) {
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
                      hintText: this.widget.title,
                    ),
                    cursorColor: this.widget.color,
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String province) {
                      if (province == null || province.isEmpty) {
                        return translator.text('required_field');
                      }
                      return null;
                    },
                    onTap: () => _openProvincesModal(
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

  void _openProvincesModal(
      BuildContext ctx, String locale, List<Province> provinces) async {
    final result = await showDialog<Province>(
      context: ctx,
      builder: (BuildContext context) => SimpleDialog(
        title: Text(this.widget.title),
        children: provinces
            .map((e) => _createSimpleDialogOption(context, locale, e))
            .toList(),
      ),
    );
    if (result == null) {
      Toast.show('Something went wrong!', ctx);
      return;
    }
    this.widget.onSave(result.id);
    this.controller.text = result.getName(locale);
  }

  Widget _createSimpleDialogOption(
      BuildContext context, String locale, Province e) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context, e);
      },
      child: Text(
        e.getName(locale),
      ),
    );
  }
}
