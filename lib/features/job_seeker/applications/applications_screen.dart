import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../shared/widgets/custom_bottom_nav_bar.dart';
import 'bloc/bloc.dart';

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ApplicationBloc()..add(const LoadApplications()),
      child: const ApplicationsScreenView(),
    );
  }
}

class ApplicationsScreenView extends StatefulWidget {
  const ApplicationsScreenView({super.key});

  @override
  State<ApplicationsScreenView> createState() => _ApplicationsScreenViewState();
}

class _ApplicationsScreenViewState extends State<ApplicationsScreenView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<ApplicationBloc>().add(SearchApplications(query));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApplicationBloc, ApplicationState>(
      listener: (context, state) {
        if (state is ApplicationDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is ApplicationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: _buildAppBar(),
        body: BlocBuilder<ApplicationBloc, ApplicationState>(
          builder: (context, state) {
            if (state is ApplicationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ApplicationError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ApplicationBloc>().add(const LoadApplications());
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }

            if (state is! ApplicationLoaded) {
              return const SizedBox.shrink();
            }

            return _buildContent(context, state);
          },
        ),
        bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(12.0),
          child: CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Icon(
              Icons.description,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        title: const Text(
          'Đơn ứng tuyển',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: AppColors.primary),
            onPressed: () {
              context.push('/saved-jobs');
            },
          ),
        ],
      );
  }

  Widget _buildContent(BuildContext context, ApplicationLoaded state) {
    final filteredApps = state.filteredApplications;

    return Column(
      children: [
        // Search Bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        // Filter Chips
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(context, state, 'Tất cả'),
                const SizedBox(width: 8),
                _buildFilterChip(context, state, 'Đã chấp nhận'),
                const SizedBox(width: 8),
                _buildFilterChip(context, state, 'Phỏng vấn'),
                const SizedBox(width: 8),
                _buildFilterChip(context, state, 'Từ chối'),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Applications List
        Expanded(
          child: filteredApps.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Không tìm thấy đơn ứng tuyển',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredApps.length,
                  itemBuilder: (context, index) {
                    final application = filteredApps[index];
                    return _buildApplicationCard(context, application);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(BuildContext context, ApplicationLoaded state, String label) {
    final isSelected = state.selectedFilter == label;
    
    return GestureDetector(
      onTap: () {
        context.read<ApplicationBloc>().add(FilterApplicationsByStatus(label));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationCard(BuildContext context, ApplicationModel application) {
    // Parse color từ string
    final statusColor = Color(int.parse(application.statusColor));
    final statusBgColor = Color(int.parse(application.statusBgColor));
    
    return GestureDetector(
      onTap: () {
        context.push('/application-detail', extra: {
          'id': application.id,
          'jobTitle': application.jobTitle,
          'company': application.company,
          'location': application.location,
          'type': application.type,
          'salary': application.salary,
          'status': application.status,
          'statusMessage': application.statusMessage,
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Company Logo
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _getLogoColor(application.company),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: _getCompanyIcon(application.company),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Job Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          application.jobTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          application.company,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  application.statusMessage,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getLogoColor(String company) {
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

  Widget _getCompanyIcon(String company) {
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
}
