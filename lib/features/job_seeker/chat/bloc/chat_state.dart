import 'package:equatable/equatable.dart';

/// Trạng thái của Chat screen
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái khởi tạo
class ChatInitial extends ChatState {
  const ChatInitial();
}

/// Trạng thái đang tải dữ liệu
class ChatLoading extends ChatState {
  const ChatLoading();
}

/// Trạng thái đã tải danh sách chat thành công
class ChatLoaded extends ChatState {
  final List<ChatModel> chats;
  final String searchQuery;
  final String selectedStatus;

  const ChatLoaded({
    required this.chats,
    this.searchQuery = '',
    this.selectedStatus = 'Tất cả',
  });

  @override
  List<Object?> get props => [chats, searchQuery, selectedStatus];

  /// Copy với các giá trị mới
  ChatLoaded copyWith({
    List<ChatModel>? chats,
    String? searchQuery,
    String? selectedStatus,
  }) {
    return ChatLoaded(
      chats: chats ?? this.chats,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }

  /// Lấy danh sách đã lọc theo status và search
  List<ChatModel> get filteredChats {
    var filtered = chats;

    // Lọc theo trạng thái
    if (selectedStatus != 'Tất cả') {
      filtered = filtered.where((chat) {
        if (selectedStatus == 'Đang hoạt động') {
          return chat.isActive;
        } else if (selectedStatus == 'Đã lưu trữ') {
          return chat.isArchived;
        }
        return true;
      }).toList();
    }

    // Lọc theo search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((chat) {
        final query = searchQuery.toLowerCase();
        return chat.companyName.toLowerCase().contains(query) ||
            chat.jobTitle.toLowerCase().contains(query) ||
            chat.lastMessage.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }
}

/// Trạng thái đã tải tin nhắn cho chat cụ thể
class ChatMessagesLoaded extends ChatState {
  final String chatId;
  final List<MessageModel> messages;
  final ChatModel chatInfo;

  const ChatMessagesLoaded({
    required this.chatId,
    required this.messages,
    required this.chatInfo,
  });

  @override
  List<Object?> get props => [chatId, messages, chatInfo];

  ChatMessagesLoaded copyWith({
    String? chatId,
    List<MessageModel>? messages,
    ChatModel? chatInfo,
  }) {
    return ChatMessagesLoaded(
      chatId: chatId ?? this.chatId,
      messages: messages ?? this.messages,
      chatInfo: chatInfo ?? this.chatInfo,
    );
  }
}

/// Trạng thái lỗi
class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Trạng thái thành công sau khi xóa
class ChatDeleted extends ChatState {
  final String message;

  const ChatDeleted(this.message);

  @override
  List<Object?> get props => [message];
}

/// Trạng thái thành công sau khi archive
class ChatArchived extends ChatState {
  final String message;

  const ChatArchived(this.message);

  @override
  List<Object?> get props => [message];
}

/// Trạng thái thành công sau khi gửi tin nhắn
class MessageSent extends ChatState {
  final String chatId;

  const MessageSent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

/// Model cho chat conversation
class ChatModel extends Equatable {
  final String id;
  final String companyName;
  final String jobTitle;
  final String companyLogo;
  final int companyColor;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isActive;
  final bool isArchived;
  final bool isOnline;

  const ChatModel({
    required this.id,
    required this.companyName,
    required this.jobTitle,
    required this.companyLogo,
    required this.companyColor,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isActive = true,
    this.isArchived = false,
    this.isOnline = false,
  });

  @override
  List<Object?> get props => [
        id,
        companyName,
        jobTitle,
        companyLogo,
        companyColor,
        lastMessage,
        lastMessageTime,
        unreadCount,
        isActive,
        isArchived,
        isOnline,
      ];

  ChatModel copyWith({
    String? id,
    String? companyName,
    String? jobTitle,
    String? companyLogo,
    int? companyColor,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    bool? isActive,
    bool? isArchived,
    bool? isOnline,
  }) {
    return ChatModel(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      jobTitle: jobTitle ?? this.jobTitle,
      companyLogo: companyLogo ?? this.companyLogo,
      companyColor: companyColor ?? this.companyColor,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isActive: isActive ?? this.isActive,
      isArchived: isArchived ?? this.isArchived,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  /// Format time hiển thị
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(lastMessageTime);

    if (difference.inMinutes < 1) {
      return 'Vừa xong';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return '${lastMessageTime.day}/${lastMessageTime.month}/${lastMessageTime.year}';
    }
  }
}

/// Model cho tin nhắn
class MessageModel extends Equatable {
  final String id;
  final String chatId;
  final String content;
  final DateTime timestamp;
  final bool isSentByMe;
  final bool isRead;
  final String? attachment;

  const MessageModel({
    required this.id,
    required this.chatId,
    required this.content,
    required this.timestamp,
    required this.isSentByMe,
    this.isRead = false,
    this.attachment,
  });

  @override
  List<Object?> get props => [
        id,
        chatId,
        content,
        timestamp,
        isSentByMe,
        isRead,
        attachment,
      ];

  MessageModel copyWith({
    String? id,
    String? chatId,
    String? content,
    DateTime? timestamp,
    bool? isSentByMe,
    bool? isRead,
    String? attachment,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isSentByMe: isSentByMe ?? this.isSentByMe,
      isRead: isRead ?? this.isRead,
      attachment: attachment ?? this.attachment,
    );
  }

  /// Format time hiển thị
  String get formattedTime {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
