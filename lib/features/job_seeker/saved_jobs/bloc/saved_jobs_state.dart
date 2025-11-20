import 'package:equatable/equatable.dart';

/// Trạng thái của Saved Jobs screen
abstract class SavedJobsState extends Equatable {
  const SavedJobsState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái khởi tạo
class SavedJobsInitial extends SavedJobsState {
  const SavedJobsInitial();
}

/// Trạng thái đang tải dữ liệu
class SavedJobsLoading extends SavedJobsState {
  const SavedJobsLoading();
}

/// Trạng thái đã tải dữ liệu thành công
class SavedJobsLoaded extends SavedJobsState {
  final List<SavedJobModel> savedJobs;
  final String searchQuery;
  final String selectedType;

  const SavedJobsLoaded({
    required this.savedJobs,
    this.searchQuery = '',
    this.selectedType = 'Tất cả',
  });

  @override
  List<Object?> get props => [savedJobs, searchQuery, selectedType];

  /// Copy với các giá trị mới
  SavedJobsLoaded copyWith({
    List<SavedJobModel>? savedJobs,
    String? searchQuery,
    String? selectedType,
  }) {
    return SavedJobsLoaded(
      savedJobs: savedJobs ?? this.savedJobs,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedType: selectedType ?? this.selectedType,
    );
  }

  /// Lấy danh sách đã lọc theo type và search
  List<SavedJobModel> get filteredJobs {
    var filtered = savedJobs;

    // Lọc theo loại công việc
    if (selectedType != 'Tất cả') {
      filtered = filtered.where((job) => job.type == selectedType).toList();
    }

    // Lọc theo search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((job) {
        final query = searchQuery.toLowerCase();
        return job.title.toLowerCase().contains(query) ||
            job.company.toLowerCase().contains(query) ||
            job.location.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }
}

/// Trạng thái lỗi
class SavedJobsError extends SavedJobsState {
  final String message;

  const SavedJobsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Trạng thái thành công sau khi xóa
class SavedJobRemoved extends SavedJobsState {
  final String message;
  final String jobTitle;

  const SavedJobRemoved({
    required this.message,
    required this.jobTitle,
  });

  @override
  List<Object?> get props => [message, jobTitle];
}

/// Trạng thái thành công sau khi thêm
class SavedJobAdded extends SavedJobsState {
  final String message;

  const SavedJobAdded(this.message);

  @override
  List<Object?> get props => [message];
}

/// Model cho công việc đã lưu
class SavedJobModel extends Equatable {
  final String id;
  final String title;
  final String company;
  final String location;
  final String type;
  final String salary;
  final String logo;
  final int color;
  final DateTime savedDate;

  const SavedJobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.type,
    required this.salary,
    required this.logo,
    required this.color,
    required this.savedDate,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        company,
        location,
        type,
        salary,
        logo,
        color,
        savedDate,
      ];

  SavedJobModel copyWith({
    String? id,
    String? title,
    String? company,
    String? location,
    String? type,
    String? salary,
    String? logo,
    int? color,
    DateTime? savedDate,
  }) {
    return SavedJobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      type: type ?? this.type,
      salary: salary ?? this.salary,
      logo: logo ?? this.logo,
      color: color ?? this.color,
      savedDate: savedDate ?? this.savedDate,
    );
  }
}
