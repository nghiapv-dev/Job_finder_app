import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';

/// BLoC quản lý logic cho Chat screen
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatInitial()) {
    on<LoadChats>(_onLoadChats);
    on<RefreshChats>(_onRefreshChats);
    on<FilterChatsByStatus>(_onFilterChatsByStatus);
    on<SearchChats>(_onSearchChats);
    on<DeleteChat>(_onDeleteChat);
    on<ArchiveChat>(_onArchiveChat);
    on<SendMessage>(_onSendMessage);
    on<LoadChatMessages>(_onLoadChatMessages);
    on<MarkChatAsRead>(_onMarkChatAsRead);
  }

  /// Xử lý sự kiện load danh sách chat
  Future<void> _onLoadChats(
    LoadChats event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoading());

    try {
      // TODO: Gọi API hoặc repository để lấy dữ liệu
      await Future.delayed(const Duration(seconds: 1));

      final chats = _getDummyChats();

      emit(ChatLoaded(chats: chats));
    } catch (e) {
      emit(ChatError('Không thể tải dữ liệu: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện refresh danh sách
  Future<void> _onRefreshChats(
    RefreshChats event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final chats = _getDummyChats();

      if (currentState is ChatLoaded) {
        emit(currentState.copyWith(chats: chats));
      } else {
        emit(ChatLoaded(chats: chats));
      }
    } catch (e) {
      emit(ChatError('Không thể làm mới dữ liệu: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện lọc theo trạng thái
  Future<void> _onFilterChatsByStatus(
    FilterChatsByStatus event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ChatLoaded) return;

    emit(currentState.copyWith(selectedStatus: event.status));
  }

  /// Xử lý sự kiện tìm kiếm
  Future<void> _onSearchChats(
    SearchChats event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ChatLoaded) return;

    emit(currentState.copyWith(searchQuery: event.query));
  }

  /// Xử lý sự kiện xóa chat
  Future<void> _onDeleteChat(
    DeleteChat event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ChatLoaded) return;

    try {
      // TODO: Gọi API để xóa
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedChats = currentState.chats
          .where((chat) => chat.id != event.chatId)
          .toList();

      emit(currentState.copyWith(chats: updatedChats));
      emit(const ChatDeleted('Chat đã được xóa'));
      emit(currentState.copyWith(chats: updatedChats));
    } catch (e) {
      emit(ChatError('Không thể xóa chat: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện archive chat
  Future<void> _onArchiveChat(
    ArchiveChat event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ChatLoaded) return;

    try {
      // TODO: Gọi API để archive
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedChats = currentState.chats.map((chat) {
        if (chat.id == event.chatId) {
          return chat.copyWith(isArchived: true, isActive: false);
        }
        return chat;
      }).toList();

      emit(currentState.copyWith(chats: updatedChats));
      emit(const ChatArchived('Chat đã được lưu trữ'));
      emit(currentState.copyWith(chats: updatedChats));
    } catch (e) {
      emit(ChatError('Không thể lưu trữ chat: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện gửi tin nhắn
  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;

    try {
      // TODO: Gọi API để gửi tin nhắn
      await Future.delayed(const Duration(milliseconds: 500));

      // Update last message trong chat list nếu đang ở ChatLoaded state
      if (currentState is ChatLoaded) {
        final updatedChats = currentState.chats.map((chat) {
          if (chat.id == event.chatId) {
            return chat.copyWith(
              lastMessage: event.message,
              lastMessageTime: DateTime.now(),
            );
          }
          return chat;
        }).toList();

        emit(currentState.copyWith(chats: updatedChats));
      }

      emit(MessageSent(event.chatId));

      // Quay lại state hiện tại
      if (currentState is ChatLoaded) {
        final updatedChats = currentState.chats.map((chat) {
          if (chat.id == event.chatId) {
            return chat.copyWith(
              lastMessage: event.message,
              lastMessageTime: DateTime.now(),
            );
          }
          return chat;
        }).toList();

        emit(currentState.copyWith(chats: updatedChats));
      } else if (currentState is ChatMessagesLoaded) {
        // Thêm tin nhắn mới vào danh sách
        final newMessage = MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          chatId: event.chatId,
          content: event.message,
          timestamp: DateTime.now(),
          isSentByMe: true,
          isRead: true,
        );

        emit(currentState.copyWith(
          messages: [...currentState.messages, newMessage],
        ));
      }
    } catch (e) {
      emit(ChatError('Không thể gửi tin nhắn: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện load tin nhắn cho chat cụ thể
  Future<void> _onLoadChatMessages(
    LoadChatMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoading());

    try {
      // TODO: Gọi API để lấy tin nhắn
      await Future.delayed(const Duration(milliseconds: 800));

      final messages = _getDummyMessages(event.chatId);
      final chatInfo = _getDummyChats()
          .firstWhere((chat) => chat.id == event.chatId);

      emit(ChatMessagesLoaded(
        chatId: event.chatId,
        messages: messages,
        chatInfo: chatInfo,
      ));
    } catch (e) {
      emit(ChatError('Không thể tải tin nhắn: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện đánh dấu đã đọc
  Future<void> _onMarkChatAsRead(
    MarkChatAsRead event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ChatLoaded) return;

    try {
      // TODO: Gọi API để đánh dấu đã đọc
      await Future.delayed(const Duration(milliseconds: 200));

      final updatedChats = currentState.chats.map((chat) {
        if (chat.id == event.chatId) {
          return chat.copyWith(unreadCount: 0);
        }
        return chat;
      }).toList();

      emit(currentState.copyWith(chats: updatedChats));
    } catch (e) {
      emit(ChatError('Không thể đánh dấu đã đọc: ${e.toString()}'));
    }
  }

  /// Dữ liệu mẫu cho danh sách chat
  List<ChatModel> _getDummyChats() {
    final now = DateTime.now();

    return [
      ChatModel(
        id: '1',
        companyName: 'Twitter',
        jobTitle: 'Chuyên viên tài chính',
        companyLogo: 'twitter',
        companyColor: 0xFF1DA1F2,
        lastMessage: 'Cảm ơn bạn đã ứng tuyển! Chúng tôi sẽ liên hệ sớm.',
        lastMessageTime: now.subtract(const Duration(minutes: 15)),
        unreadCount: 2,
        isOnline: true,
      ),
      ChatModel(
        id: '2',
        companyName: 'Google',
        jobTitle: 'Kỹ sư phần mềm Senior',
        companyLogo: 'google',
        companyColor: 0xFF4285F4,
        lastMessage: 'Bạn có thể tham gia phỏng vấn vào thứ Sáu tuần sau không?',
        lastMessageTime: now.subtract(const Duration(hours: 2)),
        unreadCount: 1,
        isOnline: true,
      ),
      ChatModel(
        id: '3',
        companyName: 'Facebook',
        jobTitle: 'Product Designer',
        companyLogo: 'facebook',
        companyColor: 0xFF1877F2,
        lastMessage: 'Đã nhận được hồ sơ của bạn.',
        lastMessageTime: now.subtract(const Duration(hours: 5)),
        unreadCount: 0,
        isOnline: false,
      ),
      ChatModel(
        id: '4',
        companyName: 'Microsoft',
        jobTitle: 'Cloud Solutions Architect',
        companyLogo: 'microsoft',
        companyColor: 0xFF00A4EF,
        lastMessage: 'Chúng tôi rất ấn tượng với portfolio của bạn!',
        lastMessageTime: now.subtract(const Duration(days: 1)),
        unreadCount: 3,
        isOnline: false,
      ),
      ChatModel(
        id: '5',
        companyName: 'Apple',
        jobTitle: 'iOS Developer',
        companyLogo: 'apple',
        companyColor: 0xFF000000,
        lastMessage: 'Bạn có kinh nghiệm với SwiftUI chưa?',
        lastMessageTime: now.subtract(const Duration(days: 2)),
        unreadCount: 0,
        isOnline: false,
      ),
    ];
  }

  /// Dữ liệu mẫu cho tin nhắn
  List<MessageModel> _getDummyMessages(String chatId) {
    final now = DateTime.now();

    return [
      MessageModel(
        id: '1',
        chatId: chatId,
        content: 'Chào bạn! Cảm ơn bạn đã ứng tuyển vị trí tại công ty chúng tôi.',
        timestamp: now.subtract(const Duration(hours: 3)),
        isSentByMe: false,
        isRead: true,
      ),
      MessageModel(
        id: '2',
        chatId: chatId,
        content: 'Chào! Rất vui được nói chuyện với bạn. Tôi rất quan tâm đến vị trí này.',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 50)),
        isSentByMe: true,
        isRead: true,
      ),
      MessageModel(
        id: '3',
        chatId: chatId,
        content: 'Tuyệt vời! Bạn có thể cho chúng tôi biết thêm về kinh nghiệm làm việc của bạn không?',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 45)),
        isSentByMe: false,
        isRead: true,
      ),
      MessageModel(
        id: '4',
        chatId: chatId,
        content: 'Tất nhiên! Tôi có 5 năm kinh nghiệm trong lĩnh vực này và đã làm việc với nhiều dự án lớn.',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 30)),
        isSentByMe: true,
        isRead: true,
      ),
      MessageModel(
        id: '5',
        chatId: chatId,
        content: 'Nghe có vẻ rất tốt! Chúng tôi sẽ xem xét và liên hệ lại với bạn sớm nhất có thể.',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 15)),
        isSentByMe: false,
        isRead: true,
      ),
      MessageModel(
        id: '6',
        chatId: chatId,
        content: 'Cảm ơn bạn! Tôi rất mong chờ được hợp tác với team.',
        timestamp: now.subtract(const Duration(hours: 2)),
        isSentByMe: true,
        isRead: true,
      ),
    ];
  }
}
