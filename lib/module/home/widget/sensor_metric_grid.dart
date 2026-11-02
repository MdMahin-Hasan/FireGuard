import 'package:flutter/material.dart';

import '../../../core/constant/app_color.dart';
import '../../../data/model/sensor_reading.dart';

class SensorMetricGrid extends StatelessWidget {
  const SensorMetricGrid({
    super.key,
    required this.reading,
    this.showIcon = true,
  });

  final SensorReading reading;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      ('Flame', reading.flameLabel, Icons.local_fire_department_outlined),
      ('Smoke', reading.smokeLabel, Icons.cloud_outlined),
      ('Temperature', reading.temperatureLabel, Icons.thermostat_outlined),
      ('Humidity', reading.humidityLabel, Icons.water_drop_outlined),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: metrics.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWide ? 4 : 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            mainAxisExtent: isWide ? 120 : 125,
          ),
          itemBuilder: (context, index) {
            final metric = metrics[index];

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: FireGuardColors.cardBg,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showIcon) ...[
                    Icon(
                      metric.$3,
                      size: 22,
                      color: FireGuardColors.textSecondary,
                    ),
                    const SizedBox(height: 10),
                  ],
                  Text(
                    metric.$1,
                    style: FireGuardText.metricLabel,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    metric.$2,
                    style: FireGuardText.metricValue,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}