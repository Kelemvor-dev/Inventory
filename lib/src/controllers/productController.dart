import 'package:flutter/material.dart';
import 'package:inventory/src/models/entity/inventoryProducts.dart';
import 'package:inventory/utils/alerts.dart';
import 'package:provider/provider.dart';

import '../models/repository/products.dart';

class ProductController {
  DateTime date = DateTime.now();

  saveProduct(BuildContext context, title, type, total, userId) async {
    if (title.text != '' && total.text != '') {
      var cantotal = double.parse(total.text);
      context.read<Products>().saveProduct(
            title: title.text,
            type: type,
            total: cantotal,
            userID: userId,
            context: context,
          );
    } else {
      Alert.alertAuth(context, "Alguno de los campos esta vacio.");
    }
  }

  void editProduct(BuildContext context, title, type, total, userId, idProduct) async {
    if (title.text != '' && total.text != '') {
      var cantotal = double.parse(total.text);
      context.read<Products>().editProduct(title: title.text, type: type, total: cantotal, userID: userId, context: context, productID: idProduct);
    } else {
      Alert.alertAuth(context, "Alguno de los campos esta vacio.");
    }
  }

  saveLabelProduct(BuildContext context, description, date, productID, userID, nameProduct) async {
    if (description.text != '' && date.text != '') {
      context.read<Products>().saveLabelProduct(
            nameProduct: nameProduct,
            description: description.text,
            date: date.text,
            productID: productID,
            userID: userID,
            context: context,
          );
      Navigator.pop(context);
    } else {
      Alert.alertAuth(context, "Alguno de los campos esta vacio.");
    }
  }

  deleteLabel(BuildContext context, id) {
    Alert.confirmDeletelabel(context, "Seguro que desea elminar este rotulo?", id, context);
  }

  confirmDeleteLabel(BuildContext context, id) async {
    context.read<Products>().deleteLabelProduct(
          id: id,
          context: context,
        );
  }

  saveSubtractProduct({
    required productID,
    required nameProduct,
    required total,
    required type,
    required subtract,
    required userID,
    required BuildContext context,
  }) async {
    String day;
    if (date.day < 10) {
      day = "0${date.day}";
    } else {
      day = "${date.day}";
    }
    var dateNow = "${date.year}-${date.month}-$day";
    var subtractD = double.parse(subtract.text);
    if (subtractD > total || subtractD <= 0) {
      Alert.alertAuth(context, "La cantidad no puede ser menor o superior a la cantidad disponible");
    } else {
      var products = await Products().getInventoryProductByID(productID);

      if(products['productID'] != null){
        context.read<Products>().updateSubtractProduct(
          productID: productID,
          total: products['total'],
          listSubtract: products['subtract'],
          subtract:subtractD,
          context: context,
        );
      }else{
        context.read<Products>().saveSubtractProduct(
          productID: productID,
          nameProduct: nameProduct,
          total: total,
          type: type,
          subtract: subtractD,
          userID: userID,
          datesubtractNow: dateNow,
          context: context,
        );
      }
      Navigator.pop(context);
      Alert.alertSucess(context, "Cantidades reducidas con éxito");
    }
  }
}
