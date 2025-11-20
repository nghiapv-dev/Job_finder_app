import 'package:equatable/equatable.dart';

/// Các sự kiện cho Chat screen
abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

/// Sự kiện load danh sách chat
class LoadChats extends ChatEvent {
  const LoadChats();
}

/// Sự kiện refresh danh sách chat
class RefreshChats extends ChatEvent {
  const RefreshChats();
}

/// Sự kiện lọc chat theo trạng thái
class FilterChatsByStatus extends ChatEvent {
  final String status;

  const FilterChatsByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

/// Sự kiện tìm kiếm chat
class SearchChats extends ChatEvent {
  final String query;

  const SearchChats(this.query);

  @override
  List<Object?> get props => [query];
}

/// Sự kiện xóa chat
class DeleteChat extends ChatEvent {
  final String chatId;

  const DeleteChat(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

/// Sự kiện archive chat
class ArchiveChat extends ChatEvent {
  final String chatId;

  const ArchiveChat(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

/// Sự kiện gửi tin nhắn
class SendMessage extends ChatEvent {
  final String chatId;
  final String message;

  const SendMessage({
    required this.chatId,
    required this.message,
  });

  @override
  List<Object?> get props => [chatId, message];
}

/// Sự kiện load tin nhắn cho một chat cụ thể
class LoadChatMessages extends ChatEvent {
  final String chatId;

  const LoadChatMessages(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

/// Sự kiện đánh dấu chat đã đọc
class MarkChatAsRead extends ChatEvent {
  final String chatId;

  const MarkChatAsRead(this.chatId);

  @override
  List<Object?> get props => [chatId];
}
