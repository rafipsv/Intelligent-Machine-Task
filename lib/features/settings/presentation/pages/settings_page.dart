import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/error_message_widget.dart';
import '../../domain/entities/alert_settings.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../widgets/threshold_slider_tile.dart';
import '../widgets/alert_switch_tile.dart';

/// Settings page for configuring alert thresholds
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<SettingsBloc>()..add(const LoadSettingsEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Alert Settings'), centerTitle: true),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoading) {
              return const LoadingIndicator(message: 'Loading settings...');
            } else if (state is SettingsError) {
              return ErrorMessageWidget(
                message: state.message,
                onRetry: () {
                  context.read<SettingsBloc>().add(const LoadSettingsEvent());
                },
              );
            } else if (state is SettingsLoaded) {
              return _SettingsForm(settings: state.settings);
            }

            return const Center(child: Text('No settings available'));
          },
        ),
      ),
    );
  }
}

class _SettingsForm extends StatefulWidget {
  final AlertSettingsEntity settings;

  const _SettingsForm({required this.settings});

  @override
  State<_SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<_SettingsForm> {
  late double tempThreshold;
  late bool alertOnRain;
  late double rainThreshold;
  late bool alertOnHighUV;
  late double uvThreshold;

  @override
  void initState() {
    super.initState();
    tempThreshold = widget.settings.tempThreshold;
    alertOnRain = widget.settings.alertOnRain;
    rainThreshold = widget.settings.rainThreshold;
    alertOnHighUV = widget.settings.alertOnHighUV;
    uvThreshold = widget.settings.uvThreshold;
  }

  void _saveSettings() {
    final updatedSettings = AlertSettingsEntity(
      tempThreshold: tempThreshold,
      alertOnRain: alertOnRain,
      rainThreshold: rainThreshold,
      alertOnHighUV: alertOnHighUV,
      uvThreshold: uvThreshold,
    );

    context.read<SettingsBloc>().add(
      UpdateSettingsEvent(settings: updatedSettings),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('Temperature Alert', [
            ThresholdSliderTile(
              label: 'Temperature Threshold',
              value: tempThreshold,
              unit: '°C',
              min: 20,
              max: 45,
              onChanged: (value) => setState(() => tempThreshold = value),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection('Rain Alert', [
            AlertSwitchTile(
              label: 'Enable Rain Alert',
              value: alertOnRain,
              onChanged: (value) => setState(() => alertOnRain = value),
            ),
            if (alertOnRain)
              ThresholdSliderTile(
                label: 'Rain Threshold',
                value: rainThreshold,
                unit: 'mm',
                min: 0,
                max: 10,
                onChanged: (value) => setState(() => rainThreshold = value),
              ),
          ]),
          const SizedBox(height: 24),
          _buildSection('UV Alert', [
            AlertSwitchTile(
              label: 'Enable High UV Alert',
              value: alertOnHighUV,
              onChanged: (value) => setState(() => alertOnHighUV = value),
            ),
            if (alertOnHighUV)
              ThresholdSliderTile(
                label: 'UV Threshold',
                value: uvThreshold,
                unit: '',
                min: 0,
                max: 11,
                onChanged: (value) => setState(() => uvThreshold = value),
              ),
          ]),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Save Settings',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}
