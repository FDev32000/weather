import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'weather.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Прогноз погоды',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
      ),
      home: const WeatherHomePage(
        title: 'Прогноз погоды',
        key: null,
      ),
    );
  }
}

class WeatherService {
  final String apiKey = 'b00090cf4e3f6262d0b7572ab5682f32';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/forecast';
  final String baseUrl2 = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherForecast> getWeather(String city) async {
    final url = '$baseUrl?q=$city&appid=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WeatherForecast.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key, required this.title});
  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final WeatherService weatherService = WeatherService();
  String selectedCity = 'Ханты-Мансийск';
  WeatherForecast? weatherForecast;
  Weather? currentWeather;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    _getWeather(selectedCity);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  initialValue: selectedCity,
                  onChanged: (newValue) {
                    setState(() {
                      selectedCity = newValue;
                    });
                    _getWeather(selectedCity);
                  },
                  decoration: InputDecoration(
                    labelText: 'Город',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              if (currentWeather != null)
                Container(
                  width: screenWidth * 0.98,
                  height: screenHeight * 0.2,
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.network(currentWeather!.icon, width: 64, height: 64,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Текущая температура: ${currentWeather!.temperature.toStringAsFixed(1)}°C',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          Text(
                            'Ощущается как: ${currentWeather!.feelsLike.toStringAsFixed(1)}°C',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            'Влажность: ${currentWeather!.humidity}%',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (weatherForecast != null && weatherForecast!.forecasts.isNotEmpty)
                SizedBox(
                  width: screenWidth * 0.98,
                  height: screenHeight * 0.5,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: IntrinsicWidth(
                      child: WeatherForecastTable(forecasts: weatherForecast!.forecasts),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _getWeather(String city) async {
    try {
      final data = await weatherService.getWeather(city);
      setState(() {
        weatherForecast = data;
        currentWeather = data.forecasts.first;
      });
    } catch (e) {
      print(e);
    }
  }
}
