import 'package:eny/simulator/biomasse/result_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../pages/home_page.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_large.dart';
import '../../widgets/button.dart';
import '../../widgets/card_result.dart';
import '../../widgets/colors.dart';
import '../../widgets/time.dart';
import '../solar/result_page.dart';

class BiomaseSimilator extends StatefulWidget {
  const BiomaseSimilator({super.key});

  @override
  State<BiomaseSimilator> createState() => _BiomaseSimilatorState();
}

class _BiomaseSimilatorState extends State<BiomaseSimilator> {
  //controlleur pour les textField
  TextEditingController power = TextEditingController();
  TextEditingController hour = TextEditingController();
  TextEditingController powerGen = TextEditingController();
  TextEditingController litleOnhour = TextEditingController();
  TextEditingController priceGen = TextEditingController();
  TextEditingController priceLitle = TextEditingController();
  TextEditingController priceEnergy = TextEditingController();
  TextEditingController interestRate = TextEditingController();
  TextEditingController times = TextEditingController();

  //les etapes de simulation
  bool isFinish1 = false;
  bool isFinish2 = false;

  // A calculer
  late double powerPro;
  late double energy;
  late double cons;
  late double otherPrice;
  late double maintPrice;
  late double personPrice;

  // variables budgetaires
  late double cti; // coût total investit
  late double rng; // recette nette generer
  late double tri; // temps de retour à l'investissement
  late double crp; // coût de repayement qui depand du taux d'intérêt
  late double profitability; // rentabilité
  late double roi; // en francais c'est retour sur investissement

  // variables environnementaux

  late double
  cc; // crédit carbone qui est l'unité qui represente  les nombres de CO2 evité
  late double ccPrice; // argent obtenue par an
  late double ccAllPrice;

  bool isSelected = false;
  List budgetResult1 = [];
  List budgetResult2 = [];

