import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../shared/widgets/custom_bottom_nav_bar.dart';

class JobRecommendationScreen extends StatefulWidget {
  const JobRecommendationScreen({super.key});

  @override
  State<JobRecommendationScreen> createState() => _JobRecommendationScreenState();
}

class _JobRecommendationScreenState extends State<JobRecommendationScreen> {
  String _selectedFilter = 'All Job';

  final List<Map<String, dynamic>> _jobs = [
    {
      'title': 'UI/UX Designer',
      'company': 'AirBNB',
      'location': 'United States',
      'type': 'Full Time',
      'salary': '\$2,350',
      'logo': 'airbnb',
      'color': const Color(0xFFFF5A5F),
      'isBookmarked': true,
    },
    {
      'title': 'Financial Planner',
      'company': 'Twitter',
      'location': 'United Kingdom',
      'type': 'Part Time',
      'salary': '\$2,240',
      'logo': 'twitter',
      'color': const Color(0xFF1DA1F2),
      'isBookmarked': false,
    },
    {
      'title': 'Data Engineer',
      'company': 'LinkedIn',
      'location': 'Singapore',
      'type': 'Full Time',
      'salary': '\$3,120',
      'logo': 'linkedin',
      'color': const Color(0xFF0A66C2),
      'isBookmarked': false,
    },
    {
      'title': 'Product Designer',
      'company': 'CocaCola',
      'location': 'Russia',
      'type': 'Part Time',
      'salary': '\$2,780',
      'logo': 'cocacola',
      'color': const Color(0xFFED1C16),
      'isBookmarked': true,
    },
    {
      'title': 'Music Auditory',
      'company': 'Spotify',
      'location': 'French',
      'type': 'Freelance',
      'salary': '\$3,250',
      'logo': 'spotify',
      'color': const Color(0xFF1DB954),
      'isBookmarked': false,
    },
  ];

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
          'Job Recommendation',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search and Filter section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey[400], size: 20),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.tune,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          
          // Filter chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 20, bottom: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All Job'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Writer'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Design'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Finance'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Programming'),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ),

          // Job list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _jobs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildJobCard(_jobs[index]),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    return GestureDetector(
      onTap: () {
        context.push('/job-detail', extra: job);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Company logo
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: job['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: _getCompanyIcon(job['logo'], job['color']),
              ),
            ),
            const SizedBox(width: 12),
            
            // Job details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job['title'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    job['company'],
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        job['location'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '• ${job['type']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Bookmark and salary
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  job['isBookmarked'] ? Icons.bookmark : Icons.bookmark_border,
                  color: job['isBookmarked'] ? AppColors.primary : Colors.grey[400],
                  size: 20,
                ),
                const SizedBox(height: 16),
                Text(
                  job['salary'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCompanyIcon(String logo, Color color) {
    IconData iconData;
    switch (logo) {
      case 'airbnb':
        iconData = Icons.home_outlined;
        break;
      case 'twitter':
        iconData = Icons.flight_outlined;
        break;
      case 'linkedin':
        iconData = Icons.business_outlined;
        break;
      case 'cocacola':
        iconData = Icons.local_drink_outlined;
        break;
      case 'spotify':
        iconData = Icons.music_note_outlined;
        break;
      default:
        iconData = Icons.business;
    }
    
    return Icon(
      iconData,
      color: color,
      size: 28,
    );
  }

}
