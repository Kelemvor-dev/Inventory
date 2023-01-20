import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryProductsModel {
  final String? id;
  final String? productID;
  final String? nameProduct;
  final double? type;
  final List? subtract;
  final double? total;
  final String? userID;
  final String? create_at;
  final Timestamp? date;


  InventoryProductsModel({
    this.id,
    this.productID,
    this.nameProduct,
    this.type,
    this.subtract,
    this.total,
    this.userID,
    this.create_at,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'productID':productID,'nameProduct':nameProduct,'type':type,'subtract':subtract,'total':total,'userID':userID,'create_at':create_at, 'timestamp': date};
  }

  InventoryProductsModel.fromFirestore(Map<String, dynamic>? firestore)
      : id = firestore!['id'],
        productID = firestore!['productID'],
        nameProduct = firestore!['nameProduct'],
        type = firestore!['type'],
        subtract = firestore!['subtract'],
        total = firestore!['total'],
        userID = firestore!['userID'],
        create_at = firestore!['create_at'],
        date = firestore!['timestamp'];
}
