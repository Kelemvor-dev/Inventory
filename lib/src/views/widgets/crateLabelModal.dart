import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inventory/src/views/components/rounded_input.dart';
import 'package:inventory/src/views/components/rounded_textarea.dart';
import 'package:inventory/src/views/components/textDecoration.dart';

import '../../../constants.dart';
import '../../controllers/productController.dart';

class CreateLabelModal extends StatefulWidget {
  final String? productID;
  final String? nameProduct;

  const CreateLabelModal({
    Key? key,
    required this.productID,
    required this.nameProduct,
  }) : super(key: key);

  @override
  State<CreateLabelModal> createState() => _CreateLabelModalState();
}

class _CreateLabelModalState extends State<CreateLabelModal> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime date = DateTime.now();

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
              const TextCustomDecoration(
                text: "Crear Nuevo Rotulo",
                color: UiColors.white,
                size: 20,
                align: TextAlign.center,
                isOverflow: false,
              ),
              RoundedTextarea(
                icon: FontAwesomeIcons.book,
                hint: "Descripción",
                color: kPrimaryColor,
                bgcolor: UiColors.white,
                controller: _descriptionController,
              ),
              Row(
                children: [
                  Container(
                    width: 250,
                    margin: const EdgeInsets.only(left: 40),
                    child: RoundedInput(
                      icon: FontAwesomeIcons.arrowRightToCity,
                      hint: "Fecha de vencimiento",
                      color: kPrimaryColor,
                      bgcolor: UiColors.white,
                      isEmail: false,
                      isNumber: false,
                      controller: _dateController,
                      isreadOnly: true,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: InkWell(
                      onTap: () async {
                        DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (newDate == null) return;
                        setState(() {
                          date = newDate;
                        });
                        String day;
                        if (date.day < 10) {
                          day = "0${date.day}";
                        } else {
                          day = "${date.day}";
                        }
                        _dateController.text = "${date.year}-${date.month}-$day";
                      },
                      child: const CircleAvatar(
                          child: Icon(
                        FontAwesomeIcons.calendar,
                        color: kPrimaryColor,
                      )),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  ProductController().saveLabelProduct(context, _descriptionController, _dateController, widget.productID, userId,widget.nameProduct);
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
