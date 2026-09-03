import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Work Status Enum & Extensions (Single Source of Truth)
// ─────────────────────────────────────────────────────────────────────────────
enum WorkStatus { inProgress, pending, onHold, completed }

typedef JobStatus = WorkStatus;

extension WorkStatusX on WorkStatus {
  String get label {
    switch (this) {
      case WorkStatus.inProgress:
        return 'In Progress';
      case WorkStatus.pending:
        return 'Pending';
      case WorkStatus.onHold:
        return 'On Hold';
      case WorkStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case WorkStatus.inProgress:
        return AppColors.blue;
      case WorkStatus.pending:
        return AppColors.amber;
      case WorkStatus.onHold:
        return AppColors.muted;
      case WorkStatus.completed:
        return AppColors.green;
    }
  }

  IconData get icon {
    switch (this) {
      case WorkStatus.inProgress:
        return Icons.pending_actions_outlined;
      case WorkStatus.pending:
        return Icons.hourglass_empty_rounded;
      case WorkStatus.onHold:
        return Icons.pause_circle_outline;
      case WorkStatus.completed:
        return Icons.check_circle_outline;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Shared Status Badge Widget
// ─────────────────────────────────────────────────────────────────────────────
class WorkStatusBadge extends StatelessWidget {
  final WorkStatus status;
  final bool isPill;

  const WorkStatusBadge({super.key, required this.status, this.isPill = false});

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    final label = status.label;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isPill ? 10 : 8,
        vertical: isPill ? 5 : 3.5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(isPill ? 20 : 16),
        border: Border.all(color: color.withValues(alpha: 0.45), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: isPill ? 11.5 : 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Shared Status Picker Bottom Sheet (Centralized, No bottom SnackBar popup)
// ─────────────────────────────────────────────────────────────────────────────
Future<WorkStatus?> showWorkStatusModalSheet({
  required BuildContext context,
  required String workId,
  required WorkStatus currentStatus,
  required ValueChanged<WorkStatus> onStatusSelected,
}) {
  return showModalBottomSheet<WorkStatus>(
    context: context,
    backgroundColor: AppColors.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Update Status ($workId)',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.muted,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...WorkStatus.values.map((status) {
                final isSelected = currentStatus == status;
                final color = status.color;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.pop(ctx, status);
                      onStatusSelected(status);
                    },
                    child: Ink(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withValues(alpha: 0.16)
                            : AppColors.inputFill,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? color : AppColors.divider,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(status.icon, color: color, size: 22),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              status.label,
                              style: TextStyle(
                                color: isSelected ? color : AppColors.white,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_circle, color: color, size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}
