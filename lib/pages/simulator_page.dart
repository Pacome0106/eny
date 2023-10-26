import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eny/pages/home_page.dart';
import 'package:eny/simulator/biomasse/biomasse_simulator.dart';
import 'package:eny/widgets/app_text_large.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../simulator/solar/solar_similator.dart';
import '../widgets/app_text.dart';
import '../widgets/colors.dart';

class SimulatorPage extends StatefulWidget {
  const SimulatorPage({super.key});

  @override
  State<SimulatorPage> createState() => _SimulatorPageState();
}

class _SimulatorPageState extends State<SimulatorPage> {
  List simProvinces = [];
  bool isData = false;

  getSimProvince() async {
    await FirebaseFirestore.instance
        .collection("simProvince")
        .get()
        .then((value) {
      for (var province in value.docs) {
        simProvinces.add(province);
      }
    });
    if (!mounted) {
      return;
    }
    setState(() {
      simProvinces;
      if (simProvinces.isNotEmpty) {
        isData = true;
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
        largeTitle: Text(
          'Simulateur',
          style: TextStyle(
            color: Theme.of(context).hintColor,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w900,
          ),
        ),
        stretch: true,
        border: const Border(),
      ),
      SliverList(
        delegate: SliverChildListDelegate(
          [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: AppTextLarge(
                text: "Région de simulation",
                color: Theme.of(context).hintColor,
                size: 16,
              ),
            ),
            sizedbox,
          ],
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: isData ? simProvinces.length : 10,
          (context, index) => Hero(
            tag: '$index',
            child: GestureDetector(
              onTap: () {
                // Presentation de la selection de l'energie à simuler
                if (isData) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Theme.of(context).focusColor,
                        title: Center(
                          child: AppText(
                            text: "Sélectionnez l'énergie à simuler",
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: simProvinces[index]['energy'].length,
                            itemBuilder: (BuildContext context, int x) {
                              String enr = simProvinces[index]['energy'][x];
                              String ir = simProvinces[index]['irradiation'];
                              return Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: GestureDetector(
                                  onTap: () {
                                    print(x);
                                    Navigator.of(context).pop();
                                    if (enr == 'solaire PV') {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor:
                                                Theme.of(context).focusColor,
                                            insetPadding: const EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                            ),
                                            title: Center(
                                              child: AppText(
                                                text:
                                                    'Sélectionnez le type de votre système',
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: borderRadius),
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    top: 20,
                                                    bottom: 20,
                                                    left: 10,
                                                    right: 10),
                                            content: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    //installation autonome
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SolarPage(
                                                          title: enr,
                                                          isConnected: false,
                                                          irradiation:
                                                              double.parse(ir),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8, right: 8),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          borderRadius,
                                                      border: Border.all(
                                                        color: AppColors
                                                            .activColor,
                                                      ),
                                                    ),
                                                    height: 30,
                                                    width: 120,
                                                    child: AppTextLarge(
                                                      text: 'Autonome',
                                                      size: 16,
                                                      color:
                                                          AppColors.activColor,
                                                    ),
                                                  ),
                                                ),
                                                sizedbox2,
                                                sizedbox2,
                                                GestureDetector(
                                                  onTap: () {
                                                    //installation raccordée au reseau
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SolarPage(
                                                          title: enr,
                                                          isConnected: true,
                                                          irradiation:
                                                              double.parse(ir),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8, right: 8),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          borderRadius,
                                                      border: Border.all(
                                                        color: AppColors
                                                            .activColor,
                                                      ),
                                                    ),
                                                    height: 30,
                                                    width: 120,
                                                    child: AppTextLarge(
                                                      text: 'Raccordé',
                                                      size: 16,
                                                      color:
                                                          AppColors.activColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    } else if (enr == "biomasse") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BiomaseSimilator(),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: borderRadius,
                                      border: Border.all(
                                        color: AppColors.activColor,
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
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              height: 30,
                              width: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.activColor,
                                borderRadius: borderRadius,
                              ),
                              child: AppTextLarge(
                                text: 'Fermer',
                                size: 16,
                                color: Theme.of(context).focusColor,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).focusColor,
                          border: isData
                              ? Border.all(color: AppColors.activColor)
                              : Border()),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: isData
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 10,
                                        backgroundColor: AppColors.activColor,
                                      ),
                                      sizedbox2,
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 3),
                                        child: Text(
                                          simProvinces[index]['name'][0]
                                                  .toUpperCase() +
                                              simProvinces[index]['name']
                                                  .substring(1),
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).hintColor,
                                              fontSize: 14,
                                              fontFamily: 'Nunito',
                                              letterSpacing: 0),
                                          softWrap: false,
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow.ellipsis, // new
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).canvasColor,
                                      borderRadius: borderRadius,
                                    ),
                                    child: Icon(
                                      CupertinoIcons
                                          .rectangle_fill_on_rectangle_fill,
                                      color: Theme.of(context)
                                          .unselectedWidgetColor,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                   width: 200,
                                    height: 30,
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      borderRadius: borderRadius,
                                      color: Theme.of(context).hoverColor,
                                    ),
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).hintColor,
                                        border: Border.all(
                                          color: Theme.of(context).backgroundColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    borderRadius: borderRadius,
                                  ),
                                ),
                              ],
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
