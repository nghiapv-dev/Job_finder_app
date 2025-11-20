import 'package:equatable/equatable.dart';

/// Trạng thái của Home screen
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái khởi tạo
class HomeInitial extends HomeState {
  const HomeInitial();
}

/// Trạng thái đang tải dữ liệu
class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Trạng thái đã tải dữ liệu thành công
class HomeLoaded extends HomeState {
  final List<JobModel> recommendedJobs;
  final List<TipModel> tips;
  final String selectedCategory;
  final List<String> savedJobIds;

  const HomeLoaded({
    required this.recommendedJobs,
    required this.tips,
    this.selectedCategory = 'Tất cả',
    this.savedJobIds = const [],
  });

  @override
  List<Object?> get props => [recommendedJobs, tips, selectedCategory, savedJobIds];

  /// Copy với các giá trị mới
  HomeLoaded copyWith({
    List<JobModel>? recommendedJobs,
    List<TipModel>? tips,
    String? selectedCategory,
    List<String>? savedJobIds,
  }) {
    return HomeLoaded(
      recommendedJobs: recommendedJobs ?? this.recommendedJobs,
      tips: tips ?? this.tips,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      savedJobIds: savedJobIds ?? this.savedJobIds,
    );
  }
}

/// Trạng thái lỗi
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Model cho công việc
class JobModel extends Equatable {
  final String id;
  final String title;
  final String company;
  final String location;
  final String type;
  final String salary;
  final String category;
  final String logoUrl;
  final bool isSaved;

  const JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.type,
    required this.salary,
    required this.category,
    this.logoUrl = '',
    this.isSaved = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        company,
        location,
        type,
        salary,
        category,
        logoUrl,
        isSaved,
      ];

  JobModel copyWith({
    String? id,
    String? title,
    String? company,
    String? location,
    String? type,
    String? salary,
    String? category,
    String? logoUrl,
    bool? isSaved,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      type: type ?? this.type,
      salary: salary ?? this.salary,
      category: category ?? this.category,
      logoUrl: logoUrl ?? this.logoUrl,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

/// Model cho mẹo/tips
class TipModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  const TipModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl = '',
  });

  @override
  List<Object?> get props => [id, title, description, imageUrl];
}
