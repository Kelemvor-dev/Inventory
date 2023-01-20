import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsModel {
  final String? id;
  final String? title;
  final String? type;
  final double? total;
  final String? userID;
  final Timestamp? date;

  ProductsModel({
    this.id,
    this.title,
    this.type,
    this.total,
    this.userID,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'type': type,'total': total,'userID': userID, 'timestamp': date};
  }

  ProductsModel.fromFirestore(Map<String, dynamic>? firestore)
      : id = firestore!['id'],
        title = firestore!['title'],
        type = firestore!['type'],
        total = firestore!['total'],
        userID = firestore!['userID'],
        date = firestore!['timestamp'];
}
