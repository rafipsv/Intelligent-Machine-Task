import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/error_message_widget.dart';
import '../../../location/presentation/bloc/location_bloc.dart';
import '../../../location/presentation/bloc/location_event.dart';
import '../../../location/presentation/bloc/location_state.dart';
import '../../../weather/presentation/bloc/weather_bloc.dart';
import '../../../weather/presentation/bloc/weather_event.dart';
import '../../../weather/presentation/bloc/weather_state.dart';
import '../../../weather/presentation/widgets/current_weather_card.dart';
import '../../../weather/presentation/widgets/alert_banner_widget.dart';
import '../../../weather/presentation/widgets/weather_stats_grid.dart';
import '../../../weather/presentation/widgets/hourly_outlook_section.dart';
import '../../../alert/domain/usecases/check_alert_threshold.dart';

/// Weather dashboard page - main home screen
class WeatherDashboardPage extends StatefulWidget {
  const WeatherDashboardPage({super.key});

  @override
  State<WeatherDashboardPage> createState() => _WeatherDashboardPageState();
}

class _WeatherDashboardPageState extends State<WeatherDashboardPage> {
  final CheckAlertThreshold checkAlertThreshold = di.sl<CheckAlertThreshold>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<LocationBloc>()..add(const FetchLocationEvent()),
        ),
        BlocProvider(
          create: (_) => di.sl<WeatherBloc>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SkySentinel'),
          centerTitle: true,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<LocationBloc>().add(const FetchLocationEvent());
                },
              ),
            ),          ],
        ),
        body: BlocListener<LocationBloc, LocationState>(
          listener: (context, state) {
            if (state is LocationLoaded) {
              // Trigger weather fetch when location is obtained
              context.read<WeatherBloc>().add(
                FetchWeatherEvent(
                  latitude: state.location.latitude,
                  longitude: state.location.longitude,
                ),
              );
            }
          },
          child: BlocBuilder<LocationBloc, LocationState>(
            builder: (context, locationState) {
              if (locationState is LocationLoading) {
                return const LoadingIndicator(message: 'Getting location...');
              } else if (locationState is LocationError) {
                return ErrorMessageWidget(
                  message: locationState.message,
                  onRetry: () {
                    context.read<LocationBloc>().add(
                      const FetchLocationEvent(),
                    );
                  },
                );
              }

              return BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, weatherState) {
                  if (weatherState is WeatherLoading) {
                    return const LoadingIndicator(
                      message: 'Loading weather data...',
                    );
                  } else if (weatherState is WeatherError) {
                    return ErrorMessageWidget(
                      message: weatherState.message,
                      onRetry: () {
                        if (locationState is LocationLoaded) {
                          context.read<WeatherBloc>().add(
                            FetchWeatherEvent(
                              latitude: locationState.location.latitude,
                              longitude: locationState.location.longitude,
                            ),
                          );
                        }
                      },
                    );
                  } else if (weatherState is WeatherLoaded) {
                    final weather = weatherState.weather;

                    return RefreshIndicator(
                      onRefresh: () async {
                        if (locationState is LocationLoaded) {
                          context.read<WeatherBloc>().add(
                            FetchWeatherEvent(
                              latitude: locationState.location.latitude,
                              longitude: locationState.location.longitude,
                            ),
                          );
                        }
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Alert Banner
                            AlertBannerWidget(
                              weather: weather,
                              checkAlertThreshold: checkAlertThreshold,
                            ),

                            const SizedBox(height: 16),

                            // Current Weather Card
                            CurrentWeatherCard(weather: weather),

                            const SizedBox(height: 24),

                            // Weather Stats Grid
                            WeatherStatsGrid(weather: weather),

                            const SizedBox(height: 24),

                            // Hourly Outlook
                            const HourlyOutlookSection(),
                          ],
                        ),
                      ),
                    );
                  }

                  return const Center(
                    child: Text('Tap refresh to get weather data'),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
