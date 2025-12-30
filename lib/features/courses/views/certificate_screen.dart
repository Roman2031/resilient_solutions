import 'package:flutter/material.dart';
import '../widgets/certificate_card.dart';

/// Certificate Screen
/// Displays earned certificates with preview and download options
class CertificateScreen extends StatelessWidget {
  const CertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from provider
    final certificates = _getMockCertificates();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Certificates'),
      ),
      body: certificates.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.workspace_premium_outlined,
                        size: 100,
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'No Certificates Yet',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Complete courses to earn certificates',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.school),
                      label: const Text('Browse Courses'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: certificates.length,
              itemBuilder: (context, index) {
                final cert = certificates[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CertificateCard(
                    certificateId: cert['id'],
                    courseName: cert['courseName'],
                    completionDate: cert['completionDate'],
                    score: cert['score'],
                    onView: () => _viewCertificate(context, cert),
                    onDownload: () => _downloadCertificate(context, cert),
                    onShare: () => _shareCertificate(context, cert),
                  ),
                );
              },
            ),
    );
  }

  // Mock data - replace with actual provider data
  List<Map<String, dynamic>> _getMockCertificates() {
    return [
      // Uncomment to show mock certificates
      // {
      //   'id': 'CERT-001',
      //   'courseName': 'Introduction to Flutter',
      //   'completionDate': DateTime(2025, 1, 15),
      //   'score': 95,
      // },
      // {
      //   'id': 'CERT-002',
      //   'courseName': 'Advanced Dart Programming',
      //   'completionDate': DateTime(2025, 1, 10),
      //   'score': 88,
      // },
    ];
  }

  void _viewCertificate(BuildContext context, Map<String, dynamic> cert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(cert['courseName']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.workspace_premium,
              size: 100,
              color: Colors.amber,
            ),
            const SizedBox(height: 16),
            Text(
              'Certificate of Completion',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'ID: ${cert['id']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _downloadCertificate(context, cert);
            },
            icon: const Icon(Icons.download),
            label: const Text('Download'),
          ),
        ],
      ),
    );
  }

  void _downloadCertificate(BuildContext context, Map<String, dynamic> cert) {
    // TODO: Implement actual certificate download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading certificate ${cert['id']}...'),
      ),
    );
  }

  void _shareCertificate(BuildContext context, Map<String, dynamic> cert) {
    // TODO: Implement certificate sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing certificate ${cert['id']}...'),
      ),
    );
  }
}
