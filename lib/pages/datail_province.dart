import 'dart:ui';
import 'package:eny/pages/home_page.dart';
import 'package:eny/widgets/app_text.dart';
import 'package:eny/widgets/app_text_large.dart';
import 'package:eny/widgets/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather/weather.dart';


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
  late IconData icon ;

  late WeatherFactory weatherFactory;
  Weather? currentWeather;

  void fetchWeather() async {
    Weather? weather ;
    if(widget.data['chef-lieu'] == ''){
      weather = await weatherFactory.currentWeatherByLocation(-4.0347884999999994, 21.75502799999998);
    }else{
     weather = await weatherFactory.currentWeatherByCityName("${widget.data['chef-lieu']}");
    }

    setState(() {
      currentWeather = weather;
      if(currentWeather != null){
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
        return CupertinoIcons.cloud_hail_fill ;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Hero(
        tag: widget.tag,
        child: CustomScrollView(
            slivers: [
          SliverAppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
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
                            zoom: widget.data['chef-lieu'] ==''? 5.0:10.0, // Niveau de zoom initial
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
                                AppTextLarge(text:"${temperature.toStringAsFixed(1)} ˚C", color: AppColors.activColor,size: 45,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AppTextLarge(text: "${windSpeed.toStringAsFixed(1)} m/s", color: Colors.blueAccent,size: 26,),
                                    sizedbox2,
                                    const Icon(CupertinoIcons.wind_snow,color: Colors.blueAccent,size: 26,),
                                  ],
                                ),

                                 Icon(icon,color: AppColors.activColor,size: 70,),
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
              preferredSize: const Size.fromHeight(0.0),
              child: Container(
                padding: const EdgeInsets.only(left: 15),
                height: 50,
                width: double.maxFinite,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: AppTextLarge(
                  text: widget.data['name'][0].toUpperCase() +
                      widget.data['name'].substring(1),
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ),
        ]),
      ),

    );
  }
}
