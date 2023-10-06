import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eny/pages/home_page.dart';
import 'package:eny/widgets/app_text.dart';
import 'package:eny/widgets/app_text_large.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/colors.dart';

class SimulatorPage extends StatefulWidget {
  const SimulatorPage({super.key});

  @override
  State<SimulatorPage> createState() => _SimulatorPageState();
}

class _SimulatorPageState extends State<SimulatorPage> {
  List energy = [
    'hydroelectrique',
    'solaire',
    'biomasse',
    'eolienne',
  ];
  List provinces = [

  ];
  getSimProvince() async {
    await FirebaseFirestore.instance
        .collection("simProvince")
        .get()
        .then((value) {
      for (var province in value.docs) {
        provinces.add(province);
      }
    });
    if (!mounted) {
      return;
    }
    setState(() {
      provinces;
      if (provinces.isNotEmpty) {
      }
    });
  }
@override
  void initState() {
  getSimProvince();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      CupertinoSliverNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        largeTitle: const Text(
          'Simulateur',
          style: TextStyle(
            color: AppColors.activColor,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
          ),
        ),
        stretch: true,
        border: Border(),
      ),
      SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 350.0,
          mainAxisSpacing: 0,
          childAspectRatio: 1,
          mainAxisExtent: 250,
        ),
        delegate: SliverChildBuilderDelegate(
            (context, index) => Hero(
                  tag: '$index',
                  child: GestureDetector(
                    onTap: () {
                      // Presentation de la selection de l'energie à simuler
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor:
                                Theme.of(context).focusColor,
                            title: AppTextLarge(
                                text: "Sélectionnez l'énergie à simuler",
                                size: 22,
                                color: Theme.of(context).hintColor),
                            content: Container(
                              width: double.maxFinite,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:provinces[index]['energy'].length,
                                itemBuilder: (BuildContext context, int x) {
                                  String enr = provinces[index]['energy'][x];
                                  return Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        print(x);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: borderRadius,
                                          border: Border.all(
                                            color: AppColors.activColor,
                                            width: 2,
                                          ),
                                        ),
                                        height: 40,
                                        child: AppTextLarge(
                                          text: enr[0].toUpperCase() +
                                              enr.substring(1),
                                          size: 16,
                                          color: AppColors.activColor,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            actions: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: 30,
                                  width: 80,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.activColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: AppTextLarge(
                                    text: 'Fermer',
                                    size: 16,
                                    color: Theme.of(context)
                                        .focusColor,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).focusColor,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, left: 15, right: 15),
                                    child: Text(
                                      "Types d'énergies: ",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).disabledColor,
                                          fontSize: 18,
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0),
                                      softWrap: false,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis, // new
                                    )
                                    //     : Container(
                                    //   height: 14,
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: borderRadius,
                                    //     color: Theme.of(context).hoverColor,
                                    //   ),
                                    // ),
                                    ),
                                sizedbox,
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: ListView.builder(
                                        itemCount: provinces[index]['energy'].length,
                                        itemBuilder: (context, i) {
                                          String enr = provinces[index]['energy'][i];
                                          return Text(
                                            "  • ${enr[0].toUpperCase()+ enr.substring(1)}",
                                            style: TextStyle(
                                                color:
                                                    Theme.of(context).cardColor,
                                                fontSize: 16,
                                                fontFamily: 'Nunito',
                                                fontWeight: FontWeight.w900,
                                                decoration: TextDecoration.none,
                                                letterSpacing: 0),
                                            softWrap: false,
                                            maxLines: 3,
                                            overflow:
                                                TextOverflow.ellipsis, // new
                                          );
                                        }),

                                    // : const SizedBox(),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 3),
                                    child: Text(
                                      provinces[index]['name'][0].toUpperCase() +
                                          provinces[index]['name'].substring(1),
                                      style: TextStyle(
                                          color: Theme.of(context).cardColor,
                                          fontSize: 16,
                                          fontFamily: 'Nunito',
                                          letterSpacing: 0),
                                      softWrap: false,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis, // new
                                    ),
                                  ),
                                  CircleAvatar(
                                    radius: 5,
                                    backgroundColor:
                                        Theme.of(context).hintColor,
                                  )
                                ],
                              )
                              //     : Container(
                              //   alignment: Alignment.centerRight,
                              //   decoration: BoxDecoration(
                              //     borderRadius: borderRadius,
                              //     color: Theme.of(context).hoverColor,
                              //   ),
                              //   child: Container(
                              //     height: 14,
                              //     width: 14,
                              //     decoration: BoxDecoration(
                              //       shape: BoxShape.circle,
                              //       color: Theme.of(context).hintColor,
                              //       border: Border.all(
                              //         color: Theme.of(context).backgroundColor,
                              //         width: 2,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              )
                        ],
                      ),
                    ),
                  ),
                ),
            childCount: provinces.length),
      ),
    ]);
  }
}
