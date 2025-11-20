import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

/// BLoC quản lý logic cho Home screen
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
    on<SearchJobs>(_onSearchJobs);
    on<FilterJobsByCategory>(_onFilterJobsByCategory);
    on<ToggleSaveJob>(_onToggleSaveJob);
  }

  /// Xử lý sự kiện load dữ liệu ban đầu
  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    try {
      // TODO: Gọi API hoặc repository để lấy dữ liệu
      // Tạm thời dùng dữ liệu mẫu
      await Future.delayed(const Duration(seconds: 1));

      final jobs = _getDummyJobs();
      final tips = _getDummyTips();

      emit(HomeLoaded(
        recommendedJobs: jobs,
        tips: tips,
      ));
    } catch (e) {
      emit(HomeError('Không thể tải dữ liệu: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện refresh dữ liệu
  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    
    try {
      // TODO: Gọi API để refresh dữ liệu
      await Future.delayed(const Duration(milliseconds: 500));

      final jobs = _getDummyJobs();
      final tips = _getDummyTips();

      if (currentState is HomeLoaded) {
        emit(currentState.copyWith(
          recommendedJobs: jobs,
          tips: tips,
        ));
      } else {
        emit(HomeLoaded(
          recommendedJobs: jobs,
          tips: tips,
        ));
      }
    } catch (e) {
      emit(HomeError('Không thể làm mới dữ liệu: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện tìm kiếm công việc
  Future<void> _onSearchJobs(
    SearchJobs event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    try {
      // TODO: Implement tìm kiếm thực tế
      final query = event.query.toLowerCase();
      final allJobs = _getDummyJobs();
      
      final filteredJobs = allJobs.where((job) {
        return job.title.toLowerCase().contains(query) ||
            job.company.toLowerCase().contains(query) ||
            job.location.toLowerCase().contains(query);
      }).toList();

      emit(currentState.copyWith(recommendedJobs: filteredJobs));
    } catch (e) {
      emit(HomeError('Lỗi khi tìm kiếm: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện lọc công việc theo danh mục
  Future<void> _onFilterJobsByCategory(
    FilterJobsByCategory event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    try {
      final allJobs = _getDummyJobs();
      final category = event.category;

      final filteredJobs = category == 'Tất cả'
          ? allJobs
          : allJobs.where((job) => job.category == category).toList();

      emit(currentState.copyWith(
        recommendedJobs: filteredJobs,
        selectedCategory: category,
      ));
    } catch (e) {
      emit(HomeError('Lỗi khi lọc: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện lưu/bỏ lưu công việc
  Future<void> _onToggleSaveJob(
    ToggleSaveJob event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    try {
      final savedIds = List<String>.from(currentState.savedJobIds);
      
      if (savedIds.contains(event.jobId)) {
        savedIds.remove(event.jobId);
      } else {
        savedIds.add(event.jobId);
      }

      final updatedJobs = currentState.recommendedJobs.map((job) {
        if (job.id == event.jobId) {
          return job.copyWith(isSaved: !job.isSaved);
        }
        return job;
      }).toList();

      emit(currentState.copyWith(
        recommendedJobs: updatedJobs,
        savedJobIds: savedIds,
      ));
    } catch (e) {
      emit(HomeError('Lỗi khi lưu công việc: ${e.toString()}'));
    }
  }

  /// Dữ liệu mẫu cho công việc
  List<JobModel> _getDummyJobs() {
    return [
      const JobModel(
        id: '1',
        title: 'Thiết kế UI/UX',
        company: 'AirBNB',
        location: 'Hoa Kỳ',
        type: 'Toàn thời gian',
        salary: '\$2,350',
        category: 'Thiết kế',
      ),
      const JobModel(
        id: '2',
        title: 'Chuyên viên tài chính',
        company: 'Twitter',
        location: 'Vương quốc Anh',
        type: 'Bán thời gian',
        salary: '\$2,200',
        category: 'Tài chính',
      ),
      const JobModel(
        id: '3',
        title: 'Lập trình viên Frontend',
        company: 'Google',
        location: 'Singapore',
        type: 'Toàn thời gian',
        salary: '\$3,500',
        category: 'Lập trình',
      ),
      const JobModel(
        id: '4',
        title: 'Content Writer',
        company: 'Medium',
        location: 'Việt Nam',
        type: 'Tự do',
        salary: '\$1,200',
        category: 'Viết lách',
      ),
    ];
  }

  /// Dữ liệu mẫu cho tips
  List<TipModel> _getDummyTips() {
    return [
      const TipModel(
        id: '1',
        title: 'Cách tìm công việc hoàn hảo cho bạn',
        description: 'Tìm hiểu các bước để tìm được công việc phù hợp với kỹ năng và sở thích của bạn.',
      ),
      const TipModel(
        id: '2',
        title: 'Chuẩn bị phỏng vấn hiệu quả',
        description: 'Những mẹo vàng giúp bạn tự tin và thành công trong buổi phỏng vấn.',
      ),
    ];
  }
}
