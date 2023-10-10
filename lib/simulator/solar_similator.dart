import 'package:eny/pages/home_page.dart';
import 'package:eny/widgets/app_text.dart';
import 'package:eny/widgets/app_text_large.dart';
import 'package:eny/widgets/card_result.dart';
import 'package:eny/widgets/time.dart';
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

  TextEditingController pricePannel = TextEditingController();
  TextEditingController priceBatt = TextEditingController();
  TextEditingController priceOnd = TextEditingController();
  TextEditingController otherPrice = TextEditingController();
  TextEditingController priceEnergy = TextEditingController();
  TextEditingController interestRate = TextEditingController();
  TextEditingController times = TextEditingController();

  // variables de calcul

  // variables de la production
  late double energy;
  late double energyDay;
  late double energyPro;
  late double powerCrete;
  late double capacity;
  late double chargingTime;
  late double powerOnd;
  late double powerOndApp;

  // variables des équipements
  late double seriePannel;
  late double pannelSerie;
  late int numberPannel;
  late double capacityBatt;
  late double serieBatt;
  late double battSerie;
  late int numberBatt;
  late double serieOnd;
  late double numberOnd;

  // variables budgetaires
  late double cti; // coût total investit
  late double rng; // recette nette generer
  late double tri; // temps de retour à l'investissement
  late double profitability; // rentabilité
  late double roi; // en francais c'est retour sur investissement

  // variables environnementaux

  late double
      cc; // crédit carbone qui est l'unité qui represente  les nombres de CO2 evité
  late double ccPrice; // argent obtenue par an
  late double ccAllPrice;

  List firstResult = [];
  bool isFinish = false;

  List pannelResult = [];
  List battResult = [];
  bool isFinish2 = false;

  List budgetResult = [];
  bool isFinish3 = false;
  bool isSelected = false;

  textField(String name, TextEditingController controler, int etape) {
    return Row(children: [
      AppText(
        text: name,
        color: Theme.of(context).hintColor,
        size: 16,
      ),
      sizedbox2,
      Expanded(
        child: CupertinoTextField(
          controller: controler,
          onChanged: (String value) {
            if (etape == 1) {
              setState(() {
                isFinish = false;
                isFinish2 = false;
                isFinish3 = false;
                pannelResult = [];
                battResult = [];
                firstResult = [];
                budgetResult = [];
              });
            }
            if (etape == 2) {
              setState(() {
                isFinish2 = false;
                isFinish3 = false;
                pannelResult = [];
                battResult = [];
                budgetResult = [];
              });
            }
            if (etape == 3) {
              setState(() {
                isFinish3 = false;
                budgetResult = [];
              });
            }
          },
          decoration: BoxDecoration(
            color: Theme.of(context).focusColor,
            borderRadius: borderRadius,
            border: Border.all(
              color: AppColors.activColor,
            ),
          ),
          style: TextStyle(color: Theme.of(context).hintColor),
          placeholder: "entrez les chiffres...",
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: CupertinoButton(
              padding: const EdgeInsets.all(0),
              alignment: Alignment.centerLeft,
              child:const Icon(CupertinoIcons.back, color: AppColors.activColor, size: 30),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
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
                  child: textField("Puissance journalière (W)", power, 1),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: textField("Heure d'utilisation (h)", hour, 1),
                ),
                if (!widget.isConnected)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: textField("Autonomie de stockage (j)", autonomy, 1),
                  ),
                sizedbox,
                sizedbox,
              ],
            ),
          ),
          if (isFinish) cardResult(firstResult, 3),
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
                          size: 16,
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
                                text: allTime(chargingTime) ,
                                color: AppColors.activColor,
                                size: 20, // new
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
                            Expanded(
                              child: textField("Tension (V)", pannelVoltage, 2),
                            ),
                            sizedbox2,
                            Expanded(
                              child: textField("Courant (A)", pannelCurrent, 2),
                            ),
                          ],
                        ),
                        sizedbox,
                        textField("Puissance du PV (Wc)", pannelPower, 2),
                        if (!widget.isConnected) sizedbox,
                        if (!widget.isConnected)
                          AppTextLarge(
                            text: "Batterie:",
                            color: Theme.of(context).hintColor,
                            size: 20,
                          ),
                        if (!widget.isConnected)
                          textField("Capacité de la batterie (Ah)", battCap, 2),
                        if (!widget.isConnected) sizedbox,
                        if (!widget.isConnected)
                          textField(
                              "Tension de la batterie (V)", battVoltage, 2),
                        sizedbox,
                        AppTextLarge(
                          text: "Onduleur:",
                          color: Theme.of(context).hintColor,
                          size: 20,
                        ),
                        textField("Puissance de l'onduleur (W)", ondPower, 2),
                        sizedbox,
                        textField("Tension d'attaque (V)", ondVoltage, 2),
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
          if (isFinish2) cardResult(pannelResult, 3),
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
          if (isFinish2 && !widget.isConnected) cardResult(battResult, 3),
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
                          size: 16,
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
                                size: 24, // new
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
                          text: "Calculs budgétaire",
                          color: Theme.of(context).hintColor,
                          size: 24,
                        ),
                        sizedbox,
                        sizedbox,
                        textField("Prix d'un panneaux (\$)", pricePannel, 3),
                        if (!widget.isConnected) sizedbox,
                        if (!widget.isConnected)
                          textField("Prix d'une batterie (\$)", priceBatt, 3),
                        sizedbox,
                        textField("Prix d'un onduleur (\$)", priceOnd, 3),
                        sizedbox,
                        textField(
                            "Autres frais d'installation (\$)", otherPrice, 3),
                        sizedbox,
                        textField("Prix de l'énergie (\$/kWh)", priceEnergy, 3),
                        sizedbox,
                        sizedbox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text:
                                  "L'argent investi est avec ou sans intérêt ?",
                              color: Theme.of(context).hintColor,
                              size: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSelected = !isSelected;
                                  isFinish3 = false;
                                  budgetResult = [];
                                });
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 2,
                                    color: isSelected
                                        ? AppColors.activColor
                                        : Colors.grey,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? AppColors.activColor
                                        : Theme.of(context)
                                            .scaffoldBackgroundColor,
                                    border: Border.all(
                                      width: 6,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (isSelected) sizedbox,
                        if (isSelected)
                          textField("Taux d'intérêt de l'argent investi (%)",
                              interestRate, 3),
                        sizedbox,
                        textField("Durée de production de la centrale (an)",
                            times, 3),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextLarge(
                                text: "Resultats budgétaire ",
                                color: Theme.of(context).hintColor,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (isFinish3) cardResult(budgetResult, budgetResult.length),
          if (isFinish3)
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: AppTextLarge(
                    text: "Resultats environnementaux",
                    color: Theme.of(context).hintColor,
                    size: 24,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      AppText(
                        text: "Crédits carbone produits par an",
                        color: Theme.of(context).hintColor,
                        size: 16,
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
                              text: cc.ceil().toString(),
                              color: AppColors.activColor,
                              size: 24, // new
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                sizedbox,
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      AppText(
                        text: "Rémunération carbone (\$/an)",
                        color: Theme.of(context).hintColor,
                        size: 16,
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
                              text: ccPrice.ceil().toString(),
                              color: AppColors.activColor,
                              size: 24, // new
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                sizedbox,
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      AppText(
                        text: "Rémunération carbone total (\$)",
                        color: Theme.of(context).hintColor,
                        size: 16,
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
                              text: ccAllPrice.ceil().toString(),
                              color: AppColors.activColor,
                              size: 24, // new
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
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
                if (isFinish2 && !isFinish3)
                  GestureDetector(
                    onTap: () {
                      // appel de la fonction de calcul
                      calcul03(
                        double.parse(pricePannel.text),
                        double.parse(priceBatt.text),
                        double.parse(priceOnd.text),
                        double.parse(otherPrice.text),
                        double.parse(priceEnergy.text),
                        isSelected ? double.parse(interestRate.text) : 0.0,
                        double.parse(times.text),
                      );
                    },
                    child: button(context, 'Continuer',
                        CupertinoIcons.circle_grid_hex_fill),
                  ),
                if (isFinish3)
                  GestureDetector(
                    onTap: () {
                      // appel de la fonction simulateur
                    },
                    child: button(context, 'Gener tout le resulatat',
                        CupertinoIcons.circle_grid_hex_fill),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//calculs des paramètre clé

  calcul01(double power, double hour, int autonomy, double ir) {
    double n = 0.25; // constante en % qui tient compte de differents rendement
    double cp = 0.9; // coefficient de perte
    double cosphi = 0.8;

    //calcul de l'enegie journalier

    energy = power * hour;

    // calcul de l'energie à produire

    energyPro = energy + (energy * n);
    debugPrint("l'energie à produite est ${energyPro.toString()}");

    //calcul de la puissance crete du champ PHOTOVOLAÏQUE

    powerCrete = (energyPro * cp) / ir;
    debugPrint(
        "la puissance crete du champ PHOTOVOLAÏQUE est ${powerCrete.toString()}");

    //calcul de la capacité de stockage

    capacity = energyPro *
        autonomy /
        0.8; // 0.8 est le taux de décharge profonde du container de stockage
    debugPrint("la capacité de stockage est ${capacity.toString()}");

    //calcul de temps de chargement du container de stockage

    chargingTime = capacity /
        powerCrete; // calcul du temps de charge de l'element de stockage
    debugPrint(
        "le temps de charge de l'element de stockage est ${chargingTime.toString()}");

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
    List icons = [
      CupertinoIcons.bolt_circle,
      Icons.storage_rounded,
      CupertinoIcons.bolt_circle,
    ];
    setState(() {
      for (int i = 0; i < 3; i++) {
        firstResult.add({
          'name': names[i],
          'value': values[i],
          'icon': icons[i],
        });
      }
      isFinish = true;
    });
  }

//dimensionnement des equipements

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
    debugPrint(
        "les nombres des groupes des panneaux en parallele est ${seriePannel.ceil().toString()}");
    pannelSerie = ondVoltage /
        pannelVoltage; //calcul de nombre des panneaux en serie par groupe
    debugPrint(
        "les nombres des panneaux en serie par groupe est ${pannelSerie.ceil().toString()}");
    numberPannel = seriePannel.ceil() *
        pannelSerie.ceil(); // calcul des nombres des panneaux
    debugPrint("les nombres des panneaux est ${numberPannel.toString()}");

    if (!isConnected) {
      //calculs sur les batteries

      capacityBatt =
          capacity / ondVoltage; // calcul de la capacité total des batteries
      debugPrint(
          "la capacité total des batteries est ${capacityBatt.toString()}");
      serieBatt = capacityBatt /
          battCap; // calcul de nombre des groupes des batteries en parallele
      debugPrint(
          "les groupes des batteries en parallele est ${serieBatt.ceil().toString()}");
      battSerie = ondVoltage /
          battVoltage; //calcul de nombre des batteries en serie par groupe
      debugPrint(
          "les batteries en serie par groupe est ${battSerie.ceil().toString()}");
      numberBatt = serieBatt.ceil() *
          battSerie.ceil(); // calcul des nombre des batteries
      debugPrint("les nombre des batteries est ${numberBatt.toString()}");
    }
    // calculs sur l'ondileur

    numberOnd = powerOnd / ondPower;
    debugPrint(
        "les  nombres des onduleurs en parallele est ${numberOnd.ceil().toString()}"); // nombres des onduleurs en parallele

    // Enregistrement des données

    List names1 = [
      "Nonmbre des panneaux",
      "Nbr panneaux en série ",
      "Nbr Serié des panneaux en parallèle ",
    ];
    List names2 = [
      "Nonmbre des batterie",
      "Nbr batterie en série",
      "Série des batteries en parallèle ",
    ];
    List values1 = [
      numberPannel.toString(),
      pannelSerie.ceil().toString(),
      seriePannel.ceil().toString(),
    ];
    List values2 = [];
    if (!isConnected) {
      values2 = [
        numberBatt.toString(),
        battSerie.ceil().toString(),
        serieBatt.ceil().toString(),
      ];
    }
    List icons1 = [
      Icons.panorama_vertical_select_rounded,
      CupertinoIcons.pano_fill,
      Icons.panorama_vertical_select_rounded,
    ];
    List icons2 = [
      Icons.battery_full,
      CupertinoIcons.battery_full,
      Icons.battery_full,
    ];
    setState(() {
      for (int i = 0; i < 3; i++) {
        pannelResult.add({
          'name': names1[i],
          'value': values1[i],
          'icon': icons1[i],
        });
      }
      if (!isConnected) {
        for (int i = 0; i < 3; i++) {
          battResult.add({
            'name': names2[i],
            'value': values2[i],
            'icon': icons2[i],
          });
        }
      }
      isFinish2 = true;
    });
  }

  // calculs budgetaire

  calcul03(
    double pricePannel,
    double priceBatt,
    double priceOnd,
    double otherPrice,
    double priceEnergy,
    double interestRate,
    double times,
  ) {
    double crp = 0.0; // coût de repayement qui depand du taux d'intérêt
    double priceExpl = 0.0; // coût d'exploitation par an d'une centrale solaire
    int days = 365; //  nombre des jours par an
    double d =
        0.1; // pourcentage du coût de repayement pour trouve le priceExpl
    double priceCc = 26.5;

    cti = (numberPannel * pricePannel) +
        (numberBatt * priceBatt) +
        (numberOnd.ceil() * priceOnd) +
        otherPrice; // calcul du coût total d'investissement
    debugPrint("le coût total d'investissement est ${cti.toString()}");

    crp = (1 + (interestRate / 100)) * cti; // calcul du coût de repayement
    // --- je divise l'intérêt par 100 car elle sera donnée en poucentage
    debugPrint("le coût de repayement est ${crp.toString()}");

    rng =
        (energy / 1000) * priceEnergy * days; // calcul du recette nette generer
    debugPrint("la recette nette generer est ${rng.toString()}");

    priceExpl = d * crp;
    tri =
        crp / (rng - priceExpl); // calcul du temps de retour à l'investissement
    debugPrint("le temps de retour à l'investissement est ${tri.toString()}");

    profitability = ((rng - priceExpl) / crp) * 100; // calcul de la rentabilité
    debugPrint("la rentabilité est ${profitability.toString()}");

    roi = ((((rng - priceExpl) * times) - crp) / crp) *
        100; // calcul du retour sur investissement
    debugPrint("le retour sur investissement est ${roi.toString()}");

    // calcul budgetaire

    cc = double.parse(power.text) / 1000;
    ccPrice = cc * priceCc;
    ccAllPrice = ccPrice * times;

    // Enregistrement des données
    List names = [
      "Coût total d'investissement",
      "Coût de repayement",
      "Revenus nets générés",
      "TRI",
      "Rentabilité",
      "Retour sur investissement"
    ];
    List values = [
      cti.ceil().toString(),
      crp.ceil().toString(),
      rng.ceil().toString(),
      allTime2(tri * 8760),
      profitability.ceil().toString(),
      roi.ceil().toString(),
    ];
    List icons = [
      CupertinoIcons.money_dollar_circle,
      CupertinoIcons.money_dollar_circle,
      CupertinoIcons.money_dollar_circle,
      CupertinoIcons.today,
      Icons.percent,
      Icons.percent,
    ];
    setState(() {
      for (int i = 0; i < names.length; i++) {
        budgetResult.add({
          'name': names[i],
          'value': values[i],
          'icon': icons[i],
        });
      }
      isFinish3 = true;
    });
  }
}
