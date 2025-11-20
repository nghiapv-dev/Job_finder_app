import 'package:equatable/equatable.dart';

/// Các sự kiện cho Saved Jobs screen
abstract class SavedJobsEvent extends Equatable {
  const SavedJobsEvent();

  @override
  List<Object?> get props => [];
}

/// Sự kiện load danh sách công việc đã lưu
class LoadSavedJobs extends SavedJobsEvent {
  const LoadSavedJobs();
}

/// Sự kiện refresh danh sách
class RefreshSavedJobs extends SavedJobsEvent {
  const RefreshSavedJobs();
}

/// Sự kiện thêm công việc vào danh sách đã lưu
class AddSavedJob extends SavedJobsEvent {
  final String jobId;
  final String title;
  final String company;
  final String location;
  final String type;
  final String salary;

  const AddSavedJob({
    required this.jobId,
    required this.title,
    required this.company,
    required this.location,
    required this.type,
    required this.salary,
  });

  @override
  List<Object?> get props => [jobId, title, company, location, type, salary];
}

/// Sự kiện xóa công việc khỏi danh sách đã lưu
class RemoveSavedJob extends SavedJobsEvent {
  final String jobId;

  const RemoveSavedJob(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

/// Sự kiện tìm kiếm công việc đã lưu
class SearchSavedJobs extends SavedJobsEvent {
  final String query;

  const SearchSavedJobs(this.query);

  @override
  List<Object?> get props => [query];
}

/// Sự kiện lọc theo loại công việc
class FilterSavedJobsByType extends SavedJobsEvent {
  final String type;

  const FilterSavedJobsByType(this.type);

  @override
  List<Object?> get props => [type];
}
