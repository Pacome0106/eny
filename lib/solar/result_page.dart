import 'package:eny/pages/home_page.dart';
import 'package:eny/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/app_text_large.dart';
import '../widgets/colors.dart';

class Result extends StatefulWidget {
  const Result({
    super.key,
    required this.resultEnergy,
    required this.resultDivice,
    required this.resultBudget,
    required this.resultEnv,
  });

  final List resultEnergy;
  final List resultDivice;
  final List resultBudget;
  final List resultEnv;

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  EdgeInsetsGeometry padding = const EdgeInsets.all(5);
  List tableRows = [];
  List tableRows2 = [];
  List tableRows3 = [];
  List tableRows4 = [];

  table(List tables) {
    return
      Table(
        key: GlobalKey(),
        border: TableBorder.all(width: 0.3),
        columnWidths: const {
          0: FixedColumnWidth(40.0),
          1: FixedColumnWidth(200.0),
          2: FixedColumnWidth(80.0),
        },
        children: [
          TableRow(
            decoration: const BoxDecoration(
              color: Color(0xFFB8DDFC),
            ),
            children: [
              TableCell(
                child: Center(
                  child: AppTextLarge(
                    text: 'N°',
                    color: Colors.black,
                    size: 16,
                  ),
                ),
              ),
              TableCell(
                child: Center(
                  child: AppTextLarge(
                    text: 'Désignation',
                    color: Colors.black,
                    size: 16,
                  ),
                ),
              ),
              TableCell(
                child: Center(
                  child: AppTextLarge(
                    text: 'Valeurs',
                    color: Colors.black,
                    size: 16,
                  ),
                ),
              ),
              TableCell(
                child: Center(
                  child: AppTextLarge(
                    text: 'Symbole',
                    color: Colors.black,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          // Existing rows
          for (var row in tables) tableau(row)
          ,
        ],
      );
  }

  // fonction du widget pour gener le tableau

  tableau(Map row) {
    return TableRow(children: [
      TableCell(
        child: Text(
          row['Number'] ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            letterSpacing: 0,
            fontFamily: 'Nunito',
            decoration: TextDecoration.none,
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: padding,
          child: AppText(text: row['Designation'], color: Colors.black,size: 16),
        ),
      ),
      TableCell(
        child: Center(
          child: Container(
            padding: padding,
            child: AppText(text: row['Value'], color: Colors.black,size: 16),
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: padding,
          child: Center(
            child: Icon(row['Icon']),
          ),
        ),
      ),
    ]);
  }

  @override
  void initState() {
    // TODO: implement initState
    generateTableRows(
      widget.resultEnergy,
      widget.resultDivice,
      widget.resultBudget,
      widget.resultEnv,
      widget.resultEnergy.length,
      widget.resultDivice.length,
      widget.resultBudget.length,
      widget.resultEnv.length,
    );
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            backgroundColor: Theme
                .of(context)
                .scaffoldBackgroundColor,
            leading: CupertinoButton(
              padding: const EdgeInsets.all(0),
              alignment: Alignment.centerLeft,
              child: const Icon(CupertinoIcons.back,
                  color: AppColors.activColor, size: 30),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            largeTitle: const Text(
              'Resultats',
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
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: AppTextLarge(
                          text: "Paramétres Energetiques",
                          color: Theme
                              .of(context)
                              .hintColor,
                          size: 20,
                        ),
                      ),
                      sizedbox,
                      table(tableRows),

                      sizedbox,
                      sizedbox,
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: AppTextLarge(
                          text: "Materiels Energetiques",
                          color: Theme
                              .of(context)
                              .hintColor,
                          size: 20,
                        ),
                      ),
                      sizedbox,
                      table(tableRows2),
                      sizedbox,
                      sizedbox,
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: AppTextLarge(
                          text: "Budget",
                          color: Theme
                              .of(context)
                              .hintColor,
                          size: 20,
                        ),
                      ),
                      sizedbox,
                      table(tableRows3),
                      sizedbox,
                      sizedbox,
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: AppTextLarge(
                          text: "Environnement",
                          color: Theme
                              .of(context)
                              .hintColor,
                          size: 20,
                        ),
                      ),
                      sizedbox,
                      table(tableRows4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void generateTableRows(List value1,
      List value2,
      List value3,
      List value4,
      int rowCount1,
      int rowCount2,
      int rowCount3,
      int rowCount4,) {
    for (int i = 0; i < rowCount1; i++) {
      tableRows.add({
        'Number': (i + 1).toString(),
        'Designation': value1[i]['name'],
        'Value': value1[i]['value'],
        'Icon': value1[i]['icon'],
      });
    }
    for (int i = 0; i < rowCount2; i++) {
      tableRows2.add({
        'Number': (i + 1).toString(),
        'Designation': value2[i]['name'],
        'Value': value2[i]['value'],
        'Icon': value2[i]['icon'],
      });
    }

    for (int i = 0; i < rowCount3; i++) {
      tableRows3.add({
        'Number': (i + 1).toString(),
        'Designation': value3[i]['name'],
        'Value': value3[i]['value'],
        'Icon': value3[i]['icon'],
      });
    }
    for (int i = 0; i < rowCount4; i++) {
      tableRows4.add({
        'Number': (i + 1).toString(),
        'Designation': value4[i]['name'],
        'Value': value4[i]['value'],
        'Icon': value4[i]['icon'],
      });
    }
  }
}