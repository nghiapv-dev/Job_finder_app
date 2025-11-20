import 'package:flutter_bloc/flutter_bloc.dart';
import 'saved_jobs_event.dart';
import 'saved_jobs_state.dart';

/// BLoC quản lý logic cho Saved Jobs screen
class SavedJobsBloc extends Bloc<SavedJobsEvent, SavedJobsState> {
  SavedJobsBloc() : super(const SavedJobsInitial()) {
    on<LoadSavedJobs>(_onLoadSavedJobs);
    on<RefreshSavedJobs>(_onRefreshSavedJobs);
    on<AddSavedJob>(_onAddSavedJob);
    on<RemoveSavedJob>(_onRemoveSavedJob);
    on<SearchSavedJobs>(_onSearchSavedJobs);
    on<FilterSavedJobsByType>(_onFilterSavedJobsByType);
  }

  /// Xử lý sự kiện load danh sách công việc đã lưu
  Future<void> _onLoadSavedJobs(
    LoadSavedJobs event,
    Emitter<SavedJobsState> emit,
  ) async {
    emit(const SavedJobsLoading());

    try {
      // TODO: Gọi API hoặc repository để lấy dữ liệu từ local storage
      // Tạm thời dùng dữ liệu mẫu
      await Future.delayed(const Duration(seconds: 1));

      final savedJobs = _getDummySavedJobs();

      emit(SavedJobsLoaded(savedJobs: savedJobs));
    } catch (e) {
      emit(SavedJobsError('Không thể tải dữ liệu: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện refresh danh sách
  Future<void> _onRefreshSavedJobs(
    RefreshSavedJobs event,
    Emitter<SavedJobsState> emit,
  ) async {
    final currentState = state;

    try {
      // TODO: Gọi API để refresh dữ liệu
      await Future.delayed(const Duration(milliseconds: 500));

      final savedJobs = _getDummySavedJobs();

      if (currentState is SavedJobsLoaded) {
        emit(currentState.copyWith(savedJobs: savedJobs));
      } else {
        emit(SavedJobsLoaded(savedJobs: savedJobs));
      }
    } catch (e) {
      emit(SavedJobsError('Không thể làm mới dữ liệu: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện thêm công việc vào danh sách đã lưu
  Future<void> _onAddSavedJob(
    AddSavedJob event,
    Emitter<SavedJobsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SavedJobsLoaded) return;

    try {
      // TODO: Gọi API để lưu vào database
      await Future.delayed(const Duration(milliseconds: 300));

      // Tạo job mới
      final newJob = SavedJobModel(
        id: event.jobId,
        title: event.title,
        company: event.company,
        location: event.location,
        type: event.type,
        salary: event.salary,
        logo: event.company.toLowerCase(),
        color: 0xFF3366FF,
        savedDate: DateTime.now(),
      );

      final updatedJobs = [newJob, ...currentState.savedJobs];

      emit(currentState.copyWith(savedJobs: updatedJobs));
      emit(const SavedJobAdded('Đã lưu công việc'));
      emit(currentState.copyWith(savedJobs: updatedJobs));
    } catch (e) {
      emit(SavedJobsError('Không thể lưu công việc: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện xóa công việc khỏi danh sách
  Future<void> _onRemoveSavedJob(
    RemoveSavedJob event,
    Emitter<SavedJobsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SavedJobsLoaded) return;

    try {
      // TODO: Gọi API để xóa khỏi database
      await Future.delayed(const Duration(milliseconds: 300));

      final jobToRemove = currentState.savedJobs.firstWhere(
        (job) => job.id == event.jobId,
      );

      final updatedJobs = currentState.savedJobs
          .where((job) => job.id != event.jobId)
          .toList();

      emit(currentState.copyWith(savedJobs: updatedJobs));
      
      // Emit trạng thái đã xóa
      emit(SavedJobRemoved(
        message: 'Đã xóa khỏi danh sách đã lưu',
        jobTitle: jobToRemove.title,
      ));
      
      // Quay lại trạng thái loaded
      emit(currentState.copyWith(savedJobs: updatedJobs));
    } catch (e) {
      emit(SavedJobsError('Không thể xóa công việc: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện tìm kiếm
  Future<void> _onSearchSavedJobs(
    SearchSavedJobs event,
    Emitter<SavedJobsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SavedJobsLoaded) return;

    emit(currentState.copyWith(searchQuery: event.query));
  }

  /// Xử lý sự kiện lọc theo loại công việc
  Future<void> _onFilterSavedJobsByType(
    FilterSavedJobsByType event,
    Emitter<SavedJobsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SavedJobsLoaded) return;

    emit(currentState.copyWith(selectedType: event.type));
  }

  /// Dữ liệu mẫu cho công việc đã lưu
  List<SavedJobModel> _getDummySavedJobs() {
    final now = DateTime.now();
    
    return [
      SavedJobModel(
        id: '1',
        title: 'Thiết kế UI/UX',
        company: 'AirBNB',
        location: 'Hoa Kỳ',
        type: 'Toàn thời gian',
        salary: '\$2,350',
        logo: 'airbnb',
        color: 0xFFFF5A5F,
        savedDate: now.subtract(const Duration(days: 2)),
      ),
      SavedJobModel(
        id: '2',
        title: 'Chuyên viên tài chính',
        company: 'Twitter',
        location: 'Vương quốc Anh',
        type: 'Bán thời gian',
        salary: '\$2,240',
        logo: 'twitter',
        color: 0xFF1DA1F2,
        savedDate: now.subtract(const Duration(days: 5)),
      ),
      SavedJobModel(
        id: '3',
        title: 'Kỹ sư dữ liệu',
        company: 'LinkedIn',
        location: 'Singapore',
        type: 'Toàn thời gian',
        salary: '\$3,120',
        logo: 'linkedin',
        color: 0xFF0A66C2,
        savedDate: now.subtract(const Duration(days: 7)),
      ),
      SavedJobModel(
        id: '4',
        title: 'Thiết kế sản phẩm',
        company: 'CocaCola',
        location: 'Nga',
        type: 'Bán thời gian',
        salary: '\$2,780',
        logo: 'cocacola',
        color: 0xFFED1C16,
        savedDate: now.subtract(const Duration(days: 10)),
      ),
      SavedJobModel(
        id: '5',
        title: 'Giám định âm nhạc',
        company: 'Spotify',
        location: 'Pháp',
        type: 'Tự do',
        salary: '\$1,250',
        logo: 'spotify',
        color: 0xFF1DB954,
        savedDate: now.subtract(const Duration(days: 12)),
      ),
      SavedJobModel(
        id: '6',
        title: 'Sản xuất âm nhạc',
        company: 'Apple Music',
        location: 'Hoa Kỳ',
        type: 'Bán thời gian',
        salary: '\$3,530',
        logo: 'apple',
        color: 0xFF000000,
        savedDate: now.subtract(const Duration(days: 15)),
      ),
      SavedJobModel(
        id: '7',
        title: 'Thiết kế sản phẩm',
        company: 'Adidas',
        location: 'Pháp',
        type: 'Toàn thời gian',
        salary: '\$3,380',
        logo: 'adidas',
        color: 0xFF000000,
        savedDate: now.subtract(const Duration(days: 20)),
      ),
    ];
  }
}
