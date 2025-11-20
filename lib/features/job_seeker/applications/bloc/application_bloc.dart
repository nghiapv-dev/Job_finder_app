import 'package:flutter_bloc/flutter_bloc.dart';
import 'application_event.dart';
import 'application_state.dart';

/// BLoC quản lý logic cho Applications screen
class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  ApplicationBloc() : super(const ApplicationInitial()) {
    on<LoadApplications>(_onLoadApplications);
    on<RefreshApplications>(_onRefreshApplications);
    on<FilterApplicationsByStatus>(_onFilterApplicationsByStatus);
    on<SearchApplications>(_onSearchApplications);
    on<DeleteApplication>(_onDeleteApplication);
    on<UpdateApplicationStatus>(_onUpdateApplicationStatus);
  }

  /// Xử lý sự kiện load danh sách đơn ứng tuyển
  Future<void> _onLoadApplications(
    LoadApplications event,
    Emitter<ApplicationState> emit,
  ) async {
    emit(const ApplicationLoading());

    try {
      // TODO: Gọi API hoặc repository để lấy dữ liệu
      // Tạm thời dùng dữ liệu mẫu
      await Future.delayed(const Duration(seconds: 1));

      final applications = _getDummyApplications();

      emit(ApplicationLoaded(applications: applications));
    } catch (e) {
      emit(ApplicationError('Không thể tải dữ liệu: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện refresh danh sách
  Future<void> _onRefreshApplications(
    RefreshApplications event,
    Emitter<ApplicationState> emit,
  ) async {
    final currentState = state;

    try {
      // TODO: Gọi API để refresh dữ liệu
      await Future.delayed(const Duration(milliseconds: 500));

      final applications = _getDummyApplications();

      if (currentState is ApplicationLoaded) {
        emit(currentState.copyWith(applications: applications));
      } else {
        emit(ApplicationLoaded(applications: applications));
      }
    } catch (e) {
      emit(ApplicationError('Không thể làm mới dữ liệu: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện lọc theo trạng thái
  Future<void> _onFilterApplicationsByStatus(
    FilterApplicationsByStatus event,
    Emitter<ApplicationState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ApplicationLoaded) return;

    emit(currentState.copyWith(selectedFilter: event.status));
  }

  /// Xử lý sự kiện tìm kiếm
  Future<void> _onSearchApplications(
    SearchApplications event,
    Emitter<ApplicationState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ApplicationLoaded) return;

    emit(currentState.copyWith(searchQuery: event.query));
  }

  /// Xử lý sự kiện xóa đơn ứng tuyển
  Future<void> _onDeleteApplication(
    DeleteApplication event,
    Emitter<ApplicationState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ApplicationLoaded) return;

    try {
      // TODO: Gọi API để xóa đơn ứng tuyển
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedApplications = currentState.applications
          .where((app) => app.id != event.applicationId)
          .toList();

      emit(currentState.copyWith(applications: updatedApplications));
      
      // Emit trạng thái thành công
      emit(const ApplicationDeleted('Đã xóa đơn ứng tuyển'));
      
      // Quay lại trạng thái loaded
      emit(currentState.copyWith(applications: updatedApplications));
    } catch (e) {
      emit(ApplicationError('Không thể xóa đơn ứng tuyển: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện cập nhật trạng thái đơn ứng tuyển
  Future<void> _onUpdateApplicationStatus(
    UpdateApplicationStatus event,
    Emitter<ApplicationState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ApplicationLoaded) return;

    try {
      // TODO: Gọi API để cập nhật trạng thái
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedApplications = currentState.applications.map((app) {
        if (app.id == event.applicationId) {
          return app.copyWith(
            status: event.newStatus,
            statusMessage: _getStatusMessage(event.newStatus),
          );
        }
        return app;
      }).toList();

      emit(currentState.copyWith(applications: updatedApplications));
    } catch (e) {
      emit(ApplicationError('Không thể cập nhật trạng thái: ${e.toString()}'));
    }
  }

  /// Lấy message cho trạng thái
  String _getStatusMessage(String status) {
    switch (status) {
      case 'Phỏng vấn':
        return 'Đã lên lịch phỏng vấn';
      case 'Đang chờ':
        return 'Đang chờ xử lý';
      case 'Từ chối':
        return 'Đã từ chối';
      case 'Đã chấp nhận':
        return 'Đã chấp nhận đơn';
      default:
        return '';
    }
  }

  /// Dữ liệu mẫu cho đơn ứng tuyển
  List<ApplicationModel> _getDummyApplications() {
    final now = DateTime.now();
    
    return [
      ApplicationModel(
        id: '1',
        jobTitle: 'Thiết kế UI/UX',
        company: 'AirBNB',
        logoUrl: 'https://logo.clearbit.com/airbnb.com',
        status: 'Phỏng vấn',
        statusColor: '0xFF3366FF',
        statusBgColor: '0xFFE8F0FF',
        statusMessage: 'Đã lên lịch phỏng vấn',
        salary: '\$2,350',
        type: 'Toàn thời gian',
        location: 'Hoa Kỳ',
        appliedDate: now.subtract(const Duration(days: 5)),
      ),
      ApplicationModel(
        id: '2',
        jobTitle: 'Thiết kế hình ảnh',
        company: 'Twitter',
        logoUrl: 'https://logo.clearbit.com/twitter.com',
        status: 'Đang chờ',
        statusColor: '0xFFFF9228',
        statusBgColor: '0xFFFFF4E8',
        statusMessage: 'Đang chờ xử lý',
        salary: '\$1,480',
        type: 'Tự do',
        location: 'Singapore',
        appliedDate: now.subtract(const Duration(days: 3)),
      ),
      ApplicationModel(
        id: '3',
        jobTitle: 'Thiết kế sản phẩm',
        company: 'Facebook',
        logoUrl: 'https://logo.clearbit.com/facebook.com',
        status: 'Từ chối',
        statusColor: '0xFFFF4747',
        statusBgColor: '0xFFFFE8E8',
        statusMessage: 'Đã từ chối',
        salary: '\$2,160',
        type: 'Bán thời gian',
        location: 'Canada',
        appliedDate: now.subtract(const Duration(days: 10)),
      ),
      ApplicationModel(
        id: '4',
        jobTitle: 'Thiết kế UX cấp cao',
        company: 'Google',
        logoUrl: 'https://logo.clearbit.com/google.com',
        status: 'Đã chấp nhận',
        statusColor: '0xFF00C48C',
        statusBgColor: '0xFFE8FFF7',
        statusMessage: 'Đã chấp nhận đơn',
        salary: '\$2,350',
        type: 'Toàn thời gian',
        location: 'Hoa Kỳ',
        appliedDate: now.subtract(const Duration(days: 15)),
      ),
      ApplicationModel(
        id: '5',
        jobTitle: 'Lập trình viên Flutter',
        company: 'Microsoft',
        logoUrl: 'https://logo.clearbit.com/microsoft.com',
        status: 'Phỏng vấn',
        statusColor: '0xFF3366FF',
        statusBgColor: '0xFFE8F0FF',
        statusMessage: 'Đã lên lịch phỏng vấn',
        salary: '\$3,200',
        type: 'Toàn thời gian',
        location: 'Việt Nam',
        appliedDate: now.subtract(const Duration(days: 2)),
      ),
    ];
  }
}
