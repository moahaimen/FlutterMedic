import 'package:drugStore/models/pagination.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CategoriesHorizontalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<StateModel>(
      builder: (context, child, model) {
        final theme = Theme.of(context);

        switch (model.categories.status) {
          case PaginationStatus.Ready:
            return ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: model.categories.data.length + 1,
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(width: 6),
              itemBuilder: (BuildContext context, int index) => index == 0
                  ? FlatButton(
                      textColor: theme.accentColor,
                      child: Text('All'),
                      onPressed: () => model.categories.noSelect())
                  : FlatButton(
                      textColor: theme.accentColor,
                      child:
                          Text(model.categories.data[index].getName(context)),
                      onPressed: () => model.categories
                          .select(model.categories.data[index])),
            );
          default:
            throw new Exception('Categories model is null at the moment');
        }
      },
    );
  }
}
