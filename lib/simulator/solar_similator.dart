import 'package:eny/pages/home_page.dart';
import 'package:eny/widgets/app_text.dart';
import 'package:eny/widgets/app_text_large.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/colors.dart';

class SolarPage extends StatefulWidget {
  const SolarPage({super.key});

  @override
  State<SolarPage> createState() => _SolarPageState();
}

class _SolarPageState extends State<SolarPage> {
  TextEditingController power = TextEditingController();
  TextEditingController hour = TextEditingController();
  TextEditingController pannelVoltage = TextEditingController();
  TextEditingController pannelCurrent = TextEditingController();
  TextEditingController pannelPower = TextEditingController();
  TextEditingController ondPower = TextEditingController();
  TextEditingController ondVoltage = TextEditingController();

  // variables de calcul
  late double energyPro;
  late double powerCrete;
  late double capacity;
  late double chargingTime;
  late double powerOnd;
  late double powerOndApp;

  List<Map<String, String>> firstResult = [];
  bool isFinish = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            largeTitle: const Text(
              'Energie Solaire PV',
              style: TextStyle(
                color: AppColors.activColor,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
              ),
            ),
            stretch: true,
            border: const Border(),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Row(
                    children: [
                      AppText(
                        text: "Puissance journalière (W)",
                        color: Theme.of(context).hintColor,
                        size: 20,
                      ),
                      sizedbox2,
                      Expanded(
                        child: CupertinoTextField(
                          controller: power,
                          onChanged: (String value) {},
                          keyboardType: TextInputType.number,
                          decoration: BoxDecoration(
                            color: Theme.of(context).focusColor,
                            borderRadius: borderRadius,
                            border: Border.all(
                              color: AppColors.activColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Row(
                    children: [
                      AppText(
                        text: "Heure d'utilisation (h)",
                        color: Theme.of(context).hintColor,
                        size: 20,
                      ),
                      sizedbox2,
                      Expanded(
                        child: CupertinoTextField(
                          controller: hour,
                          onChanged: (String value) {},
                          decoration: BoxDecoration(
                            color: Theme.of(context).focusColor,
                            borderRadius: borderRadius,
                            border: Border.all(
                              color: AppColors.activColor,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),
                sizedbox,
                sizedbox,
              ],
            ),
          ),
          if (isFinish)
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150.0,
                mainAxisSpacing: 30,
                childAspectRatio: 1,
                mainAxisExtent: 190,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      alignment: Alignment.center,
                      height: 190,
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
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
                              child: AppTextLarge(
                               text: firstResult[index]['name']!,
                                    color: Theme.of(context).disabledColor,
                                size: 16,
                              ) ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 8, left: 8, right: 8),
                              child: Center(
                                child: AppTextLarge(
                                  text: firstResult[index]['value']!,
                                      color:AppColors.activColor,
                                  size: 28,// new
                                ),
                              ),),

                        ],
                      ),
                    ),
                  );
                },
                childCount: firstResult.length,
              ),
            ),
          if (isFinish)   SliverList(delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Row(
                children: [
                  AppText(
                    text:  "Temps de charge (h)",
                    color: Theme.of(context).hintColor,
                    size: 20,
                  ),
                  sizedbox2,
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).focusColor,
                        borderRadius: borderRadius,
                        border: Border.all(
                          color: AppColors.activColor,
                        ),
                      ),
                      child:Center(
                        child: AppTextLarge(
                          text:  chargingTime.toStringAsFixed(1),
                          color:AppColors.activColor,
                          size: 28,// new
                        ),
                      ) ,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextLarge(
                    text:  "Caractéristiques",
                    color: Theme.of(context).hintColor,
                    size: 24,
                  ),
                  AppTextLarge(
                    text:  "Panneaux:",
                    color: Theme.of(context).hintColor,
                    size: 20,
                  ),
                  sizedbox,
                  Row(
                    children: [
                      AppText(
                        text: "Tension (V)",
                        color: Theme.of(context).hintColor,
                        size: 20,
                      ),
                      sizedbox2,
                      Expanded(
                        child: CupertinoTextField(
                          controller: pannelVoltage,
                          onChanged: (String value) {},
                          decoration: BoxDecoration(
                            color: Theme.of(context).focusColor,
                            borderRadius: borderRadius,
                            border: Border.all(
                              color: AppColors.activColor,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      sizedbox2,
                      AppText(
                        text: "Courant (A)",
                        color: Theme.of(context).hintColor,
                        size: 20,
                      ),
                      sizedbox2,
                      Expanded(
                        child: CupertinoTextField(
                          controller: pannelCurrent,
                          onChanged: (String value) {},
                          decoration: BoxDecoration(
                            color: Theme.of(context).focusColor,
                            borderRadius: borderRadius,
                            border: Border.all(
                              color: AppColors.activColor,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
              sizedbox,
              Row(
                children: [
                  AppText(
                    text: "Puissance du PV (Wc)",
                    color: Theme.of(context).hintColor,
                    size: 20,
                  ),
                  sizedbox2,
                  Expanded(
                    child: CupertinoTextField(
                      controller: pannelPower,
                      onChanged: (String value) {},
                      decoration: BoxDecoration(
                        color: Theme.of(context).focusColor,
                        borderRadius: borderRadius,
                        border: Border.all(
                          color: AppColors.activColor,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
              ]
            ),
                  sizedbox,
                  AppTextLarge(
                    text:  "Onduleur:",
                    color: Theme.of(context).hintColor,
                    size: 20,
                  ),
                  Row(
                      children: [
                        AppText(
                          text: "Puissance de l'onduleur (W)",
                          color: Theme.of(context).hintColor,
                          size: 20,
                        ),
                        sizedbox2,
                        Expanded(
                          child: CupertinoTextField(
                            controller: ondPower,
                            onChanged: (String value) {},
                            decoration: BoxDecoration(
                              color: Theme.of(context).focusColor,
                              borderRadius: borderRadius,
                              border: Border.all(
                                color: AppColors.activColor,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ]
                  ),
                  sizedbox,
                  Row(
                      children: [
                        AppText(
                          text: "Tension d'attaque (V)",
                          color: Theme.of(context).hintColor,
                          size: 20,
                        ),
                        sizedbox2,
                        Expanded(
                          child: CupertinoTextField(
                            controller: ondVoltage,
                            onChanged: (String value) {},
                            decoration: BoxDecoration(
                              color: Theme.of(context).focusColor,
                              borderRadius: borderRadius,
                              border: Border.all(
                                color: AppColors.activColor,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ]
                  ),
                ],
              ),
            ),
          ]
          )),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                GestureDetector(
                  onTap: () {
                    calculs(double.parse(power.text), double.parse(hour.text),
                        4.58);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(40),
                    alignment: Alignment.center,
                    height: 60,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.activColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppTextLarge(
                          text: "Simuler",
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        sizedbox2,
                        Icon(
                          CupertinoIcons.circle_grid_hex_fill,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          size: 35,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  calculs(double power, double hour, double ir) {

    double n = 0.65; // rendement en %
    double cp = 0.9; // coefficient de perte
    double a = 1; //l'autonomie du container de stockage
    double cosphi = 0.8;
    // calcul de l'energie produite

    energyPro = (power * hour) / n;
    debugPrint(energyPro.toString());

    //calcul de la puissance crete du champ PHOTOVOLAÏQUE.

    powerCrete = (energyPro * cp) / ir;
    debugPrint(powerCrete.toString());

    //calcul de la capacité de stockage

    capacity = (power * hour) *
        a /
        0.8; // 0.8 est le taux de décharge profonde du container de stockage
    debugPrint(capacity.toString());

    //calcul de temps de chargement du container de stockage

    chargingTime = capacity / powerCrete;
    debugPrint(chargingTime.toString());

    // calcul de la puissance de l'ondileur
    powerOnd = (power * 0.3) + power;
    debugPrint(powerOnd.toString());
    powerOndApp = powerOnd / cosphi;
    debugPrint(powerOndApp.toString());
    List names = [
      "Puissance crête (W)",
      "Capacité (Wh)",
      "Puissance onduleur (W)",
    ];
    List values = [
      powerCrete.toStringAsFixed(1),
      capacity.toStringAsFixed(1),
      powerOnd.toStringAsFixed(1),
    ];
    setState(() {
      for (int i = 0; i < names.length; i++) {
        firstResult.add({
          'name': names[i],
          'value': values[i],
        });
      }

      isFinish = true;
    });
  }
}
