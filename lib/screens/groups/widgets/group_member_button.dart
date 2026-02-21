import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/providers/groups_provider.dart';
import 'package:paylent/screens/groups/widgets/group_members_sheet.dart';

class GroupMemberButton extends ConsumerWidget {
  const GroupMemberButton({
    required this.groupId,
    super.key,
  });

  final String groupId;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final group = ref.watch(groupsProvider)
        .firstWhere((final g) => g.id == groupId);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            barrierColor: Colors.black54,
            builder: (final _) => GroupMembersSheet(groupId: groupId),
          );
        },
        child: Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade900.withValues(alpha: .62),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.group,
                size: 16,
                color: Colors.white.withValues(alpha: .9),
              ),
              const SizedBox(width: 6),
              Text(
                group.participantIds.length == 1
                    ? '1 Member'
                    : '${group.participantIds.length} Members',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '+',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}