import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../data/models/admin_models.dart';

/// System Health Indicator Widget
class SystemHealthIndicator extends StatelessWidget {
  final SystemHealth health;

  const SystemHealthIndicator({
    super.key,
    required this.health,
  });

  @override
  Widget build(BuildContext context) {
    final status = health.status.toLowerCase();
    final color = _getStatusColor(status);
    
    return Card(
      elevation: 2,
      color: const Color(0xff023C7B),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'System Health',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getStatusIcon(status),
                        color: color,
                        size: 16.sp,
                      ),
                      Gap(6.w),
                      Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(16.h),
            
            // Metrics
            _buildMetric('CPU Usage', health.cpuUsage, '%'),
            Gap(8.h),
            _buildMetric('Memory Usage', health.memoryUsage, '%'),
            Gap(8.h),
            _buildMetric('Disk Usage', health.diskUsage, '%'),
            
            if (health.errorCount > 0) ...[
              Gap(12.h),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 16.sp,
                    ),
                    Gap(8.w),
                    Text(
                      '${health.errorCount} Error${health.errorCount > 1 ? 's' : ''} Detected',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            Gap(12.h),
            Text(
              'Last checked: ${_formatTime(health.lastChecked)}',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, double value, String unit) {
    final percentage = value;
    final color = percentage > 80 ? Colors.red : percentage > 60 ? Colors.orange : Colors.green;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white70,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}$unit',
              style: TextStyle(
                fontSize: 12.sp,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Gap(4.h),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.white10,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'healthy':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'healthy':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'critical':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}
