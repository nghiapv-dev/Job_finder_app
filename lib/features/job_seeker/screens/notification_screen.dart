import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Notification',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationItem(
            icon: Icons.check_circle,
            iconColor: const Color(0xFF3366FF),
            title: 'Your application to Apple Company has been read',
            time: '17:00',
            isRead: true,
          ),
          const SizedBox(height: 12),
          _buildNotificationItem(
            icon: Icons.check_circle,
            iconColor: const Color(0xFF3366FF),
            title: 'New job available !',
            time: '10:00',
            isRead: true,
          ),
          const SizedBox(height: 12),
          _buildNotificationItem(
            icon: Icons.business,
            iconColor: Colors.transparent,
            title: 'New company has been joined (NEW)',
            time: '13:00',
            isRead: false,
            companyLogo: Icons.apps,
          ),
          const SizedBox(height: 12),
          _buildNotificationItem(
            icon: Icons.celebration,
            iconColor: const Color(0xFFFFB800),
            title: 'Congratulations, your application on Google has been accepted',
            time: '12:00',
            isRead: false,
          ),
          const SizedBox(height: 12),
          _buildNotificationItem(
            icon: Icons.apple,
            iconColor: Colors.transparent,
            title: 'New company has been joined (NEW)',
            time: '13:00',
            isRead: false,
            companyLogo: Icons.apple,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String time,
    required bool isRead,
    IconData? companyLogo,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor == Colors.transparent
                  ? Colors.grey[200]
                  : iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              companyLogo ?? icon,
              color: iconColor == Colors.transparent
                  ? Colors.black
                  : iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (isRead)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF3366FF),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
