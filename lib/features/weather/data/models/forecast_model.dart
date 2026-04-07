import 'package:equatable/equatable.dart';

/// Model for a single forecast item (3-hour interval)
class ForecastItemModel extends Equatable {
  final DateTime dateTime;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final double? rain3h;

  const ForecastItemModel({
    required this.dateTime,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    this.rain3h,
  });

  factory ForecastItemModel.fromJson(Map<String, dynamic> json) {
    return ForecastItemModel(
      dateTime: DateTime.parse(json['dt_txt'] as String),
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
      rain3h: json['rain'] != null
          ? (json['rain']['3h'] as num?)?.toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt_txt': dateTime.toIso8601String(),
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'humidity': humidity,
      },
      'wind': {'speed': windSpeed},
      'weather': [
        {'description': description, 'icon': icon},
      ],
      if (rain3h != null) 'rain': {'3h': rain3h},
    };
  }

  @override
  List<Object?> get props => [
    dateTime,
    temperature,
    feelsLike,
    humidity,
    windSpeed,
    description,
    icon,
    rain3h,
  ];
}

/// Model for daily forecast (aggregated from 3-hour items)
class ForecastDayModel extends Equatable {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final String description;
  final String icon;
  final List<ForecastItemModel> hourlyItems;

  const ForecastDayModel({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.description,
    required this.icon,
    required this.hourlyItems,
  });

  @override
  List<Object?> get props => [
    date,
    minTemp,
    maxTemp,
    description,
    icon,
    hourlyItems,
  ];
}
