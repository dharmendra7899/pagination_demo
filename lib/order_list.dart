// To parse this JSON data, do
//
//     final orderListModal = orderListModalFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

OrderListModal orderListModalFromJson(String str) => OrderListModal.fromJson(json.decode(str));

String orderListModalToJson(OrderListModal data) => json.encode(data.toJson());

class OrderListModal {
  OrderListModal({
    required this.count,
    required this.currentPage,
    required this.data,
    required this.perPage,
    required this.totalPages,
    required this.totalRecords,
  });

  int count;
  int currentPage;
  List<Datum> data;
  int perPage;
  int totalPages;
  int totalRecords;

  factory OrderListModal.fromJson(Map<String, dynamic> json) => OrderListModal(
    count: json["count"],
    currentPage: json["current_page"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    perPage: json["per_page"],
    totalPages: json["total_pages"],
    totalRecords: json["total_records"],
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "per_page": perPage,
    "total_pages": totalPages,
    "total_records": totalRecords,
  };
}

class Datum {
  Datum({
    required this.bondExchange,
    required this.bondId,
    required this.bondIsinNumber,
    required this.bondLogo,
    required this.bondName,
    required this.bondsPricePerGram,
    required this.bondsYeild,
    required this.isCancellable,
    required this.isModifiable,
    required this.orderAmount,
    required this.orderDatetime,
    required this.orderId,
    required this.orderNumber,
    required this.orderOrderId,
    required this.orderPaymentStatus,
    required this.orderPdf,
    required this.orderQuantity,
    required this.orderStatus,
    required this.orderType,
    required this.specificOrderId,
  });

  String? bondExchange;
  int? bondId;
  String? bondIsinNumber;
  String? bondLogo;
  String? bondName;
  String? bondsPricePerGram;
  String? bondsYeild;
  int? isCancellable;
  int? isModifiable;
  String? orderAmount;
  String? orderDatetime;
  int? orderId;
  String? orderNumber;
  int? orderOrderId;
  int? orderPaymentStatus;
  String? orderPdf;
  int? orderQuantity;
  int? orderStatus;
  int? orderType;
  int? specificOrderId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    bondExchange: json["bond_exchange"],
    bondId: json["bond_id"],
    bondIsinNumber: json["bond_isin_number"],
    bondLogo: json["bond_logo"],
    bondName: json["bond_name"],
    bondsPricePerGram: json["bonds_price_per_gram"],
    bondsYeild: json["bonds_yeild"],
    isCancellable: json["is_cancellable"],
    isModifiable: json["is_modifiable"],
    orderAmount: json["order_amount"],
    orderDatetime: json["order_datetime"],
    orderId: json["order_id"],
    orderNumber: json["order_number"],
    orderOrderId: json["order_order_id"],
    orderPaymentStatus: json["order_payment_status"],
    orderPdf: json["order_pdf"],
    orderQuantity: json["order_quantity"],
    orderStatus: json["order_status"],
    orderType: json["order_type"],
    specificOrderId: json["specific_order_id"],
  );

  Map<String, dynamic> toJson() => {
    "bond_exchange": bondExchange,
    "bond_id": bondId,
    "bond_isin_number": bondIsinNumber,
    "bond_logo": bondLogo,
    "bond_name": bondName,
    "bonds_price_per_gram": bondsPricePerGram,
    "bonds_yeild": bondsYeild,
    "is_cancellable": isCancellable,
    "is_modifiable": isModifiable,
    "order_amount": orderAmount,
    "order_datetime": orderDatetime,
    "order_id": orderId,
    "order_number": orderNumber,
    "order_order_id": orderOrderId,
    "order_payment_status": orderPaymentStatus,
    "order_pdf": orderPdf,
    "order_quantity": orderQuantity,
    "order_status": orderStatus,
    "order_type": orderType,
    "specific_order_id": specificOrderId,
  };
}
