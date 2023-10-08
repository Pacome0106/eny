import 'package:eny/pages/home_page.dart';
import 'package:eny/widgets/app_text.dart';
import 'package:eny/widgets/app_text_large.dart';
import 'package:eny/widgets/card_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/button.dart';
import '../widgets/colors.dart';

class SolarPage extends StatefulWidget {
  const SolarPage({
    super.key,
    required this.title,
    required this.isConnected,
    required this.irradiation,
  });

  final String title;
  final double irradiation;
  final bool isConnected;

  @override
  State<SolarPage> createState() => _SolarPageState();
}

class _SolarPageState extends State<SolarPage> {
  //les controller de chaque Textfield
  TextEditingController power = TextEditingController();
  TextEditingController hour = TextEditingController();
  TextEditingController autonomy = TextEditingController();
  TextEditingController pannelVoltage = TextEditingController();
  TextEditingController pannelCurrent = TextEditingController();
  TextEditingController pannelPower = TextEditingController();
  TextEditingController battCap = TextEditingController();
  TextEditingController battVoltage = TextEditingController();
  TextEditingController ondPower = TextEditingController();
  TextEditingController ondVoltage = TextEditingController();

  // variables de calcul
  late double energyDay;
  late double energyPro;
  late double powerCrete;
  late double capacity;
  late double chargingTime;
  late double powerOnd;
  late double powerOndApp;
  late double seriePannel;
  late double pannelSerie;
  late int numberPannel;
  late double capacityBatt;
  late double serieBatt;
  late double battSerie;
  late int numberBatt;
  late double serieOnd;
  late double numberOnd;

  List<Map<String, String>> firstResult = [];
  bool isFinish = false;

