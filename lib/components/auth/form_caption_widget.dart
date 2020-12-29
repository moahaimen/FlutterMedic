import 'package:flutter/material.dart';

class FormCaptionWidget extends StatelessWidget {
  final String caption;
  final String assetName;
  final double targetWidth;

  FormCaptionWidget(
      {@required this.caption,
      @required this.assetName,
      @required this.targetWidth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(this.assetName,
            fit: BoxFit.scaleDown,
            repeat: ImageRepeat.noRepeat,
            width: targetWidth),
//        Text(
//          this.caption,
//          style: Theme.of(context).textTheme.headline1,
//        )
      ],
    );
  }
}
