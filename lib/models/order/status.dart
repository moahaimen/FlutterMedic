enum OrderStatusTitle { Pending, Accepted, Rejected, Shipping, Delivered }

class OrderStatus {
  static List<OrderStatus> toList(List statuses) {
    return statuses.map<OrderStatus>((e) => new OrderStatus.json(e)).toList();
  }

  final OrderStatusTitle title;
  final DateTime changedAt;

  OrderStatus(this.title, this.changedAt);

  OrderStatus.json(dynamic data)
      : this(OrderStatusTitle.values[data['title']],
            DateTime.parse(data['changed_at']));

  String get name => this.title.toString().split('.')[1];

  String get changeDate =>
      "${changedAt.year}-${changedAt.month}-${changedAt.day}";
}
