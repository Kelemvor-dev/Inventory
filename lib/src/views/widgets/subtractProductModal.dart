import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inventory/src/views/components/rounded_input.dart';
import 'package:inventory/src/views/components/textDecoration.dart';

import '../../../constants.dart';
import '../../controllers/productController.dart';

class SubtractProductModal extends StatefulWidget {
  final String? productID;
  final String? nameProduct;
  final double total;
  final String type;

  const SubtractProductModal({Key? key, required this.productID, required this.nameProduct, required this.total, required this.type})
      : super(key: key);

  @override
  State<SubtractProductModal> createState() => _SubtractProductModalState();
}

class _SubtractProductModalState extends State<SubtractProductModal> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController _subtractController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400,
        color: kPrimaryColor,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 10,
              ),
              TextCustomDecoration(
                text: "¿Cuánto desea restar al producto ${widget.nameProduct} ?",
                color: UiColors.white,
                size: 25,
                align: TextAlign.center,
                isOverflow: false,
              ),
              const SizedBox(height: 20),
              const TextCustomDecoration(
                text: "La disponibilidad del producto es de:",
                color: UiColors.white,
                size: 16,
                isOverflow: false,
                align: TextAlign.left,
              ),
              const SizedBox(height: 10),
              TextCustomDecoration(
                text: '${widget.total} ${widget.type}',
                color: UiColors.white,
                size: 30,
                isOverflow: false,
                align: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 150,
                child: RoundedInput(
                  icon: FontAwesomeIcons.minus,
                  hint: "0",
                  color: kPrimaryColor,
                  bgcolor: UiColors.white,
                  isEmail: false,
                  isNumber: true,
                  isreadOnly: false,
                  controller: _subtractController,
                ),
              ),
              const SizedBox(height: 60),
              InkWell(
                onTap: () {
                  ProductController().saveSubtractProduct(
                    productID: widget.productID,
                    nameProduct: widget.nameProduct,
                    total: widget.total,
                    type: widget.type,
                    subtract: _subtractController,
                    userID: userId,
                    context: context,
                  );
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: UiColors.white),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  child: const Text(
                    "Guardar",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
