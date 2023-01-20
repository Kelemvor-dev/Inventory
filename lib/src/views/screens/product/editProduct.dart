import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inventory/src/controllers/productController.dart';
import 'package:inventory/src/models/repository/products.dart';

import '../../../../constants.dart';
import '../../components/navbar/popNavbar.dart';
import '../../components/rounded_input.dart';
import '../../components/textDecoration.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductState();
}

class _EditProductState extends State<EditProductScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

  // Initial Selected Value
  String dropdownvalue = 'UND';

  var _stream;

  // List of items in our dropdown menu
  var items = [
    'UND',
    'KG',
    'PORC',
    'LT',
    'GRS',
  ];

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)?.settings.arguments as Map;
    return StreamBuilder(
        stream: Products().getProductByID(args['productID']),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _titleController.text = snapshot.data?.docs.first['title'] ?? '';
            dropdownvalue = snapshot.data?.docs.first['type'] ?? '';
            var total = snapshot.data?.docs.first['total'] ?? '';
            _totalController.text = total.toString();
            return Scaffold(
              appBar: const PopNavbar(
                title: "Editar Producto",
                transparent: false,
                bgColor: kPrimaryColor,
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    children: [
                      const TextCustomDecoration(
                        text: "Nombre del producto",
                        color: kPrimaryColor,
                        size: 16,
                        align: TextAlign.center,
                        isOverflow: false,
                      ),
                      RoundedInput(
                        icon: FontAwesomeIcons.bowlRice,
                        hint: "",
                        color: UiColors.white,
                        bgcolor: kPrimaryColor,
                        isEmail: false,
                        isNumber: false,
                        controller: _titleController,
                        isreadOnly: false,
                      ),
                      const SizedBox(height: 10),
                      const TextCustomDecoration(
                        text: "Tipo de producto",
                        color: kPrimaryColor,
                        size: 16,
                        align: TextAlign.center,
                        isOverflow: false,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.circular(10)),
                        child: DropdownButton(
                          alignment: AlignmentDirectional.center,
                          isExpanded: true,
                          dropdownColor: kPrimaryColor,
                          // Initial Value
                          value: dropdownvalue,

                          // Down Arrow Icon
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: UiColors.white,
                          ),
                          iconSize: 42,
                          underline: const SizedBox(),
                          // Array list of items
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Container(
                                margin: const EdgeInsets.only(left: 110),
                                child: TextCustomDecoration(
                                  text: items,
                                  color: UiColors.white,
                                  size: 16,
                                  align: TextAlign.center,
                                  isOverflow: false,
                                ),
                              ),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const TextCustomDecoration(
                        text: "Cantidad total",
                        color: kPrimaryColor,
                        size: 16,
                        align: TextAlign.center,
                        isOverflow: false,
                      ),
                      RoundedInput(
                        icon: FontAwesomeIcons.calculator,
                        hint: "",
                        color: UiColors.white,
                        bgcolor: kPrimaryColor,
                        isEmail: false,
                        isNumber: true,
                        controller: _totalController,
                        isreadOnly: false,
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          ProductController().editProduct(context, _titleController, dropdownvalue, _totalController, userId, args['productID']);
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: kPrimaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          child: const Text(
                            "Guardar",
                            style: TextStyle(
                              color: UiColors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            const Text('No data avaible right now');
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
