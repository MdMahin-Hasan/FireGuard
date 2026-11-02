import 'package:flutter/material.dart';

import '../../../data/model/membership_model.dart';
import '../controller/team_memcontroller.dart';
import '../widget/membertile.dart';

class DeviceTeamMembersScreen extends StatefulWidget {
  final String deviceId;

  const DeviceTeamMembersScreen({
    super.key,
    required this.deviceId,
  });

  @override
  State<DeviceTeamMembersScreen> createState() =>
      _DeviceTeamMembersScreenState();
}

class _DeviceTeamMembersScreenState
    extends State<DeviceTeamMembersScreen> {
  late final TeamMembersController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TeamMembersController()
      ..load(widget.deviceId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Team Members (${widget.deviceId})',
        ),
        elevation: 0,
      ),

      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          switch (_controller.status) {
            case LoadStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case LoadStatus.error:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Failed to load members:\n${_controller.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              );

            case LoadStatus.success:
              final members = _controller.members;

              if (members.isEmpty) {
                return const Center(
                  child: Text(
                    'No team members found for this device.',
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () =>
                    _controller.refresh(widget.deviceId),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: members.length,

                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),

                  itemBuilder: (_, index) {
                    final member = members[index];

                    return MemberTile(
                      member: member,
                      onDelete: () {
                        _showDeleteDialog(member);
                      },
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }

  void _showDeleteDialog(DeviceMember member) {
    // Capture the messenger tied to the SCREEN's context now, while it's
    // definitely valid — not the dialog's context, which gets torn down
    // as soon as we pop it (this was the reason no snackbar showed on web).
    final messenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remove Member?'),

          content: Text(
            'Are you sure you want to remove '
                '${member.user.name} from this device?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),

            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                try {
                  await _controller.deleteMember(member);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Member removed')),
                  );
                } catch (_) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        _controller.error ?? 'Failed to remove member',
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                'Remove',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}