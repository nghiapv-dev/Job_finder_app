import 'package:equatable/equatable.dart';

/// Các sự kiện cho Home screen
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Sự kiện load dữ liệu ban đầu
class LoadHomeData extends HomeEvent {
  const LoadHomeData();
}

/// Sự kiện refresh dữ liệu
class RefreshHomeData extends HomeEvent {
  const RefreshHomeData();
}

/// Sự kiện tìm kiếm công việc
class SearchJobs extends HomeEvent {
  final String query;

  const SearchJobs(this.query);

  @override
  List<Object?> get props => [query];
}

/// Sự kiện lọc công việc theo danh mục
class FilterJobsByCategory extends HomeEvent {
  final String category;

  const FilterJobsByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

/// Sự kiện lưu/bỏ lưu công việc
class ToggleSaveJob extends HomeEvent {
  final String jobId;

  const ToggleSaveJob(this.jobId);

  @override
  List<Object?> get props => [jobId];
}
