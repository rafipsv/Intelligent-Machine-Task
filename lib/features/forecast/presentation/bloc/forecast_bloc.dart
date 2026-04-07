import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../weather/domain/usecases/get_forecast.dart';
import 'forecast_event.dart';
import 'forecast_state.dart';

/// BLoC for managing forecast state
class ForecastBloc extends Bloc<ForecastEvent, ForecastState> {
  final GetForecast getForecast;

  ForecastBloc({required this.getForecast}) : super(const ForecastInitial()) {
    on<FetchForecastEvent>(_onFetchForecast);
  }

  /// Handles FetchForecastEvent
  Future<void> _onFetchForecast(
    FetchForecastEvent event,
    Emitter<ForecastState> emit,
  ) async {
    emit(const ForecastLoading());

    try {
      final forecast = await getForecast(
        lat: event.latitude,
        lon: event.longitude,
      );

      emit(ForecastLoaded(forecast));
    } catch (e) {
      emit(ForecastError(e.toString()));
    }
  }
}
