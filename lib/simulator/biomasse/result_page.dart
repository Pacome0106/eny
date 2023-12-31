import 'package:eny/pages/home_page.dart';
import 'package:eny/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../widgets/app_text_large.dart';
import '../../widgets/colors.dart';


class ResultBiomasse extends StatefulWidget {
  const ResultBiomasse({
    super.key,
    required this.enter,
    required this.resultEnergy,
    required this.resultBudget,
    required this.resultEnv,
    required this.priceU,
    required this.energyU,
  });

  final List enter;
  final List resultEnergy;
  final List resultBudget;
  final List resultEnv;
  final double priceU;
  final double energyU;

  @override
  State<ResultBiomasse> createState() => _ResultBiomasseState();
}

class _ResultBiomasseState extends State<ResultBiomasse> {
  EdgeInsetsGeometry padding = const EdgeInsets.all(5);
  List tableRows = [];
  List tableRows1 = [];
  List tableRows2 = [];
  List tableRows3 = [];

  table(List tables) {
    return Table(
      key: GlobalKey(),
      border: TableBorder.all(
        width: 0.3,
        color: Theme.of(context).hintColor,
      ),
      columnWidths: const {
        0: FixedColumnWidth(30.0),
        1: FixedColumnWidth(180.0),
        3: FixedColumnWidth(80.0),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(
            color: Color(0xFFC1FC66),
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
        for (var row in tables) tableau(row),
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
          style: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: 14,
            letterSpacing: 0,
            fontFamily: 'Nunito',
            decoration: TextDecoration.none,
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: padding,
          child: AppText(
            text: row['Designation'],
            color: Theme.of(context).hintColor,
          ),
        ),
      ),
      TableCell(
        child: Center(
          child: Container(
            padding: padding,
            child: AppText(
              text: row['Value'],
              color: Theme.of(context).hintColor,
            ),
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
      widget.enter,
      widget.resultEnergy,
      widget.resultBudget,
      widget.resultEnv,
      widget.enter.length,
      widget.resultEnergy.length,
      widget.resultBudget.length,
      widget.resultEnv.length,
    );
    super.initState();
  }

  Widget build(BuildContext context) {
    List<SalesData> chartData = generateChartData();
    List<SalesData> chartData2 = generateChartData2();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
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
            largeTitle:  Text(
              'Resultats',
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
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: AppTextLarge(
                          text: "Données entrants",
                          color: Theme.of(context).hintColor,
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
                          text: "Résulats après simulation",
                          color: Theme.of(context).hintColor,
                          size: 20,
                        ),
                      ),
                      sizedbox,
                      Center(
                        child: AppTextLarge(
                          text: "Paramétres énergetiques",
                          color: Theme.of(context).hintColor,
                          size: 16,
                        ),
                      ),
                      sizedbox,
                      table(tableRows1),
                      sizedbox,
                      sizedbox,
                        Center(
                          child: AppTextLarge(
                            text: "Budget",
                            color: Theme.of(context).hintColor,
                            size: 16,
                          ),
                        ),
                       sizedbox,
                   table(tableRows2),
                      sizedbox,
                      sizedbox,
                      Center(
                        child: AppTextLarge(
                          text: "Environnement",
                          color: Theme.of(context).hintColor,
                          size: 16,
                        ),
                      ),
                      sizedbox,
                      table(tableRows3),
                    ],
                  ),
                ),
                sizedbox,
                sizedbox,
                Center(
                  child: AppTextLarge(
                    text: "Différentes courbes",
                    color: Theme.of(context).hintColor,
                    size: 16,
                  ),
                ),
                sizedbox,
                Center(
                  child: AppText(
                    text: "Courbe énergetque",
                    color: Theme.of(context).hintColor,
                  ),
                ),
                sizedbox,
                Center(
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(title: AxisTitle(text: "ans")),
                    series: <ChartSeries>[
                      // Renders line chart
                      LineSeries<SalesData, String>(
                        color: Colors.red,
                        dataSource: chartData2,
                        xValueMapper: (SalesData sales, _) =>
                            sales.year.toString(),
                        yValueMapper: (SalesData sales, _) => sales.sales,
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          labelPosition: ChartDataLabelPosition.outside,
                          textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      )
                    ],
                    onDataLabelRender: (DataLabelRenderArgs args) {
                      args.text = addSpaces(args.text);
                    },
                  ),
                ),
                sizedbox,
                  Center(
                    child: AppText(
                      text: 'Courbe des Revenus nets générés',
                      color: Theme.of(context).hintColor,
                    ),
                  ),
             sizedbox,
                  Center(
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(title: AxisTitle(text: "ans")),
                      series: <ChartSeries>[
                        // Renders line chart
                        LineSeries<SalesData, String>(
                          color: Colors.orangeAccent,
                          dataSource: chartData,
                          xValueMapper: (SalesData sales, _) =>
                              sales.year.toString(),
                          yValueMapper: (SalesData sales, _) => sales.sales,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                            textStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                      ],
                      onDataLabelRender: (DataLabelRenderArgs args) {
                        args.text = addSpaces(args.text);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void generateTableRows(
      List value,
      List value1,
      List value2,
      List value3,
      int rowCount,
      int rowCount1,
      int rowCount2,
      int rowCount3,
      ) {
    for (int i = 0; i < rowCount; i++) {
      tableRows.add({
        'Number': (i + 1).toString(),
        'Designation': value[i]['name'] ?? "",
        'Value': value[i]['value'] ?? "",
        'Icon': value[i]['icon'] ?? Icons.abc_outlined,
      });
    }
    for (int i = 0; i < rowCount1; i++) {
      tableRows1.add({
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
  }

  String addSpaces(String value) {
    return value.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]} ',
    );
  }

  List<SalesData> generateChartData2() {
    List<SalesData> chartData = [];
    List time = [1, 2, 3, 3.8, 5, 6.4, 7, 8, 11, 15];
    double energyTotal = 0;
    for (int i = 0; i < time.length; i++) {
      int year = time[i].round();
      // Calculer le paiement total
      energyTotal = widget.energyU * time[i];
      chartData.add(SalesData(year, energyTotal.round()));
    }

    return chartData;
  }

  List<SalesData> generateChartData() {
    List<SalesData> chartData = [];

      List time = [1, 2, 3.8, 5, 6.4, 7, 8, 10, 11, 13, 15];
      double priceTotal = 0;

      for (int i = 0; i < time.length; i++) {
        int year = time[i].round();
        // Calculer le paiement total
        priceTotal = widget.priceU * time[i];
        chartData.add(SalesData(year, priceTotal.round()));

    }
    return chartData;
  }
}

class SalesData {
  SalesData(this.year, this.sales);

  final int year;
  final int sales;
}
