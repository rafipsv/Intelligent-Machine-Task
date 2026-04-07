import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/error_message_widget.dart';
import '../bloc/forecast_bloc.dart';
import '../bloc/forecast_event.dart';
import '../bloc/forecast_state.dart';
import '../widgets/forecast_day_tile.dart';

/// Forecast page showing 5-day weather forecast
class ForecastPage extends StatelessWidget {
  const ForecastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ForecastBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('5-Day Forecast'), centerTitle: true),
        body: BlocBuilder<ForecastBloc, ForecastState>(
          builder: (context, state) {
            if (state is ForecastLoading) {
              return const LoadingIndicator(message: 'Loading forecast...');
            } else if (state is ForecastError) {
              return ErrorMessageWidget(
                message: state.message,
                onRetry: () {
                  context.read<ForecastBloc>().add(
                    const FetchForecastEvent(
                      latitude: 23.8103,
                      longitude: 90.4125,
                    ),
                  );
                },
              );
            } else if (state is ForecastLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ForecastBloc>().add(
                    const FetchForecastEvent(
                      latitude: 23.8103,
                      longitude: 90.4125,
                    ),
                  );
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.forecast.length,
                  itemBuilder: (context, index) {
                    final forecast = state.forecast[index];
                    return ForecastDayTile(forecast: forecast);
                  },
                ),
              );
            }

            return const Center(child: Text('No forecast data available'));
          },
        ),
      ),
    );
  }
}
