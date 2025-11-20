import 'package:equatable/equatable.dart';

/// Các sự kiện cho Applications screen
abstract class ApplicationEvent extends Equatable {
  const ApplicationEvent();

  @override
  List<Object?> get props => [];
}

/// Sự kiện load danh sách đơn ứng tuyển
class LoadApplications extends ApplicationEvent {
  const LoadApplications();
}

/// Sự kiện refresh danh sách đơn ứng tuyển
class RefreshApplications extends ApplicationEvent {
  const RefreshApplications();
}

/// Sự kiện lọc đơn ứng tuyển theo trạng thái
class FilterApplicationsByStatus extends ApplicationEvent {
  final String status;

  const FilterApplicationsByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

/// Sự kiện tìm kiếm đơn ứng tuyển
class SearchApplications extends ApplicationEvent {
  final String query;

  const SearchApplications(this.query);

  @override
  List<Object?> get props => [query];
}

/// Sự kiện xóa đơn ứng tuyển
class DeleteApplication extends ApplicationEvent {
  final String applicationId;

  const DeleteApplication(this.applicationId);

  @override
  List<Object?> get props => [applicationId];
}

/// Sự kiện cập nhật trạng thái đơn ứng tuyển
class UpdateApplicationStatus extends ApplicationEvent {
  final String applicationId;
  final String newStatus;

  const UpdateApplicationStatus({
    required this.applicationId,
    required this.newStatus,
  });

  @override
  List<Object?> get props => [applicationId, newStatus];
}
