import 'package:flutter/material.dart';

/// Certificate Card Widget
/// Displays a certificate with preview and download options
class CertificateCard extends StatelessWidget {
  final String certificateId;
  final String courseName;
  final DateTime completionDate;
  final String? certificateUrl;
  final int? score;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;
  final VoidCallback? onView;

  const CertificateCard({
    super.key,
    required this.certificateId,
    required this.courseName,
    required this.completionDate,
    this.certificateUrl,
    this.score,
    this.onDownload,
    this.onShare,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Certificate preview/image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.7),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Decorative pattern
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.1,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage('assets/pngs/certificate_pattern.png'),
                          fit: BoxFit.cover,
                          onError: (_, __) {},
                        ),
                      ),
                    ),
                  ),
                ),

                // Certificate icon
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.workspace_premium,
                        size: 64,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Certificate of Completion',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),

                // Score badge (if available)
                if (score != null)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$score%',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Certificate details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Completed: ${_formatDate(completionDate)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.confirmation_number,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'ID: $certificateId',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    if (onView != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onView,
                          icon: const Icon(Icons.visibility, size: 18),
                          label: const Text('View'),
                        ),
                      ),
                    if (onView != null && (onDownload != null || onShare != null))
                      const SizedBox(width: 8),
                    if (onDownload != null)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onDownload,
                          icon: const Icon(Icons.download, size: 18),
                          label: const Text('Download'),
                        ),
                      ),
                    if (onShare != null && onDownload != null)
                      const SizedBox(width: 8),
                    if (onShare != null)
                      IconButton(
                        onPressed: onShare,
                        icon: const Icon(Icons.share),
                        tooltip: 'Share',
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
