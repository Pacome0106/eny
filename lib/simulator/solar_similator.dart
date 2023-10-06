
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';


class Simulator extends StatefulWidget {
  @override
  _SimulatorState createState() => _SimulatorState();
}

class _SimulatorState extends State<Simulator> {
  late WeatherFactory weatherFactory;
  Weather? currentWeather;
  @override
  void initState() {
    super.initState();

    // Initialise le WeatherFactory avec votre clé d'API OpenWeatherMap
    weatherFactory = WeatherFactory('d093aa4f50a6353d62b881d85a8bb237');

    // Appelle la fonction pour obtenir les informations météorologiques
    fetchWeather();
  }

  void fetchWeather() async {
    Weather? weather = await weatherFactory.currentWeatherByCityName('kinshasa');

    setState(() {
      print(weather.weatherIcon);
      currentWeather = weather;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
        ),
        body: Center(
          child: currentWeather != null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Latitude: ${currentWeather!.latitude.toString()}'),
              Text('Longitude: ${currentWeather!.longitude.toString()}'),
              Text('Temperature: ${currentWeather!.temperature!.celsius.toString()}°C'),
              Text('Ensoleillement: ${currentWeather!.weatherDescription!.toString()}'),
              Text('Vitesse du vent: ${currentWeather!.windSpeed.toString()} m/s'),
            ],
          )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}