  textField(String name, TextEditingController controler, int etape) {
    return Row(children: [
      AppText(
        text: name,
        color: Theme.of(context).hintColor,
      ),
      sizedbox2,
      Expanded(
        child: CupertinoTextField(
          controller: controler,
          onChanged: (String value) {
            if (etape == 1) {
              setState(() {
                //
                isFinish1 = false;
                isFinish2 = false;
                budgetResult1 = [];
                budgetResult2 = [];
              });
            }
            if (etape == 2) {
              setState(() {
                //
                isFinish2 = false;
                budgetResult1 = [];
                budgetResult2 = [];
              });
            }
            if (etape == 3) {
              setState(() {
                //
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
      body: CustomScrollView(slivers: [
        CupertinoSliverNavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: CupertinoButton(
            padding: const EdgeInsets.all(0),
            alignment: Alignment.centerLeft,
            child: const Icon(CupertinoIcons.back,
                color: AppColors.activColor, size: 30),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          largeTitle: Text(
            'Thermique Biodiesel',
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
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: textField("Puissance installation (W)", power, 1),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: textField("Heure d'utilisation (h/j)", hour, 1),
              ),
              sizedbox,
              sizedbox,
              if (isFinish1)
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            AppText(
                              text: "Puissance à produire (VA)",
                              color: Theme.of(context).hintColor,
                            ),
                            sizedbox,
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Theme.of(context).focusColor,
                                borderRadius: borderRadius,
                              ),
                              child: Center(
                                child: AppTextLarge(
                                  text: powerPro.toStringAsFixed(1),
                                  color: AppColors.activColor,
                                  size: 16, // new
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      sizedbox2,
                      Expanded(
                        child: Column(
                          children: [
                            AppText(
                              text: "Energie journalier (Wh)",
                              color: Theme.of(context).hintColor,
                            ),
                            sizedbox,
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Theme.of(context).focusColor,
                                borderRadius: borderRadius,
                              ),
                              child: Center(
                                child: AppTextLarge(
                                  text: energy.toStringAsFixed(1),
                                  color: AppColors.activColor,
                                  size: 16, // new
                                ),
                              ),
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
        if (isFinish1)
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: AppTextLarge(
                    text: "Paramètres:",
                    color: Theme.of(context).hintColor,
                    size: 24,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: textField("Puissance du Génerateur (VA)", powerGen, 2),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: textField(
                      "Consommation du Génerateur (l/h)", litleOnhour, 2),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: textField("Coût du Génerateur (\$)", priceGen, 2),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: textField(
                      "Prix du litre du carburant (\$/l)", priceLitle, 2),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child:
                      textField("Prix de l'énergie (\$/kWh)", priceEnergy, 2),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: "L'argent investi est avec ou sans intérêt ?",
                            color: Theme.of(context).hintColor,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSelected = !isSelected;
                                // isFinish2 = false;
                              });
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 2, color: AppColors.activColor),
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
                      textField(
                          "Durée de production de la centrale (an)", times, 3),
                      if (isFinish2)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextLarge(
                                text: "Resultats budgétaire",
                                color: Theme.of(context).hintColor,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                if (isFinish2) Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextLarge(
                        text: "Investissement ",
                        color: Theme.of(context).hintColor,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        if (isFinish2) cardResult(budgetResult1, budgetResult1.length),
        if (isFinish2)
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextLarge(
                        text: "Revenues ",
                        color: Theme.of(context).hintColor,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        if (isFinish2) cardResult(budgetResult2, budgetResult2.length),
        if (isFinish2) SliverList(delegate: SliverChildListDelegate([
          Padding(
            padding:
            const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Row(
              children: [
                AppText(
                  text: "Temps de retour à l'investissement",
                  color: Theme.of(context).hintColor,
                ),
                sizedbox2,
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).focusColor,
                      borderRadius: borderRadius,
                    ),
                    child: Center(
                      child: AppTextLarge(
                        text: tri > 0.0 ? allTime2(tri * 8760) : "Jamais",
                        color: AppColors.activColor,
                        size: 16, // new
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]
          ,),),
        if (isFinish2) SliverList(
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
                  ),
                  sizedbox2,
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).focusColor,
                        borderRadius: borderRadius,
                      ),
                      child: Center(
                        child: AppTextLarge(
                          text: cc.toStringAsFixed(1),
                          color: AppColors.activColor,
                          size: 16, // new
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
                  ),
                  sizedbox2,
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).focusColor,
                        borderRadius: borderRadius,
                      ),
                      child: Center(
                        child: AppTextLarge(
                          text: ccPrice.toStringAsFixed(1),
                          color: AppColors.activColor,
                          size: 16, // new
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
                  ),
                  sizedbox2,
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).focusColor,
                        borderRadius: borderRadius,
                      ),
                      child: Center(
                        child: AppTextLarge(
                          text: ccAllPrice.toStringAsFixed(1),
                          color: AppColors.activColor,
                          size: 16, // new
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
              if (!isFinish1)
                GestureDetector(
                  onTap: () {
                    // appel de la fonction de calcul
                    calcul(
                      double.parse(power.text),
                      double.parse(hour.text),
                    );
                  },
                  child: button(context, 'Commencer',
                      CupertinoIcons.rectangle_3_offgrid_fill),
                ),
              if (isFinish1 && !isFinish2)
                GestureDetector(
                  onTap: () {
                    // appel de la fonction de calcul
                    calcul2(
                        double.parse(litleOnhour.text),
                        double.parse(hour.text),
                        double.parse(priceGen.text),
                        double.parse(priceLitle.text),
                        double.parse(priceEnergy.text),
                        double.parse(times.text),
                        isSelected ? double.parse(interestRate.text) : 0.0);
                  },
                  child: button(context, 'Continuer',
                      CupertinoIcons.rectangle_3_offgrid_fill),
                ),

              if (isFinish2)  GestureDetector(
                onTap: () {
                  List<Map<String, Object>> budget = [];
                    budget = [
                      {
                        'name': "Prix de l'énergie (\$/kWh)",
                        'value': priceEnergy.text,
                        'icon': CupertinoIcons.money_dollar_circle,
                      },
                      {
                        'name': "Taux d'intérêt de l'argent investi (%)",
                        'value': isSelected ? interestRate.text : "0",
                        'icon': Icons.percent,
                      },
                      {
                        'name': "Durée de production de la centrale (an)",
                        'value': times.text,
                        'icon': CupertinoIcons.calendar,
                      },
                    ];

                  // appel de la fonction result du simulateur
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultBiomasse(
                        enter: [
                          {
                            'name': "Puissance installation (W)",
                            'value': power.text,
                            'icon': CupertinoIcons.bolt_circle,
                          },
                          {
                            'name': "Heure d'utilisation (h)",
                            'value': hour.text,
                            'icon': CupertinoIcons.time,
                          },

                          {
                            'name': "Puissance du Génerateur (VA)",
                            'value': powerGen.text,
                            'icon': Icons.power_rounded,
                          },
                          {
                            'name': "Consommation du Génerateur (l/h)",
                            'value': litleOnhour.text,
                            'icon': Icons.water_drop_rounded,
                          },
                          {
                            'name': "Coût du Génerateur (\$)",
                            'value': priceGen.text,
                            'icon': CupertinoIcons.money_dollar_circle,
                          },
                          {
                            'name': "Prix du litre du carburant (\$/l)",
                            'value': priceLitle.text,
                            'icon': CupertinoIcons.money_dollar_circle,
                          }

                        ] +
                            budget,
                        //
                        resultEnergy:
                            [
                              {
                                'name': "Puissance à produire (VA)",
                                'value':powerPro.toStringAsFixed(1),
                                'icon': CupertinoIcons.bolt_circle,
                              },
                              {
                                'name': "Energie journalier (Wh)",
                                'value':energy.toStringAsFixed(1),
                                'icon': CupertinoIcons.bolt_circle,
                              }
                            ],
                        resultBudget: budgetResult1 + budgetResult2 +[
                          {
                            'name': "Temps de retour à l'investissement",
                            'value':tri > 0.0 ? allTime2(tri * 8760) : "Jamais",
                            'icon': CupertinoIcons.calendar,
                          }
                        ],
                        resultEnv: [
                          {
                            'name': "Crédits carbone produits par an",
                            'value': cc.toStringAsFixed(1),
                            'icon': CupertinoIcons.tree,
                          },
                          {
                            'name': "Rémunération carbone (\$/an)",
                            'value': ccPrice.toStringAsFixed(1),
                            'icon': CupertinoIcons.money_dollar_circle,
                          },
                          {
                            'name': "Rémunération carbone total (\$)",
                            'value': ccAllPrice.toStringAsFixed(1),
                            'icon': CupertinoIcons.money_dollar_circle,
                          }
                        ],
                        priceU: crp * (profitability / 100),
                        energyU: energy * 365,
                      ),
                    ),
                  );
                },
                child: button(context, 'Gener tout le resulatat',
                    CupertinoIcons.circle_grid_hex_fill),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  calcul(double power, double hour) {
    double n = 0.2; //coefficient de charge
    double cosphi = 0.8;

    //calcul de la puissance du generateur
    double allpower = power + (power * n);
    powerPro = allpower / cosphi;
    debugPrint("la puissance du generateur est de $powerPro");

    //calcul de l'energie journalier à produire
    energy = allpower * hour;
    debugPrint("l'energie produite journalierement est de $energy");

    setState(() {
      isFinish1 = true;
    });
  }

  calcul2(
    double litleOnhour,
    double hour,
    double priceGen,
    double priceLitle,
    double priceEnergy,
    double times,
    double interestRate,
  ) {
    double priceInst =
        0.08; // autre prix de l'installation du generateur qui est le 8% le coût du generateur
    double priceMaint =
        0.04; // coût de la maintenance du generateur qui est de 4% le coût du generateur
    double pricePerson =
        0.1; // coût du personnel exploitant qui est de 10% le coût total investi
    int days = 365; //  nombre des jours par an
    double CFI = 0.0;
    double priceExpl = 0.0; // coût d'exploitation par an d'une centrale solaire
    double priceCc = 33.5;
    double ccLitle = 2.67; // 1l de biodiesel evite 2.67 kg de co2 dans la nature qui peux etre produit par le diesel

    //calcul de la consommation journalier
    cons = litleOnhour * hour;
    debugPrint("la consommation journalier est de $cons");

    //calcul des autre prix
    otherPrice = priceGen * priceInst;
    debugPrint("Prix de l'installation du generateur $otherPrice");

    maintPrice = priceGen * priceMaint;
    debugPrint("Coût  de la maintenance du generateur $maintPrice");

    CFI = otherPrice + priceGen + cons * priceLitle;

    personPrice = CFI * pricePerson;
    debugPrint("Coût  du personnel exploitant $personPrice");

    priceExpl = ((personPrice + maintPrice) * 12) + (cons * priceLitle * days);
    debugPrint("la  ${priceExpl.toString()}");

    cti = CFI + priceExpl;
    debugPrint("le coût total d'investissement est $cti");

    crp = (1 + (interestRate / 100)) * cti; // calcul du coût de repayement
    // --- je divise l'intérêt par 100 car elle sera donnée en poucentage
    debugPrint("le coût de repayement est ${crp.toString()}");


    rng = ((energy / 1000) * priceEnergy * days) ; // calcul du recette nette generer
    debugPrint("la recette nette generer est ${rng.toString()}");

    tri = crp / rng; // calcul du temps de retour à l'investissement
    debugPrint("le temps de retour à l'investissement est ${tri.toString()}");

    profitability = (rng / crp) * 100; // calcul de la rentabilité
    debugPrint("la rentabilité est ${profitability.toString()}");

    roi = (((rng * times) - crp) / crp) *
        100; // calcul du retour sur investissement
    debugPrint("le retour sur investissement est ${roi.toString()}");

    // calcul environnementaux

    cc = ((litleOnhour * hour * days)/1000) ;
    ccPrice = cc * priceCc;

    ccAllPrice = ccPrice * (times == 0? 1:times);
    print(ccAllPrice);

    // Enregistrement des données
    List names = [
      "Consommation journalier",
      "Coût de l'installation du generateur",
      "Coût  de la maintenance du generateur ",
      "Coût  du personnel exploitant ",
      "Coût total d'investissement",
      "Coût de repayement",
    ];
    List values = [
      cons.ceil().toString(),
      otherPrice.ceil().toString(),
      maintPrice.ceil().toString(),
      personPrice.ceil().toString(),
      cti.ceil().toString(),
      crp.ceil().toString(),
    ];
    List icons = [
      Icons.water_drop_rounded,
      CupertinoIcons.money_dollar_circle,
      CupertinoIcons.money_dollar_circle,
      CupertinoIcons.money_dollar_circle,
      CupertinoIcons.money_dollar_circle,
      CupertinoIcons.money_dollar_circle,
      // CupertinoIcons.calendar,
      // Icons.percent,
      // Icons.percent,
    ];
    setState(() {
      for (int i = 0; i < names.length; i++) {
        budgetResult1.add({
          'name': names[i],
          'value': values[i],
          'icon': icons[i],
        });
      }
      isFinish2 = true;
    });

    //// Enregistrement des données 2
    List names2 = [
      "Revenus nets générés",
      "Rentabilité",
      "Retour sur investissement",
    ];
    List values2 = [
      rng.ceil().toString(),
      profitability.ceil().toString(),
      roi.ceil().toString(),
    ];
    List icons2 = [
      CupertinoIcons.money_dollar_circle,
      // CupertinoIcons.calendar,
      Icons.percent,
      Icons.percent,
    ];
    setState(() {
      for (int i = 0; i < names2.length; i++) {
        budgetResult2.add({
          'name': names2[i],
          'value': values2[i],
          'icon': icons2[i],
        });
      }
      isFinish2 = true;
    });


  }
}
