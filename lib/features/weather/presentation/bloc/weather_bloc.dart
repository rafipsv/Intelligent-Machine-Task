import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_current_weather.dart';
import '../../domain/usecases/get_forecast.dart';
import 'weather_event.dart';
import 'weather_state.dart';

/// BLoC for managing weather state
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeather getCurrentWeather;
  final GetForecast getForecast;

  WeatherBloc({required this.getCurrentWeather, required this.getForecast})
    : super(const WeatherInitial()) {
    on<FetchWeatherEvent>(_onFetchWeather);
  }

  /// Handles FetchWeatherEvent
  Future<void> _onFetchWeather(
    FetchWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoading());

    try {
      // Fetch current weather
      final weather = await getCurrentWeather(
        lat: event.latitude,
        lon: event.longitude,
      );

      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
}
