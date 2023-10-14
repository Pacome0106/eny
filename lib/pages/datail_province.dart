import 'dart:ui';
import 'dart:math' as math;
import 'package:eny/pages/home_page.dart';
import 'package:eny/widgets/app_text.dart';
import 'package:eny/widgets/app_text_large.dart';
import 'package:eny/widgets/colors.dart';
import 'package:eny/widgets/lign.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather/weather.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:syncfusion_flutter_charts/charts.dart';

class DetailProvince extends StatefulWidget {
  const DetailProvince({
    super.key,
    required this.tag,
    required this.data,
  });

  final String tag;
  final data;

  @override
  State<DetailProvince> createState() => _DetailProvinceState();
}

class _DetailProvinceState extends State<DetailProvince> {
  bool isLocalisation = false;
  double latitude = 0.0;
  double longitude = 0.0;
  double temperature = 0.0;
  double windSpeed = 0.0;
  int populationInitiale = 0;

  late IconData icon;

  late WeatherFactory weatherFactory;
  Weather? currentWeather;
  String chefLieu = "";

  void fetchWeather() async {
    Weather? weather;

    if (widget.data['chef-lieu'] == '') {
      setState(() {
      chefLieu = "Kinshasa";
        });
      weather = await weatherFactory.currentWeatherByLocation(
          -4.0347884999999994, 21.75502799999998);
    } else {
      setState(() {
        chefLieu = widget.data['chef-lieu'];
      });
      weather = await weatherFactory
          .currentWeatherByCityName("${widget.data['chef-lieu']}");
    }

    setState(() {
      currentWeather = weather;
      if (currentWeather != null) {
        isLocalisation = true;
        latitude = currentWeather!.latitude!;
        longitude = currentWeather!.longitude!;
        temperature = currentWeather!.temperature!.celsius!;
        windSpeed = currentWeather!.windSpeed!;
        icon = _getWeatherIcon(currentWeather!.weatherIcon!);
        print(currentWeather!.weatherIcon!);
      }
    });
  }

  IconData _getWeatherIcon(String weatherCode) {
    switch (weatherCode) {
      case "01d":
        return CupertinoIcons.sun_max_fill;
      case "01n":
        return CupertinoIcons.moon_stars_fill;
      case "02d":
        return CupertinoIcons.cloud_sun_fill;
      case "02n":
        return CupertinoIcons.cloud_moon_fill;
      case "03d":
      case "03n":
        return CupertinoIcons.cloud_fill;
      case "04d":
      case "04n":
        return CupertinoIcons.smoke_fill;
      case "09d":
      case "09n":
        return CupertinoIcons.cloud_hail_fill;
      case "10d":
        return CupertinoIcons.cloud_sun_rain_fill;
      case "10n":
        return CupertinoIcons.cloud_moon_rain_fill;
      case "11d":
      case "11n":
        return CupertinoIcons.cloud_bolt_fill;
      case "13d":
      case "13n":
        return CupertinoIcons.snow;
      case "50d":
      case "50n":
        return Icons.blur_on;
      default:
        return Icons.error;
    }
  }

  @override
  void initState() {
    // Initialise le WeatherFactory avec votre clé d'API OpenWeatherMap
    weatherFactory = WeatherFactory('d093aa4f50a6353d62b881d85a8bb237');
    // Appelle la fonction pour obtenir les informations météorologiques
    fetchWeather();
    populationInitiale = int.tryParse(widget.data['population']) ?? 0;
    super.initState();
  }

  final double tauxAccroissement = 0.01;
  final List<int> annees = [2023, 2030, 2035, 2040, 2050];

