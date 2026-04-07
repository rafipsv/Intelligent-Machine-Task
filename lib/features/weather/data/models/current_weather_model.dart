import 'package:equatable/equatable.dart';

/// Model for current weather API response from OpenWeatherMap
class CurrentWeatherModel extends Equatable {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final double? rain1h;
  final String cityName;
  final DateTime updatedAt;

  const CurrentWeatherModel({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    this.rain1h,
    required this.cityName,
    required this.updatedAt,
  });

  /// Creates model from JSON response
  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
      rain1h: json['rain'] != null
          ? (json['rain']['1h'] as num?)?.toDouble()
          : null,
      cityName: json['name'] as String,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        (json['dt'] as int) * 1000,
      ),
    );
  }

  /// Converts model to JSON for caching
  Map<String, dynamic> toJson() {
    return {
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'humidity': humidity,
      },
      'wind': {'speed': windSpeed},
      'weather': [
        {'description': description, 'icon': icon},
      ],
      if (rain1h != null) 'rain': {'1h': rain1h},
      'name': cityName,
      'dt': updatedAt.millisecondsSinceEpoch ~/ 1000,
    };
  }

  @override
  List<Object?> get props => [
    temperature,
    feelsLike,
    humidity,
    windSpeed,
    description,
    icon,
    rain1h,
    cityName,
    updatedAt,
  ];
}