  List<Map<String, String>> pannelResult = [];
  List<Map<String, String>> battResult = [];
  bool isFinish2 = false;

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
                          onChanged: (String value) {
                            setState(() {
                              isFinish = false;
                              isFinish2 = false;
                              pannelResult = [];
                              battResult = [];
                              firstResult = [];
                            });
                          },
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          placeholder: "entrez les chiffres...",
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
                          onChanged: (String value) {
                            setState(() {
                              isFinish = false;
                              isFinish2 = false;
                              pannelResult = [];
                              battResult = [];
                              firstResult = [];
                            });
                          },
                          decoration: BoxDecoration(
                            color: Theme.of(context).focusColor,
                            borderRadius: borderRadius,
                            border: Border.all(
                              color: AppColors.activColor,
                            ),
                          ),
                          textAlign: TextAlign.center,
                          placeholder: "entrez les chiffres...",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!widget.isConnected)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Row(
                      children: [
                        AppText(
                          text: "Autonomie (j)",
                          color: Theme.of(context).hintColor,
                          size: 20,
                        ),
                        const Expanded(child: const SizedBox()),
                        SizedBox(
                          width: 100,
                          child: CupertinoTextField(
                            controller: autonomy,
                            onChanged: (String value) {
                              setState(() {
                                isFinish = false;
                                isFinish2 = false;
                                pannelResult = [];
                                battResult = [];
                                firstResult = [];
                              });
                            },
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            placeholder: "entrez les chiffres...",
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
                sizedbox,
                sizedbox,
              ],
            ),
          ),
          if (isFinish) cardResult(firstResult),
          if (isFinish)
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: Row(
                      children: [
                        AppText(
                          text: "Temps de charge (h)",
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
                            child: Center(
                              child: AppTextLarge(
                                text: chargingTime.toStringAsFixed(1),
                                color: AppColors.activColor,
                                size: 28, // new
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextLarge(
                          text: "Caractéristiques",
                          color: Theme.of(context).hintColor,
                          size: 24,
                        ),
                        AppTextLarge(
                          text: "Panneaux:",
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
                                onChanged: (String value) {
                                  setState(() {
                                    isFinish2 = false;
                                    pannelResult = [];
                                    battResult = [];
                                  });
                                },
                                decoration: BoxDecoration(
                                  color: Theme.of(context).focusColor,
                                  borderRadius: borderRadius,
                                  border: Border.all(
                                    color: AppColors.activColor,
                                  ),
                                ),
                                placeholder: "entrez les chiffres...",
                                textAlign: TextAlign.center,
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
                                onChanged: (String value) {
                                  setState(() {
                                    isFinish2 = false;
                                    pannelResult = [];
                                    battResult = [];
                                  });
                                },
                                decoration: BoxDecoration(
                                  color: Theme.of(context).focusColor,
                                  borderRadius: borderRadius,
                                  border: Border.all(
                                    color: AppColors.activColor,
                                  ),
                                ),
                                placeholder: "entrez les chiffres...",
                                textAlign: TextAlign.center,
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
                                onChanged: (String value) {
                                  setState(() {
                                    isFinish2 = false;
                                    pannelResult = [];
                                    battResult = [];
                                  });
                                },
                                decoration: BoxDecoration(
                                  color: Theme.of(context).focusColor,
                                  borderRadius: borderRadius,
                                  border: Border.all(
                                    color: AppColors.activColor,
                                  ),
                                ),
                                placeholder: "entrez les chiffres...",
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        if (!widget.isConnected) sizedbox,
                        if (!widget.isConnected)
                          AppTextLarge(
                            text: "Batterie:",
                            color: Theme.of(context).hintColor,
                            size: 20,
                          ),
                        if (!widget.isConnected)
                          Row(
                            children: [
                              AppText(
                                text: "Capacité de la batterie (Ah)",
                                color: Theme.of(context).hintColor,
                                size: 20,
                              ),
                              sizedbox2,
                              Expanded(
                                child: CupertinoTextField(
                                  controller: battCap,
                                  onChanged: (String value) {
                                    setState(() {
                                      isFinish2 = false;
                                      pannelResult = [];
                                      battResult = [];
                                    });
                                  },
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).focusColor,
                                    borderRadius: borderRadius,
                                    border: Border.all(
                                      color: AppColors.activColor,
                                    ),
                                  ),
                                  placeholder: "entrez les chiffres...",
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        if (!widget.isConnected) sizedbox,
                        if (!widget.isConnected)
                          Row(
                            children: [
                              AppText(
                                text: "Tension de la batterie (V)",
                                color: Theme.of(context).hintColor,
                                size: 20,
                              ),
                              sizedbox2,
                              Expanded(
                                child: CupertinoTextField(
                                  controller: battVoltage,
                                  onChanged: (String value) {
                                    setState(() {
                                      isFinish2 = false;
                                      pannelResult = [];
                                      battResult = [];
                                    });
                                  },
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).focusColor,
                                    borderRadius: borderRadius,
                                    border: Border.all(
                                      color: AppColors.activColor,
                                    ),
                                  ),
                                  placeholder: "entrez les chiffres...",
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        sizedbox,
                        AppTextLarge(
                          text: "Onduleur:",
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
                                onChanged: (String value) {
                                  setState(() {
                                    isFinish2 = false;
                                    pannelResult = [];
                                    battResult = [];
                                  });
                                },
                                decoration: BoxDecoration(
                                  color: Theme.of(context).focusColor,
                                  borderRadius: borderRadius,
                                  border: Border.all(
                                    color: AppColors.activColor,
                                  ),
                                ),
                                placeholder: "entrez les chiffres...",
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        sizedbox,
                        Row(children: [
                          AppText(
                            text: "Tension d'attaque (V)",
                            color: Theme.of(context).hintColor,
                            size: 20,
                          ),
                          sizedbox2,
                          Expanded(
                            child: CupertinoTextField(
                              controller: ondVoltage,
                              onChanged: (String value) {
                                setState(() {
                                  isFinish2 = false;
                                  pannelResult = [];
                                  battResult = [];
                                });
                              },
                              decoration: BoxDecoration(
                                color: Theme.of(context).focusColor,
                                borderRadius: borderRadius,
                                border: Border.all(
                                  color: AppColors.activColor,
                                ),
                              ),
                              placeholder: "entrez les chiffres...",
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (isFinish2)
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 30, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextLarge(
                          text: "Resultats",
                          color: Theme.of(context).hintColor,
                          size: 24,
                        ),
                        AppTextLarge(
                          text: "Panneaux:",
                          color: Theme.of(context).hintColor,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (isFinish2) cardResult(pannelResult),
          if (isFinish2)
            if (!widget.isConnected)
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: AppTextLarge(
                        text: "Batterie:",
                        color: Theme.of(context).hintColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
          if (isFinish2 && !widget.isConnected) cardResult(battResult),
          if (isFinish2)
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: AppTextLarge(
                      text: "Onduleur:",
                      color: Theme.of(context).hintColor,
                      size: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        AppText(
                          text: "Nombres d'onduleur en parallèle",
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
                            child: Center(
                              child: AppTextLarge(
                                text: numberOnd.ceil().toString(),
                                color: AppColors.activColor,
                                size: 28, // new
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                if (!isFinish)
                  GestureDetector(
                    onTap: () {
                      // appel de la fonction de calcul
                      calcul01(
                        double.parse(power.text),
                        double.parse(hour.text),
                        widget.isConnected ? 1 : int.parse(autonomy.text),
                        widget.irradiation,
                      );
                    },
                    child: button(context, 'Commencer',
                        CupertinoIcons.circle_grid_hex_fill),
                  ),
                if (isFinish && !isFinish2)
                  GestureDetector(
                    onTap: () {
                      // appel de la fonction de calcul
                      calcul02(
                        widget.isConnected,
                        double.parse(pannelVoltage.text),
                        double.parse(pannelPower.text),
                        !widget.isConnected ? double.parse(battCap.text) : 0.0,
                        !widget.isConnected
                            ? double.parse(battVoltage.text)
                            : 0.0,
                        double.parse(ondPower.text),
                        double.parse(ondVoltage.text),
                      );
                    },
                    child: button(context, 'Continuer',
                        CupertinoIcons.circle_grid_hex_fill),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  calcul01(double power, double hour, int autonomy, double ir) {
    double n = 0.65; // rendement en %
    double cp = 0.9; // coefficient de perte
    double cosphi = 0.8;
    //calcul de l'enegie journalier

    energyDay = (power * hour) + ((power * hour) * 0.2);
    debugPrint(energyDay.toString());
    // calcul de l'energie produite

    energyPro = energyDay / n;
    debugPrint(energyPro.toString());

    //calcul de la puissance crete du champ PHOTOVOLAÏQUE.

    powerCrete = (energyPro * cp) / ir;
    debugPrint(powerCrete.toString());

    //calcul de la capacité de stockage

    capacity = energyDay *
        autonomy /
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

    // Enregistrement des données

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
      for (int i = 0; i < 3; i++) {
        firstResult.add({
          'name': names[i],
          'value': values[i],
        });
      }
      isFinish = true;
    });
  }

  calcul02(
    bool isConnected,
    double pannelVoltage,
    // double pannelCurrent,
    double pannelPower,
    double battCap,
    double battVoltage,
    double ondPower,
    double ondVoltage,
  ) {
    //calculs sur les panneaux

    seriePannel = powerCrete /
        pannelPower; // calcul de nombre des groupes des panneaux en parallele
    debugPrint(seriePannel.ceil().toString());
    pannelSerie = ondVoltage /
        pannelVoltage; //calcul de nombre des panneaux en serie par groupe
    debugPrint(pannelSerie.ceil().toString());
    numberPannel = seriePannel.ceil() *
        pannelSerie.ceil(); // calcul des nombres des panneaux
    debugPrint(numberPannel.toString());

    if (!isConnected) {
      //calculs sur les batteries

      capacityBatt =
          capacity / ondVoltage; // calcul de la capacité total des batteries
      debugPrint(capacityBatt.toString());
      serieBatt = capacityBatt /
          battCap; // calcul de nombre des groupes des batteries en parallele
      debugPrint(serieBatt.ceil().toString());
      battSerie = ondVoltage /
          battVoltage; //calcul de nombre des batteries en serie par groupe
      debugPrint(battSerie.ceil().toString());
      numberBatt = serieBatt.ceil() * battSerie.ceil();
      debugPrint(numberBatt.toString());
    }
    // calculs sur l'ondileur

    numberOnd = powerOnd / ondPower;
    debugPrint(
        numberOnd.ceil().toString()); // nombres des onduleurs en parallele

    // Enregistrement des données

    List names1 = [
      "Nonmbre des panneaux",
      "Groupe des panneaux en parallèle ",
      "Panneaux en série par groupe",
    ];
    List names2 = [
      "Nonmbre des batterie",
      "Groupe des batterie en parallèle ",
      "Batterie en série par groupe",
    ];
    List values1 = [
      numberPannel.toString(),
      seriePannel.ceil().toString(),
      pannelSerie.ceil().toString(),
    ];
    List values2 = [];
    if (!isConnected) {
      values2 = [
        numberBatt.toString(),
        serieBatt.ceil().toString(),
        battSerie.ceil().toString(),
      ];
    }
    setState(() {
      for (int i = 0; i < 3; i++) {
        pannelResult.add({
          'name': names1[i],
          'value': values1[i],
        });
      }
      if (!isConnected) {
        for (int i = 0; i < 3; i++) {
          battResult.add({
            'name': names2[i],
            'value': values2[i],
          });
        }
      }
      isFinish2 = true;
    });
  }
}
