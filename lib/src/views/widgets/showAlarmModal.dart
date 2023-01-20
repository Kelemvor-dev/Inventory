import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory/constants.dart';
import 'package:inventory/src/models/repository/products.dart';
import 'package:inventory/src/views/components/textDecoration.dart';

class ShowAlarmModal extends StatefulWidget {
  const ShowAlarmModal({
    Key? key,
  }) : super(key: key);

  @override
  State<ShowAlarmModal> createState() => _ShowAlarmModalState();
}

class _ShowAlarmModalState extends State<ShowAlarmModal> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 400,
      color: kPrimaryColor,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: const TextCustomDecoration(
              text: 'Próximos Productos a Vencer',
              color: UiColors.white,
              size: 20,
              align: TextAlign.center,
              isOverflow: false,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            height: 60,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: const TextCustomDecoration(
                    text: 'Producto',
                    color: UiColors.white,
                    size: 12,
                    align: TextAlign.center,
                    isOverflow: false,
                  ),
                ),
                Container(
                  width: 170,
                  margin: const EdgeInsets.only(right: 5),
                  child: const TextCustomDecoration(
                    text: 'Descripción',
                    color: UiColors.white,
                    size: 12,
                    align: TextAlign.center,
                    isOverflow: false,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: const TextCustomDecoration(
                    text: 'Fecha',
                    color: UiColors.white,
                    size: 12,
                    align: TextAlign.center,
                    isOverflow: false,
                  ),
                )
              ],
            ),
          ),
          StreamBuilder(
              stream: Products().getLabelProductByUserID(userId),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return (snapshot.data?.docs != null)
                      ? SizedBox(
                    height: 270,
                    child: SingleChildScrollView(
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(5.5),
                          itemCount: snapshot.data?.docs.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var date = DateTime.parse(snapshot.data?.docs[index]['date']);
                            var weak = DateTime.now().add(const Duration(days: 6));
                            if (date.isBefore(weak)) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 2),
                                padding: const EdgeInsets.all(20),
                                color: UiColors.white,
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      width: 70,
                                      height: 40,
                                      child: TextCustomDecoration(
                                        text: snapshot.data?.docs[index]['nameProduct'],
                                        color: kPrimaryColor,
                                        size: 12,
                                        align: TextAlign.center,
                                        isOverflow: false,
                                      ),
                                    ),
                                    Container(
                                      width: 124,
                                      margin: const EdgeInsets.only(right: 5),
                                      child: TextCustomDecoration(
                                        text: snapshot.data?.docs[index]['description'],
                                        color: kPrimaryColor,
                                        size: 12,
                                        align: TextAlign.center,
                                        isOverflow: false,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      width: 60,
                                      child: TextCustomDecoration(
                                        text: "${snapshot.data?.docs[index]['date']}",
                                        color: kPrimaryColor,
                                        size: 11,
                                        align: TextAlign.center,
                                        isOverflow: false,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                            return const Text('');
                          }),
                    ),
                  )
                      : const Center(child: CircularProgressIndicator());
                }
                return const Center(child: CircularProgressIndicator());
              })
        ],
      ),
    );
  }
}
