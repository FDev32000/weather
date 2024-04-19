import 'package:flutter/material.dart';

class Weather {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final int pressure;
  final String icon;
  final String dtText;

  Weather({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.icon,
    required this.dtText,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['main']['temp'] - 273.15,
      feelsLike: json['main']['feels_like'] - 273.15,
      humidity: json['main']['humidity'],
      pressure: json['main']['pressure'],
      icon:
          'http://openweathermap.org/img/wn/${json['weather'][0]['icon']}.png',
      dtText:
          '${DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000).toString().split(' ')[0]} ${DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000).toString().split(' ')[1].substring(0, 5)}',
    );
  }

  get dt => null;
}

class WeatherForecastTable extends StatelessWidget {
  final List<Weather> forecasts;

  WeatherForecastTable({required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Table(
      children: [
        TableRow(
          children: [
            TableCell(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Дата и время',
                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            TableCell(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Температура',
                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            TableCell(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Ощущается как',
                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            TableCell(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Влажность',
                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            TableCell(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Давление',
                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            TableCell(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Условия',
                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        ...forecasts.map((forecast) {
          return TableRow(
            children: [
              TableCell(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    forecast.dtText,
                    style: TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              TableCell(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    '${forecast.temperature.toStringAsFixed(1)}°C',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              TableCell(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    '${forecast.feelsLike.toStringAsFixed(1)}°C',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              TableCell(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    '${forecast.humidity}%',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              TableCell(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    '${forecast.pressure} hPa',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(forecast.icon, width: 32, height: 32),
                ),
              ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}

class WeatherForecast {
  final List<Weather> forecasts;

  WeatherForecast({required this.forecasts});

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    List<Weather> forecastList = [];
    for (var item in json['list']) {
      forecastList.add(Weather.fromJson(item));
    }
    return WeatherForecast(forecasts: forecastList);
  }
}

