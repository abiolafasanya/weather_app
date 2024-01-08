import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/screen/components/forcast_card.dart';
import 'package:weather_app/screen/components/forcast_info_card.dart';

import 'package:http/http.dart' as http;
import 'package:weather_app/secret.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  late Future<Map<String, dynamic>> weather;

  @override
  void initState() {
    super.initState();
    weather = getWeather();
  }

  Future<Map<String, dynamic>> getWeather() async {
    String query = "Nigeria";
    String endpoint =
        "https://api.openweathermap.org/data/2.5/forecast?q=$query&appid=$weatherApiKey";
    try {
      final res = await http.get(Uri.parse(endpoint));
      final data = jsonDecode(res.body);
      if (res.statusCode != 200) {
        throw "An unexpected error occured";
      }
      return data;
    } catch (e) {
      logger(e);
      throw e.toString();
    }
  }

  void logger(dynamic value) {
    if (kDebugMode) {
      print(value);
    }
  }

  void refreshApp() {
    if (kDebugMode) {
      print("Refreshing");
      setState(() {
        weather = getWeather();
      });
    }
  }

  IconData weatherIcon(String weather) {
    if (weather.toLowerCase() == 'snow') return Icons.cloudy_snowing;
    if (weather.toLowerCase() == 'clear') return Icons.sunny;
    if (weather.toLowerCase() == 'rain') return Icons.shower;
    return Icons.cloud;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: refreshApp, icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
          future: weather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              logger(snapshot.connectionState);
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString(),
                    style:
                        const TextStyle(fontSize: 24, color: Colors.deepOrange),
                    textAlign: TextAlign.center),
              );
            }
            final data = snapshot.data!;
            final currentData = data['list'][0];
            final currentTemp = currentData['main']['temp'];
            final currentSky = currentData['weather'][0]['main'];
            final currentPressure = currentData['main']['pressure'];
            final currentHumidity = currentData['main']['humidity'];
            final currentWindSpeed = currentData['wind']['speed'];

            String formatTime(String date) {
              DateTime time = DateTime.parse(date);
              var res = DateFormat.j().format(time);

              return res;
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(children: [
                              Text(
                                "$currentTemp K",
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                weatherIcon(currentSky),
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                currentSky,
                                style: const TextStyle(
                                  fontSize: 24,
                                ),
                              )
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Weather Forcast",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        final hourlyForcast = data['list'][index + 1];

                        return ForcastCard(
                            time: formatTime(hourlyForcast['dt_txt']),
                            temperature:
                                hourlyForcast['main']['temp'].toString(),
                            icon: weatherIcon(
                                hourlyForcast['weather'][0]['main']));
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Additional Information",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InfoCard(
                          text: "Humidity",
                          value: currentHumidity.toString(),
                          icon: Icons.water_drop),
                      InfoCard(
                          text: "Wind Speed",
                          value: currentWindSpeed.toString(),
                          icon: Icons.air),
                      InfoCard(
                          text: "Pressure",
                          value: currentPressure.toString(),
                          icon: Icons.speed)
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
