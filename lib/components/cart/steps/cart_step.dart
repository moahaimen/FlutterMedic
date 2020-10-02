import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/order_management.dart';
import 'package:flutter/material.dart';

enum CartStepId { Products, Client, PromoCode }

abstract class CartStep extends StatelessWidget {
  ///
  ///
  ///
  final OrderManagement manager;

  ///
  /// Unique number for each step
  ///
  final CartStepId id;

  ///
  /// Title
  ///
  final String title;

  ///
  /// Child
  ///
  final Widget child;

  ///
  /// Get icon for current state of the step
  ///
  IconData getState();

  ///
  /// Save the step data into the source
  ///
  void save();

  ///
  /// Check if the step is finished and We can move to the next
  ///
  bool finished();

  CartStep({
    @required this.manager,
    @required this.id,
    @required this.title,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    assert(title != null);
    assert(child != null);

    final theme = Theme.of(context);
    final translator = AppTranslations.of(context);

    return Column(
      children: [
        Text(
          translator.text(this.title),
          style: theme.textTheme.headline3
              .copyWith(color: theme.accentColor.withOpacity(.65)),
          textAlign: TextAlign.center,
        ),
        child,
      ],
    );
  }
}