  @override
  Widget build(BuildContext context) {
    List<SalesData> chartData = generateChartData();
    final List<PuissanceData> data = [
      PuissanceData(
        'Installée',
        double.parse(widget.data['puissance installee']),
      ),
      PuissanceData(
          'Demandée', double.parse(widget.data['puissance demandee'])),
      PuissanceData(
        'Disponible',
        double.parse(widget.data['puissance disponible']),
      ),
    ];
    return Scaffold(
      body: Hero(
        tag: widget.tag,
        child: CustomScrollView(slivers: [
          SliverAppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
            ),
            leading: CupertinoButton(
              padding: const EdgeInsets.all(0),
              alignment: Alignment.centerLeft,
              child: const Icon(CupertinoIcons.back,
                  color: AppColors.activColor, size: 30),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            expandedHeight: MediaQuery.of(context).size.height * 0.6,
            elevation: 0.0,
            pinned: true,
            stretch: true,
            automaticallyImplyLeading: true,
            forceElevated: true,
            flexibleSpace: FlexibleSpaceBar(
              background: isLocalisation
                  ? Stack(
                      alignment: Alignment.topRight,
                      children: [
                        FlutterMap(
                          options: MapOptions(
                            center: LatLng(latitude, longitude),
                            // Centre de la carte
                            zoom: widget.data['chef-lieu'] == ''
                                ? 5.0
                                : 10.0, // Niveau de zoom initial
                          ),
                          nonRotatedChildren: const [
                            RichAttributionWidget(
                              animationConfig: ScaleRAWA(),
                              // Or `FadeRAWA` as is default
                              attributions: [
                                TextSourceAttribution(
                                  'OpenStreetMap contributors',
                                  //   onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                                ),
                              ],
                            ),
                          ],
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: const ['a', 'b', 'c'],
                              userAgentPackageName: 'com.example.eny',
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 70, right: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              AppTextLarge(
                                text: "${temperature.toStringAsFixed(1)} ˚C",
                                color: AppColors.activColor,
                                size: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AppTextLarge(
                                    text: "${windSpeed.toStringAsFixed(1)} m/s",
                                    color: Colors.blueAccent,
                                    size: 20,
                                  ),
                                  sizedbox2,
                                  const Icon(
                                    CupertinoIcons.wind_snow,
                                    color: Colors.blueAccent,
                                    size: 20,
                                  ),
                                ],
                              ),
                              Icon(
                                icon,
                                color: AppColors.activColor,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Icon(
                        CupertinoIcons.arrow_2_circlepath,
                        size: 35,
                      ),
                    ),
              stretchModes: const <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10.0),
              child: Container(
                padding: const EdgeInsets.only(left: 15),
                height: 65,
                width: double.maxFinite,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 50,
                        height: 8.0,
                        decoration: BoxDecoration(
                            color: AppColors.activColor,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: AppTextLarge(
                        text: widget.data['name'][0].toUpperCase() +
                            widget.data['name'].substring(1),
                        color: Theme.of(context).hintColor,
                        size: 18,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: AppText(
                        text: chefLieu[0].toUpperCase() +
                            chefLieu.substring(1),
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, int index) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).focusColor,
                              borderRadius: borderRadius,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        text: "Superficie de la region",
                                        color: Theme.of(context).hintColor,
                                      ),
                                      AppTextLarge(
                                        text: '${addSpaces(
                                          widget.data['superficial'],
                                        )} km²',
                                        color: AppColors.activColor,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  const Lign(indent: 0, endIndent: 0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        text: 'Population de la zone',
                                        color: Theme.of(context).hintColor,
                                      ),
                                      Center(
                                        child: AppTextLarge(
                                          text: '${addSpaces(
                                            widget.data['population'],
                                          )} habitants',
                                          color: AppColors.activColor,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Lign(indent: 0, endIndent: 0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        text: 'Densité de la region',
                                        color: Theme.of(context).hintColor,
                                      ),
                                      Row(
                                        children: [
                                          Center(
                                            child: AppTextLarge(
                                              text:
                                                  '${widget.data['density']} hab/km²',
                                              color: AppColors.activColor,
                                              size: 16,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          sizedbox,
                          sizedbox,
                          AppText(
                            text:
                                'courbe esthimatif de la population en fonction des annees',
                            color: Theme.of(context).hintColor,
                          ),
                          sizedbox,
                          Center(
                            child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(
                                title: AxisTitle(text:"Années" ),
                              ),
                              series: <ChartSeries>[
                                // Renders line chart
                                LineSeries<SalesData, String>(
                                  dataSource: chartData,
                                  xValueMapper: (SalesData sales, _) =>
                                      sales.year.toString(),
                                  yValueMapper: (SalesData sales, _) =>
                                      sales.sales,
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    labelPosition:
                                        ChartDataLabelPosition.outside,
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
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).focusColor,
                              borderRadius: borderRadius,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        text: "Puissance disponible",
                                        color: Theme.of(context).hintColor,
                                      ),
                                      AppTextLarge(
                                        text: '${addSpaces(
                                          widget.data['puissance disponible'],
                                        )} MW',
                                        color: AppColors.activColor,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  const Lign(indent: 0, endIndent: 0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        text: 'Puissance demandee',
                                        color: Theme.of(context).hintColor,
                                      ),
                                      Center(
                                        child: AppTextLarge(
                                          text: '${addSpaces(
                                            widget.data['puissance demandee'],
                                          )} MW',
                                          color: AppColors.activColor,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Lign(indent: 0, endIndent: 0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        text: 'Puissance installee',
                                        color: Theme.of(context).hintColor,
                                      ),
                                      Row(
                                        children: [
                                          Center(
                                            child: AppTextLarge(
                                              text:
                                                  '${addSpaces(widget.data['puissance installee'])} MW',
                                              color: AppColors.activColor,
                                              size: 16,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  sizedbox,
                                ],
                              ),
                            ),
                          ),
                          sizedbox,
                          sizedbox,
                          AppText(
                            text: 'courbe des puissances',
                            color: Theme.of(context).hintColor,
                          ),
                          sizedbox,
                          Center(
                            child: SizedBox(
                              height: 250.0,
                              // padding: EdgeInsets.all(16),
                              child: charts.BarChart(
                                [
                                  charts.Series<PuissanceData, String>(
                                    id: 'puissance',
                                    colorFn: (PuissanceData data, _) {
                                      if (data.categorie == 'Installée') {
                                        return charts.MaterialPalette.purple
                                            .shadeDefault;
                                      } else if (data.categorie == 'Demandée') {
                                        return charts.MaterialPalette.deepOrange
                                            .shadeDefault;
                                      } else if (data.categorie ==
                                          'Disponible') {
                                        return charts
                                            .MaterialPalette.red.shadeDefault;
                                      }
                                      return charts
                                          .MaterialPalette.gray.shadeDefault;
                                    },
                                    domainFn: (PuissanceData data, _) =>
                                        data.categorie,
                                    measureFn: (PuissanceData data, _) =>
                                        data.valeur,
                                    data: data,
                                  ),
                                ],
                                animate: true,
                                defaultRenderer: charts.BarRendererConfig(
                                  groupingType: charts.BarGroupingType.grouped,
                                  strokeWidthPx: 2.0,
                                  barRendererDecorator:
                                      charts.BarLabelDecorator<String>(),
                                ),
                              ),
                            ),
                          ),
                          sizedbox,
                          Container(
                            alignment: Alignment.topLeft,
                            child: AppTextLarge(
                              text: "Potentiel",
                              color: Theme.of(context).hintColor,
                              size: 20,
                            ),
                          ),
                          sizedbox,
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).focusColor,
                              borderRadius: borderRadius,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppText(
                                            text: 'Eolien : ',
                                            color: Theme.of(context).hintColor,
                                          ),
                                          Center(
                                            child: AppTextLarge(
                                              text: '${addSpaces(
                                                widget.data['potentiel eolien'],
                                              )} m/s',
                                              color: AppColors.activColor,
                                              size: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 20,
                                        width: 2,
                                        color: Colors.black,
                                      ),
                                      Row(
                                        children: [
                                          AppText(
                                            text: "Biomasse : ",
                                            color: Theme.of(context).hintColor,
                                          ),
                                          AppTextLarge(
                                            text: '${addSpaces(
                                              widget.data['potentiel biomasse'],
                                            )} MW',
                                            color: AppColors.activColor,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Lign(indent: 0, endIndent: 0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          AppText(
                                            text: 'Solaire : ',
                                            color: Theme.of(context).hintColor,
                                          ),
                                          Center(
                                            child: AppTextLarge(
                                              text: '${addSpaces(
                                                widget
                                                    .data['potentiel solaire'],
                                              )} kWh/m²/j',
                                              color: AppColors.activColor,
                                              size: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 20,
                                        width: 2,
                                        color: Colors.black,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            text: 'Geothermie : ',
                                            color: Theme.of(context).hintColor,
                                          ),
                                          Center(
                                            child: AppTextLarge(
                                              text: '${addSpaces(
                                                widget.data[
                                                    'potentiel geothermique'],
                                              )} MW',
                                              color: AppColors.activColor,
                                              size: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Lign(indent: 0, endIndent: 0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        text: 'Hydroélectrique :',
                                        color: Theme.of(context).hintColor,
                                      ),
                                      Row(
                                        children: [
                                          Center(
                                            child: AppTextLarge(
                                              text:
                                                  '${addSpaces(widget.data['potentiel hydroelectrique'])} MW',
                                              color: AppColors.activColor,
                                              size: 16,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  sizedbox,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                childCount: 1),
          ),
        ]),
      ),
    );
  }

/*
cette fonction calcule la population future en utilisant la formule de taux de croissance,
 crée des objets SalesData avec l'année et la population future,
 et les ajoute à une liste. La liste complète est ensuite retournée en tant que résultat.
*/
  List<SalesData> generateChartData() {
    List<SalesData> chartData = [];

    for (int i = 0; i < annees.length; i++) {
      int year = annees[i];
      int differenceAnnees = year - 2023;
      int populationFuture = (populationInitiale *
              math.pow(1 + tauxAccroissement, differenceAnnees))
          .round();
      chartData.add(SalesData(year, populationFuture));
    }

    return chartData;
  }

/*
la fonction addSpaces() utilise une expression régulière pour rechercher des groupes
 de chiffres dans une chaîne de caractères et ajoute un espace après chaque groupe de chiffres
*/
  String addSpaces(String value) {
    return value.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]} ',
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);

  final int year;
  final int sales;
}

class PuissanceData {
  final String categorie;
  final double valeur;

  PuissanceData(this.categorie, this.valeur);
}
