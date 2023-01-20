import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../entity/inventoryProducts.dart';
import '../entity/products.dart';

class Products {
  final productRef = FirebaseFirestore.instance.collection('products');
  final inventoryRef = FirebaseFirestore.instance.collection('inventory');
  final productInventoryRef = FirebaseFirestore.instance.collection('inventory_products');
  final labelProductRef = FirebaseFirestore.instance.collection('labels_products');
  final DateTime dateNow = DateTime.now();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> saveProduct({
    required String? title,
    required String? type,
    required double? total,
    required String? userID,
    required BuildContext context,
  }) async {
    String uniqueDocId = DateTime.now().millisecondsSinceEpoch.toString();
    productRef.doc(uniqueDocId).set({
      'id': uniqueDocId,
      'title': title,
      'type': type,
      'total': total,
      'userID': userID,
      'timestamp': dateNow,
    });
  }

  Future<void> editProduct({
    required String? title,
    required String? type,
    required double? total,
    required String? userID,
    required String productID,
    required BuildContext context,
  }) async {
    productRef.doc(productID).update({
      'title': title,
      'type': type,
      'total': total,
      'userID': userID,
      'timestamp': dateNow,
    });
  }

  Stream<List<ProductsModel>> getProductsByUserID() {
    var list = _db
        .collection('products')
        .where("userID", isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => ProductsModel.fromFirestore(document.data())).toList());
    return list;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProductByID(productID) {
    return _db.collection('products').where("id", isEqualTo: productID).snapshots();
  }

  getInventoryProductByID(productID) async {
    QuerySnapshot querySnapshot = await _db.collection('inventory_products').where("productID", isEqualTo: productID).get();

    Map result = {};
    for (var doc in querySnapshot.docs) {
      result['id'] = doc["id"];
      result['productID'] = doc["productID"];
      result['type'] = doc["type"];
      result['subtract'] = doc["subtract"];
      result['total'] = doc["total"];
      result['userID'] = doc["userID"];
      result['create_at'] = doc["create_at"];
      result['timestamp'] = doc["timestamp"];
    }
    return result;
  }

  Future<void> saveLabelProduct({
    required nameProduct,
    required description,
    required date,
    required productID,
    required userID,
    required BuildContext context,
  }) async {
    String uniqueDocId = DateTime.now().millisecondsSinceEpoch.toString();
    labelProductRef.doc(uniqueDocId).set({
      'id': uniqueDocId,
      'nameProduct': nameProduct,
      'description': description,
      'date': date,
      'productID': productID,
      'userID': userID,
      'timestamp': dateNow,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLabelProductByID(productID) {
    var list = _db.collection('labels_products').where("productID", isEqualTo: productID).orderBy("date").snapshots();
    return list;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLabelProductByUserID(userID) {
    var list = _db.collection('labels_products').where("userID", isEqualTo: userID).orderBy("date").snapshots();
    return list;
  }

  Future<void> deleteLabelProduct({
    required id,
    required BuildContext context,
  }) async {
    labelProductRef.doc(id).delete();
  }

  Future<void> saveSubtractProduct({
    required String productID,
    required String nameProduct,
    required double total,
    required String type,
    required double subtract,
    required String userID,
    required String datesubtractNow,
    required BuildContext context,
  }) async {
    List res = [];

    res.add(subtract);

    inventoryRef.doc(datesubtractNow).set({'create_at': datesubtractNow});

    productInventoryRef.doc(productID).set({
      'id': productID,
      'productID': productID,
      'nameProduct': nameProduct,
      'type': type,
      'subtract': res,
      'later_total': total,
      'total': total - subtract,
      'userID': userID,
      'create_at': datesubtractNow,
      'timestamp': dateNow,
    });
    productRef.doc(productID).update({
      'total': total - subtract,
      'timestamp': dateNow,
    });
  }
  Future<void> updateSubtractProduct({
    required String productID,
    required double total,
    required List listSubtract,
    required double subtract,
    required BuildContext context,
  }) async {
    listSubtract.add(subtract);
    productInventoryRef.doc(productID).update({
      'subtract': listSubtract,
      'total': total - subtract,
      'timestamp': dateNow,
    });
    productRef.doc(productID).update({
      'total': total - subtract,
      'timestamp': dateNow,
    });
  }
}
