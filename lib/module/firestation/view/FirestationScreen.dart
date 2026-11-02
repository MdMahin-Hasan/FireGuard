import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/app_color.dart';
import '../controller/controller.dart';

class FireStationScreen extends StatelessWidget {
  FireStationScreen({super.key});

  final controller = Get.put(FireStationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Nearby fire station', textAlign: TextAlign.center),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.stations.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('No fire stations found.'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: controller.fetchStations,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: controller.refresh,
              child: ListView.builder(
                padding:  const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: controller.stations.length ,
                itemBuilder: (context, index) {


                  final station = controller.stations[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.local_fire_department,
                            color: Colors.red,
                          ),
                          title: Text(
                            station.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            station.address ??
                                controller.distanceLabelFor(station),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    try {
                                      final reading = controller.latestReading.value;
                                      if (reading == null) {
                                        Get.snackbar('Error', 'No sensor data available yet');
                                        return;
                                      }

                                      await controller.openWhatsApp(
                                        station.phoneNumber,
                                        message: 'Fire emergency reported near ${station.name}. '
                                            'Please respond.\n'
                                            'Location: ${reading.googleMapsLink}',
                                      );

                                      await controller.notifyStation(station.id);
                                    } catch (e) {
                                      print('Send button error: $e'); // debug
                                      Get.snackbar('Error', 'Something went wrong: $e');
                                    }
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.chat_bubble_text,
                                  ),
                                  label: const Text('Send'),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green,foregroundColor: Colors.white)
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => controller.callStation(
                                    station.phoneNumber,
                                  ),
                                  icon: const Icon(
                                    CupertinoIcons.phone,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  label: const Text('Call',style: TextStyle(color: Colors.white),),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          });
        },
      ),
    );
  }
}