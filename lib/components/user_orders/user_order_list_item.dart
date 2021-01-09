import 'package:drugStore/localization/app_translation.dart';
import 'package:drugStore/models/order/order.dart';
import 'package:drugStore/partials/app_router.dart';
import 'package:flutter/material.dart';

enum OrderStatusTitle { Pending, Accepted, Rejected, Shipping, Delivered }

class UserOrderListItem extends StatelessWidget {
  static final List<Icon> _icons = [
    Icon(Icons.error_outline, size: 40.0, color: Colors.grey),
    Icon(Icons.check_circle, size: 40.0, color: Colors.lightGreen),
    Icon(Icons.remove_circle_outline, size: 40.0, color: Colors.redAccent),
    Icon(Icons.local_shipping, size: 40.0, color: Colors.deepOrange),
    Icon(Icons.archive, size: 40.0, color: Colors.indigoAccent),
  ];

  final Order order;

  UserOrderListItem({@required this.order});

  @override
  Widget build(BuildContext context) {
    final translator = AppTranslations.of(context);
    final theme = Theme.of(context);

    final lang = translator.locale.languageCode;

    return Directionality(
        textDirection: lang == 'en' ? TextDirection.ltr : TextDirection.rtl,
        child: GestureDetector(
          child: Card(
            color: theme.primaryColor,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 2.0),
                  leading: _icons[order.status.title.index],
                  title: new Text(
                    order.client.name,
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(order.client.phone),
                      new Row(
                        children: [
                          Text(
                              "${order.client.province.getName(lang)}, ${order.client.address}"),
                        ],
                      )
                    ],
                  ),
                ),
                new ButtonBar(
                  children: <Widget>[
                    new Chip(
                      label: Text(
                        "${order.status.name}, Since ${order.status.changeDate}",
                        style: theme.textTheme.caption,
                      ),
                    ),
                    new Chip(
                      label: Text(
                        "${order.products.length} Products",
                        style: theme.textTheme.caption
                            .copyWith(color: theme.primaryColor),
                      ),
                      backgroundColor: theme.accentColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            _gotoOrderDetails(context);
          },
        ));
  }

  void _gotoOrderDetails(BuildContext context) {
    Navigator.of(context)
        .pushNamed(AppRouter.userOrderDetails, arguments: this.order);
  }
}
