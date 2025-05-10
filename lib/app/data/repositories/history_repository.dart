import '../models/listening_history.dart';
import '../providers/providers.dart';
import 'repositories.dart';

class HistoryRepository extends BaseRepository {
  Future<ListeningHistory> getListeningHistory() {
    return handleCall(() => ApiProvider.getListeningHistory())
        .then((response) => ListeningHistory.fromJson(response));
  }

  Future<bool> addTrackToHistory(String trackId) {
    return handleCall(() => ApiProvider.addTrackToHistory(trackId));
  }

  Future<bool> removeTrackFromHistory(String trackId) {
    return handleCall(() => ApiProvider.removeTrackFromHistory(trackId));
  }

  Future<bool> clearHistory() {
    return handleCall(() => ApiProvider.clearHistory());
  }
} 