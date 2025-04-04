part of 'repositories.dart';

abstract class ChatBase {
  Future<MessageModel> sentMessage(String chatId, data);
  Future<void> markReadAll(String id);
}

class ChatRepository implements ChatBase {
  @override
  @override
  Future<MessageModel> sentMessage(String chatId, data) {
    return ApiProvider.sentMessage(chatId, data);
  }

  @override
  Future<void> markReadAll(String id) {
    return ApiProvider.markReadAll(id);
  }
}
