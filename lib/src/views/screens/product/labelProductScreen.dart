import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inventory/src/controllers/productController.dart';
import 'package:inventory/src/models/repository/products.dart';
import 'package:inventory/src/views/components/textDecoration.dart';

import '../../../../constants.dart';
import '../../components/navbar/popNavbar.dart';
import '../../widgets/crateLabelModal.dart';

class LabelProductScreen extends StatefulWidget {
  const LabelProductScreen({super.key});

  @override
  State<LabelProductScreen> createState() => _LabelProductState();
}

class _LabelProductState extends State<LabelProductScreen> {
  _buildLabelModal(String productID, String nameProduct) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return CreateLabelModal(
            productID: productID,
            nameProduct: nameProduct,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)?.settings.arguments as Map;
    return Scaffold(
        appBar: PopNavbar(
          title: "Rotulos de ${args['title']}",
          transparent: false,
          bgColor: kPrimaryColor,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          onPressed: () {
            _buildLabelModal(args['productID'],args['title']);
          },
          child: const FaIcon(
            color: UiColors.white,
            FontAwesomeIcons.circlePlus,
            size: 40,
          ),
        ),
        body: StreamBuilder(
            stream: Products().getLabelProductByID(args['productID']),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const TextCustomDecoration(
                        text: "Productos Vencidos",
                        color: kPrimaryColor,
                        size: 20,
                        align: TextAlign.center,
                        isOverflow: false,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 275,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            (snapshot.data?.docs != null)
                                ? ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(5.5),
                                itemCount: snapshot.data?.docs.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var date = DateTime.parse(snapshot.data?.docs[index]['date']);
                                  if (date.isBefore(DateTime.now())) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          Row(children: [
                                            Container(
                                              width: 100.0,
                                              height: 100.0,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: kBackgroundColor,
                                              ),
                                              child: Container(
                                                padding: const EdgeInsets.all(15),
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                decoration: const BoxDecoration(shape: BoxShape.circle),
                                                child: Column(
                                                  children: [
                                                    const Icon(
                                                      FontAwesomeIcons.calendar,
                                                      color: UiColors.white,
                                                      size: 30,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    TextCustomDecoration(
                                                      text: snapshot.data?.docs[index]['date'],
                                                      color: UiColors.white,
                                                      size: 13,
                                                      align: TextAlign.center,
                                                      isOverflow: false,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                                width: 175,
                                                height: 100.0,
                                                margin: const EdgeInsets.only(left: 10, right: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: UiColors.input,
                                                ),
                                                child: Container(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child: Column(
                                                    children: [
                                                      TextCustomDecoration(
                                                        text: snapshot.data?.docs[index]['description'],
                                                        color: kPrimaryColor,
                                                        size: 15,
                                                        align: TextAlign.center,
                                                        isOverflow: false,
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                            InkWell(
                                                onTap: () {
                                                  ProductController().deleteLabel(context, snapshot.data?.docs[index]['id']);
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(left: 5),
                                                  child: const Icon(
                                                    FontAwesomeIcons.trash,
                                                    color: UiColors.error,
                                                  ),
                                                ))
                                          ])
                                        ],
                                      ),
                                    );
                                  }
                                  return const Text('');
                                })
                                : const Center(child: CircularProgressIndicator()),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const TextCustomDecoration(
                        text: "Productos No Vencidos",
                        color: kPrimaryColor,
                        size: 20,
                        align: TextAlign.center,
                        isOverflow: false,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 275,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            (snapshot.data?.docs != null)
                                ? ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(5.5),
                                itemCount: snapshot.data?.docs.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var date = DateTime.parse(snapshot.data?.docs[index]['date']);
                                  if (date.isAfter(DateTime.now())) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          Row(children: [
                                            Container(
                                              width: 100.0,
                                              height: 100.0,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: kBackgroundColor,
                                              ),
                                              child: Container(
                                                padding: const EdgeInsets.all(15),
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                decoration: const BoxDecoration(shape: BoxShape.circle),
                                                child: Column(
                                                  children: [
                                                    const Icon(
                                                      FontAwesomeIcons.calendar,
                                                      color: UiColors.white,
                                                      size: 30,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    TextCustomDecoration(
                                                      text: snapshot.data?.docs[index]['date'],
                                                      color: UiColors.white,
                                                      size: 13,
                                                      align: TextAlign.center,
                                                      isOverflow: false,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                                width: 170,
                                                height: 100.0,
                                                margin: const EdgeInsets.only(left: 10, right: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: UiColors.input,
                                                ),
                                                child: Container(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child: Column(
                                                    children: [
                                                      TextCustomDecoration(
                                                        text: snapshot.data?.docs[index]['description'],
                                                        color: kPrimaryColor,
                                                        size: 15,
                                                        align: TextAlign.center,
                                                        isOverflow: false,
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                            InkWell(
                                                onTap: () {
                                                  ProductController().deleteLabel(context, snapshot.data?.docs[index]['id']);
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(left: 5),
                                                  child: const Icon(
                                                    FontAwesomeIcons.trash,
                                                    color: UiColors.error,
                                                  ),
                                                ))
                                          ])
                                        ],
                                      ),
                                    );
                                  }
                                  return const Text('');
                                })
                                : const Center(child: CircularProgressIndicator()),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
