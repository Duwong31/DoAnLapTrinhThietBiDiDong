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
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      
      _isLoading(true);
      _history.value = await _repository.getListeningHistory();
      
    } catch (e) {

      Get.snackbar('Error', 'Failed to load listening history');
    } finally {
      _isLoading(false);
    }
  }

  Future<bool> addTrackToHistory(String trackId) async {
    try {
      // Kiểm tra nếu bài hát đã có trong lịch sử
      if (history?.hasTrack(trackId) ?? false) {
        return true;
      }

      _isSaving(true);
      final success = await _repository.addTrackToHistory(trackId);
      if (success) {
        await fetchHistory(); // Refresh history after adding
      } else {
      }
      return success;
    } catch (e) {

      return false;
    } finally {
      _isSaving(false);
    }
  }

  Future<bool> removeTrackFromHistory(String trackId) async {
    try {
      _isSaving(true);
      final success = await _repository.removeTrackFromHistory(trackId);
      if (success) {
        await fetchHistory(); // Refresh history after removing
      } else {

      }
      return success;
    } catch (e) {

      return false;
    } finally {
      _isSaving(false);
    }
  }

  Future<bool> clearHistory() async {
    try {

      _isSaving(true);
      final success = await _repository.clearHistory();
      if (success) {
 
        _history.value = null;
      } else {
  
      }
      return success;
    } catch (e) {
 
      return false;
    } finally {
      _isSaving(false);
    }
  }
} 