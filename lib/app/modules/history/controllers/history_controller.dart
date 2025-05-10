import 'package:get/get.dart';
import '../../../data/repositories/history_repository.dart';
import '../../../data/models/listening_history.dart';

class HistoryController extends GetxController {
  final HistoryRepository _repository = Get.find<HistoryRepository>();
  
  final Rx<ListeningHistory?> _history = Rx<ListeningHistory?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isSaving = false.obs;

  ListeningHistory? get history => _history.value;
  bool get isLoading => _isLoading.value;
  bool get isSaving => _isSaving.value;

  @override
  void onInit() {
    super.onInit();
    print('[HistoryController] Initializing...');
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      print('[HistoryController] Fetching history...');
      _isLoading(true);
      _history.value = await _repository.getListeningHistory();
      print('[HistoryController] History fetched successfully: ${_history.value?.trackIds.length ?? 0} tracks');
    } catch (e) {
      print('[HistoryController] Error fetching history: $e');
      Get.snackbar('Error', 'Failed to load listening history');
    } finally {
      _isLoading(false);
    }
  }

  Future<bool> addTrackToHistory(String trackId) async {
    try {
      // Kiểm tra nếu bài hát đã có trong lịch sử
      if (history?.hasTrack(trackId) ?? false) {
        print('[HistoryController] Track $trackId already in history');
        return true;
      }

      print('[HistoryController] Adding track to history: $trackId');
      _isSaving(true);
      final success = await _repository.addTrackToHistory(trackId);
      if (success) {
        print('[HistoryController] Track added successfully, refreshing history...');
        await fetchHistory(); // Refresh history after adding
      } else {
        print('[HistoryController] Failed to add track to history');
      }
      return success;
    } catch (e) {
      print('[HistoryController] Error adding track to history: $e');
      return false;
    } finally {
      _isSaving(false);
    }
  }

  Future<bool> removeTrackFromHistory(String trackId) async {
    try {
      print('[HistoryController] Removing track from history: $trackId');
      _isSaving(true);
      final success = await _repository.removeTrackFromHistory(trackId);
      if (success) {
        print('[HistoryController] Track removed successfully, refreshing history...');
        await fetchHistory(); // Refresh history after removing
      } else {
        print('[HistoryController] Failed to remove track from history');
      }
      return success;
    } catch (e) {
      print('[HistoryController] Error removing track from history: $e');
      return false;
    } finally {
      _isSaving(false);
    }
  }

  Future<bool> clearHistory() async {
    try {
      print('[HistoryController] Clearing history...');
      _isSaving(true);
      final success = await _repository.clearHistory();
      if (success) {
        print('[HistoryController] History cleared successfully');
        _history.value = null;
      } else {
        print('[HistoryController] Failed to clear history');
      }
      return success;
    } catch (e) {
      print('[HistoryController] Error clearing history: $e');
      return false;
    } finally {
      _isSaving(false);
    }
  }
} 