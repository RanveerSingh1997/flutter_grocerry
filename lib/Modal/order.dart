class Order {
  static const int DEPARTURED = 0;
  static const int BOOKED = 1;
  static const int DELIVERED = 2;
  static const int CANCELED = 3;

  int totalPrice;
  String customerName;
  String customerId;
  String productId;
  String address;
  int status;
  DateTime orderDate;
  DateTime cancelDate;
  DateTime deliverDate;
  List products;

  Order(
      {this.address,
      this.totalPrice,
      this.customerName,
      this.customerId,
      this.productId,
      this.status,
      this.cancelDate,
      this.deliverDate,
      this.orderDate,
      this.products});

  static Order fromMap(Map<String, dynamic> data) {
    return Order(
        customerName: data['customerName'],
        totalPrice: data['totalPrice'],
        address: data['address'],
        customerId: data['customerId'],
        productId: data['productId'],
        status: data['status'],
        cancelDate: data['cancelDate'],
        deliverDate: data['deliverDate'],
        orderDate: DateTime.fromMillisecondsSinceEpoch(
            data['orderDate'].millisecondsSinceEpoch),
        products: data['products']);
  }

  static Map<String, dynamic> fromOrder(Order order) {
    return {
      'customerName': order.customerName,
      'totalPrice': order.totalPrice,
      'customerId': order.customerId,
      'productId': order.productId,
      'status': order.status,
      'address': order.address,
      'cancelDate': order.cancelDate,
      'deliverDate': order.deliverDate,
      'orderDate': order.orderDate,
      'products': order.products
    };
  }
}
