import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory/src/models/entity/products.dart';
import 'package:inventory/src/views/widgets/showAlarmModal.dart';
import 'package:provider/provider.dart';

import '../../../../constants.dart';
import '../../components/input_container.dart';
import '../../widgets/subtractProductModal.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> with SingleTickerProviderStateMixin {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  List<ProductsModel>? searchList;

  @override
  void dispose() {
    _textFocusNode.dispose();
    _searchController!.dispose();
    super.dispose();
  }

  _buildAlarmModal() {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return const ShowAlarmModal();
        });
  }

  _buildSubtractProductModal(context, productID, nameProduct, total, type) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SubtractProductModal(
            productID: productID,
            nameProduct: nameProduct,
            total: total,
            type: type,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<ProductsModel>>(context);

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          onPressed: () {
            Navigator.pushNamed(context, 'createProduct');
          },
          child: const FaIcon(
            color: UiColors.white,
            FontAwesomeIcons.circlePlus,
            size: 40,
          ),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 70,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: InputContainer(
                      bgColor: kPrimaryColor,
                      child: TextField(
                          onChanged: (text) {
                            setState(() {
                              searchList = products.where((element) => element.title!.toLowerCase().contains(text.toLowerCase())).toList();
                            });
                          },
                          style: const TextStyle(color: UiColors.white),
                          controller: _searchController,
                          focusNode: _textFocusNode,
                          cursorColor: UiColors.white,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.search, color: UiColors.white),
                            hintText: 'Buscar',
                            hintStyle: TextStyle(color: UiColors.white),
                            border: InputBorder.none,
                          )),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: InkWell(
                      onTap: () {
                        _buildAlarmModal();
                      },
                      child: const Icon(
                        FontAwesomeIcons.solidBell,
                        color: UiColors.error,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 80),
                child: _searchController!.text.isNotEmpty && searchList!.isNotEmpty
                    ? GridView.count(
                        crossAxisCount: 2,
                        children: List.generate(searchList!.length, (index) {
                          return Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                height: 165,
                                width: 165,
                                color: kBackgroundColor,
                                margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(4, 60, 10, 5),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${searchList![index].title}',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                            textStyle: Theme.of(context).textTheme.headline4,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: UiColors.white),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context, 'editProduct', arguments: {'productID': products![index].id});
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(left: 5),
                                              child: const CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 20,
                                                child: Icon(
                                                  FontAwesomeIcons.penToSquare,
                                                  color: kPrimaryColor,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context, 'labelProduct', arguments: {
                                                'productID': products![index].id,
                                                'title': products![index].title,
                                              });
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(left: 10),
                                              child: const CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 20,
                                                child: Icon(
                                                  FontAwesomeIcons.barcode,
                                                  color: kPrimaryColor,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _buildSubtractProductModal(context, products![index].id, products![index].title, products![index].total,
                                                  products![index].type);
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(left: 10),
                                              child: const CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 20,
                                                child: Icon(
                                                  FontAwesomeIcons.minus,
                                                  color: kPrimaryColor,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: -60,
                                  child: CircleAvatar(
                                    backgroundColor: UiColors.white,
                                    radius: 60,
                                    child: Container(
                                        margin: const EdgeInsets.only(top: 60),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${searchList![index].total}',
                                              style: GoogleFonts.montserrat(
                                                  textStyle: Theme.of(context).textTheme.headline4,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: kSecundaryColor),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              '${searchList![index].type}',
                                              style: GoogleFonts.montserrat(
                                                  textStyle: Theme.of(context).textTheme.headline4,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: kSecundaryColor),
                                            ),
                                          ],
                                        )),
                                  ))
                            ],
                          );
                        }),
                      )
                    : GridView.count(
                        crossAxisCount: 2,
                        children: List.generate(products!.length, (index) {
                          return Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                height: 165,
                                width: 165,
                                color: kBackgroundColor,
                                margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(4, 60, 10, 5),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${products![index].title}',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                            textStyle: Theme.of(context).textTheme.headline4,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: UiColors.white),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context, 'editProduct', arguments: {'productID': products![index].id});
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(left: 5),
                                              child: const CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 20,
                                                child: Icon(
                                                  FontAwesomeIcons.penToSquare,
                                                  color: kPrimaryColor,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context, 'labelProduct', arguments: {
                                                'productID': products![index].id,
                                                'title': products![index].title,
                                              });
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(left: 10),
                                              child: const CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 20,
                                                child: Icon(
                                                  FontAwesomeIcons.barcode,
                                                  color: kPrimaryColor,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _buildSubtractProductModal(context, products![index].id, products![index].title, products![index].total,
                                                  products![index].type);
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(left: 10),
                                              child: const CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 20,
                                                child: Icon(
                                                  FontAwesomeIcons.minus,
                                                  color: kPrimaryColor,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: -60,
                                  child: CircleAvatar(
                                    backgroundColor: UiColors.white,
                                    radius: 60,
                                    child: Container(
                                        margin: const EdgeInsets.only(top: 60),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${products![index].total}',
                                              style: GoogleFonts.montserrat(
                                                  textStyle: Theme.of(context).textTheme.headline4,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: kSecundaryColor),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              '${products![index].type}',
                                              style: GoogleFonts.montserrat(
                                                  textStyle: Theme.of(context).textTheme.headline4,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: kSecundaryColor),
                                            ),
                                          ],
                                        )),
                                  ))
                            ],
                          );
                        }),
                      )),
          ],
        ));
  }
}
