import 'package:firedetection_system/module/profile/view/team%20member.dart';
import 'package:firedetection_system/module/profile/widget/menutile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/app_routes.dart';
import '../../../core/storage/auth_storage.dart';
import '../controller/profile_controller.dart';
import '../widget/alert dialoge.dart';
import '../widget/badge.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  static const red = Color(0xFFE5252A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 35),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFE5252A),
                      Color(0xFFB51218),
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Profile
              Transform.translate(
                offset: const Offset(0, -35),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 55,
                      backgroundColor: Color(0xFFFFE5E5),
                      child: Icon(Icons.person, size: 60, color: red),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      controller.name.value,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      controller.email.value,
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 10),

                    Obx(() {
                      final role = controller.role.value;
                      final status = controller.memberStatus.value;

                      if (role == null || status == null) {
                        return const SizedBox();
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoleBadge(label: role.label, color: Colors.blue),
                          const SizedBox(width: 10),
                          Icon(status.icon,
                              size: 16, color: status.color),
                          const SizedBox(width: 4),
                          Text(
                            status.name,
                            style: TextStyle(color: status.color),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),

              // Settings
              Expanded(
                child: ListView(
                  padding:const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    AppMenuTile(
                      title: 'Buzzer',
                      icon: Icons.notifications_none,
                      onTap: () {},
                      trailing: Obx(
                            () => Switch(
                          value: controller.isEnabled.value,
                          onChanged: (v) =>
                          controller.isEnabled.value = v,
                        ),
                      ),
                    ),

                    AppMenuTile(
                      title: 'Manage Device',
                      icon: Icons.devices_outlined,
                      onTap: () => Get.to(
                            () => DeviceTeamMembersScreen(
                          deviceId: controller.deviceId.value,
                        ),
                      ),
                    ),

                    AppMenuTile(
                      title: 'Invite Others',
                      icon: Icons.person_add_alt_1_outlined,
                      onTap: () => InviteDialog.show(context),
                    ),

                    AppMenuTile(
                      title: 'Log Out',
                      icon: Icons.logout,
                      onTap: () async {
                        await AuthStorage.logout();
                        Get.offAllNamed(AppRoutes.login);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}