import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_current_location.dart';
import 'location_event.dart';
import 'location_state.dart';

/// BLoC for managing location state
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetCurrentLocation getCurrentLocation;

  LocationBloc({required this.getCurrentLocation})
    : super(const LocationInitial()) {
    on<FetchLocationEvent>(_onFetchLocation);
  }

  /// Handles FetchLocationEvent
  Future<void> _onFetchLocation(
    FetchLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(const LocationLoading());

    try {
      final location = await getCurrentLocation();
      emit(LocationLoaded(location));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }
}
