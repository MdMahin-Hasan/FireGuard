import 'package:flutter/material.dart';

import '../../../data/model/membership_model.dart';
import 'badge.dart';

class MemberTile extends StatelessWidget {
  final DeviceMember member;
  final VoidCallback? onDelete;

  const MemberTile({
    super.key,
    required this.member,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final role = member.role;
    final status = member.status;

    final isOwner = role.label.toLowerCase() == 'owner';

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AVATAR
            CircleAvatar(
              radius: 22,
              backgroundColor: role.color[100],
              child: Text(
                member.user.initial,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: role.color[800],
                ),
              ),
            ),

            const SizedBox(width: 12),

            // MEMBER INFORMATION
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAME + ROLE
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          member.user.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      RoleBadge(
                        label: role.label,
                        color: role.color,
                      ),
                    ],
                  ),

                  const SizedBox(height: 3),

                  // EMAIL
                  Text(
                    member.user.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 5),

                  // STATUS + REMOVE
                  Row(
                    children: [
                      Icon(
                        status.icon,
                        size: 14,
                        color: status.color,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        status.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: status.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      // REMOVE BUTTON
                      if (!isOwner && onDelete != null) ...[
                        const Spacer(),

                        TextButton.icon(
                          onPressed: onDelete,
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 16,
                          ),
                          label: const Text('Remove'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}