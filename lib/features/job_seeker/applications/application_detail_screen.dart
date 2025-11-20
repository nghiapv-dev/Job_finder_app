import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class ApplicationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> applicationData;

  const ApplicationDetailScreen({
    super.key,
    required this.applicationData,
  });

  @override
  Widget build(BuildContext context) {
    final status = applicationData['status'] ?? 'Pending';
    
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Applications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _getLogoColor(applicationData['company']),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: _getCompanyIcon(applicationData['company']),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          applicationData['jobTitle'] ?? 'Job Title',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          applicationData['company'] ?? 'Company',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Status Badge
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: applicationData['statusBgColor'],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    _getStatusText(status),
                    style: TextStyle(
                      color: applicationData['statusColor'],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Job Details
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildDetailRow(
                    'Salary',
                    applicationData['salary'] ?? '\$2,350',
                    AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    'Type',
                    applicationData['type'] ?? 'Full Time',
                    AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    'Location',
                    applicationData['location'] ?? 'United States',
                    AppColors.primary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Message Content
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hi, Adam Smith,',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getMessageContent(status),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Best Regards,\nHiring Manager',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(context, status),
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Color _getLogoColor(String? company) {
    if (company == null) return Colors.grey.withOpacity(0.1);
    
    switch (company.toLowerCase()) {
      case 'airbnb':
        return const Color(0xFFFF5A5F).withOpacity(0.1);
      case 'twitter':
        return const Color(0xFF1DA1F2).withOpacity(0.1);
      case 'facebook':
        return const Color(0xFF1877F2).withOpacity(0.1);
      case 'google':
        return const Color(0xFF4285F4).withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }

  Widget _getCompanyIcon(String? company) {
    if (company == null) {
      return const Icon(Icons.business, color: Colors.grey, size: 28);
    }

    IconData iconData;
    Color iconColor;

    switch (company.toLowerCase()) {
      case 'airbnb':
        iconData = Icons.home;
        iconColor = const Color(0xFFFF5A5F);
        break;
      case 'twitter':
        iconData = Icons.tag;
        iconColor = const Color(0xFF1DA1F2);
        break;
      case 'facebook':
        iconData = Icons.facebook;
        iconColor = const Color(0xFF1877F2);
        break;
      case 'google':
        iconData = Icons.search;
        iconColor = const Color(0xFF4285F4);
        break;
      default:
        iconData = Icons.business;
        iconColor = Colors.grey;
    }

    return Icon(iconData, color: iconColor, size: 28);
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'Interview':
        return 'Scheduled for Interview';
      case 'Accepted':
        return 'Accepted';
      case 'Rejected':
        return 'Rejected';
      case 'Pending':
      default:
        return 'Pending';
    }
  }

  String _getMessageContent(String status) {
    switch (status) {
      case 'Interview':
        return 'Congratulations!\n\nAfter reviewing various internal discussions regarding this job ad, we would like to invite you for an interview on Monday, January 17, 2022 at 10.00 am.';
      
      case 'Accepted':
        return 'Congratulations!\n\nAfter we reviewed your application for the position of UI/UX Designer, we congratulate you for being a part of us. After this you will be contacted personally by our team. Thank You...\n\nGreetings,\nHiring a manager';
      
      case 'Rejected':
        return 'We are sorry,\n\nAfter we have had an in-depth discussion about your application, we would like to convey that your profile is not suitable and you cannot become part of us. Good luck with your other applications.';
      
      case 'Pending':
      default:
        return 'Waiting for review ...';
    }
  }

  Widget _buildBottomButton(BuildContext context, String status) {
    String buttonText;
    VoidCallback? onPressed;

    switch (status) {
      case 'Interview':
        buttonText = 'Join Interview';
        onPressed = () {
          // Handle join interview
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening interview link...')),
          );
        };
        break;
      
      case 'Accepted':
        buttonText = 'Send Message to Recruiter Now';
        onPressed = () {
          // Handle send message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening chat with recruiter...')),
          );
        };
        break;
      
      case 'Rejected':
        buttonText = 'Discover another job';
        onPressed = () {
          Navigator.pop(context);
        };
        break;
      
      case 'Pending':
      default:
        buttonText = 'Waiting for review';
        onPressed = null; // Disabled
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null ? AppColors.primary : Colors.grey[300],
          disabledBackgroundColor: Colors.grey[300],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: onPressed != null ? Colors.white : Colors.grey[600],
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
