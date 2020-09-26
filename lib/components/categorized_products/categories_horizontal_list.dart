import 'package:drugStore/models/pagination.dart';
import 'package:drugStore/utils/state.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CategoriesHorizontalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<StateModel>(context);
    final theme = Theme.of(context);

    assert(model != null);
    assert(model.categories != null);

    final obj = model.categories;

    switch (obj.status) {
      case PaginationStatus.Null:
        obj.fetch(context);
        return Center(child: CircularProgressIndicator());
      case PaginationStatus.Loading:
        return Center(child: CircularProgressIndicator());
      case PaginationStatus.Ready:
        return ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: obj.data.length + 1,
          separatorBuilder: (BuildContext context, int index) =>
              SizedBox(width: 6),
          itemBuilder: (BuildContext context, int index) => index == 0
              ? FlatButton(
                  textColor: theme.accentColor,
                  child: Text('All'),
                  onPressed: () => obj.noSelect())
              : FlatButton(
                  textColor: theme.accentColor,
                  child: Text(obj.data[index].getName(context)),
                  onPressed: () => obj.select(obj.data[index])),
        );
    }
    return null;
  }
}
