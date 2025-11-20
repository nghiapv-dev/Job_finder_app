import 'package:equatable/equatable.dart';

/// Trạng thái của Applications screen
abstract class ApplicationState extends Equatable {
  const ApplicationState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái khởi tạo
class ApplicationInitial extends ApplicationState {
  const ApplicationInitial();
}

/// Trạng thái đang tải dữ liệu
class ApplicationLoading extends ApplicationState {
  const ApplicationLoading();
}

/// Trạng thái đã tải dữ liệu thành công
class ApplicationLoaded extends ApplicationState {
  final List<ApplicationModel> applications;
  final String selectedFilter;
  final String searchQuery;

  const ApplicationLoaded({
    required this.applications,
    this.selectedFilter = 'Tất cả',
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [applications, selectedFilter, searchQuery];

  /// Copy với các giá trị mới
  ApplicationLoaded copyWith({
    List<ApplicationModel>? applications,
    String? selectedFilter,
    String? searchQuery,
  }) {
    return ApplicationLoaded(
      applications: applications ?? this.applications,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  /// Lấy danh sách đã lọc theo filter và search
  List<ApplicationModel> get filteredApplications {
    var filtered = applications;

    // Lọc theo trạng thái
    if (selectedFilter != 'Tất cả') {
      filtered = filtered.where((app) => app.status == selectedFilter).toList();
    }

    // Lọc theo search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((app) {
        final query = searchQuery.toLowerCase();
        return app.jobTitle.toLowerCase().contains(query) ||
            app.company.toLowerCase().contains(query) ||
            app.location.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }
}

/// Trạng thái lỗi
class ApplicationError extends ApplicationState {
  final String message;

  const ApplicationError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Trạng thái thành công sau khi xóa
class ApplicationDeleted extends ApplicationState {
  final String message;

  const ApplicationDeleted(this.message);

  @override
  List<Object?> get props => [message];
}

/// Model cho đơn ứng tuyển
class ApplicationModel extends Equatable {
  final String id;
  final String jobTitle;
  final String company;
  final String logoUrl;
  final String status;
  final String statusColor;
  final String statusBgColor;
  final String statusMessage;
  final String salary;
  final String type;
  final String location;
  final DateTime appliedDate;

  const ApplicationModel({
    required this.id,
    required this.jobTitle,
    required this.company,
    required this.logoUrl,
    required this.status,
    required this.statusColor,
    required this.statusBgColor,
    required this.statusMessage,
    required this.salary,
    required this.type,
    required this.location,
    required this.appliedDate,
  });

  @override
  List<Object?> get props => [
        id,
        jobTitle,
        company,
        logoUrl,
        status,
        statusColor,
        statusBgColor,
        statusMessage,
        salary,
        type,
        location,
        appliedDate,
      ];

  ApplicationModel copyWith({
    String? id,
    String? jobTitle,
    String? company,
    String? logoUrl,
    String? status,
    String? statusColor,
    String? statusBgColor,
    String? statusMessage,
    String? salary,
    String? type,
    String? location,
    DateTime? appliedDate,
  }) {
    return ApplicationModel(
      id: id ?? this.id,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      logoUrl: logoUrl ?? this.logoUrl,
      status: status ?? this.status,
      statusColor: statusColor ?? this.statusColor,
      statusBgColor: statusBgColor ?? this.statusBgColor,
      statusMessage: statusMessage ?? this.statusMessage,
      salary: salary ?? this.salary,
      type: type ?? this.type,
      location: location ?? this.location,
      appliedDate: appliedDate ?? this.appliedDate,
    );
  }
}
