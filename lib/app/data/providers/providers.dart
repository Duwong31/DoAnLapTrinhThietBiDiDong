import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:get_storage/get_storage.dart';
import '../../core/styles/style.dart';
import '../../core/utilities/utilities.dart';
import '../../routes/app_pages.dart';
import '../http_client/http_client.dart';
import '../models/booking_model/booking_model.dart';
import '../models/car_model/car_detail_model.dart';
import '../models/car_model/car_filters.dart';
import '../models/car_model/car_model.dart';
import '../models/car_model/cate_car.dart';
import '../models/car_model/location_car.dart';
import '../models/dashboard_model.dart';
import '../models/models.dart';
import '../models/review_listing_model.dart';
import '../models/voucher_model/voucher.dart';
import '../repositories/repositories.dart';
import '../models/favorite_genre_model.dart';

abstract class BaseApiService {
  final Dio _dio;
  final GetStorage _storage = GetStorage();
  final String _baseUrl = 'https://soundflow.click';

  BaseApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://soundflow.click',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
        ));

  Dio get dio => _dio;

  GetStorage get storage => _storage;

  String get baseUrl => _baseUrl;

  // Get stored auth token
  String? getToken() => _storage.read('access_token');

  // Get authorized headers with bearer token
  Map<String, dynamic> getAuthHeaders() => {
        'Authorization': 'Bearer ${getToken()}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };

  // Handle API errors consistently
  Future<T> handleApiError<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on DioException catch (e) {
      AppUtils.log('API Error: ${e.message}');

      if (e.response?.statusCode == 401) {
        // Handle token expiration
        await _handleUnauthorized();
      }

      rethrow;
    } catch (e) {
      AppUtils.log('Unexpected error: $e');
      rethrow;
    }
  }

  // Handle 401 unauthorized errors
  Future<void> _handleUnauthorized() async {
    // Clear credentials and redirect to login
    await _storage.erase();
    Get.offAllNamed(Routes.login);
  }

  // Create standard API options with auth headers
  Options getOptions({Map<String, dynamic>? extraHeaders}) {
    final headers = getAuthHeaders();
    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }

    return Options(
      headers: headers,
      validateStatus: (status) => status != null && status < 500,
    );
  }

  // Execute GET request with error handling
  Future<Response<T>> get<T>(String endpoint,
      {Map<String, dynamic>? query, Options? options}) {
    debugPrint("GET");
    debugPrint(endpoint.toString());
    debugPrint(query.toString());
    return handleApiError(() => dio.get<T>(endpoint,
        queryParameters: query, options: options ?? getOptions()));
  }

  // Execute POST request with error handling
  Future<Response<T>> post<T>(String endpoint,
      {dynamic data, Map<String, dynamic>? query, Options? options}) {
    debugPrint("POST");
    debugPrint(endpoint.toString());
    debugPrint(data.toString());
    debugPrint(query.toString());
    return handleApiError(() => dio.post<T>(endpoint,
        data: data, queryParameters: query, options: options ?? getOptions()));
  }

  // Execute PUT request with error handling
  Future<Response<T>> put<T>(String endpoint,
      {dynamic data, Map<String, dynamic>? query, Options? options}) {
    debugPrint("PUT");
    debugPrint(endpoint.toString());
    debugPrint(data.toString());
    debugPrint(query.toString());
    return handleApiError(() => dio.put<T>(endpoint,
        data: data, queryParameters: query, options: options ?? getOptions()));
  }

  // Execute DELETE request with error handling
  Future<Response<T>> delete<T>(String endpoint,
      {dynamic data, Map<String, dynamic>? query, Options? options}) {
    // *** Sửa lỗi ở đây: GỌI ĐÚNG HÀM DELETE CỦA BASEAPISERVICE ***
     debugPrint("DELETE");
     debugPrint(endpoint.toString());
     debugPrint(data?.toString() ?? "No data");
     debugPrint(query.toString());
    return handleApiError(() => dio.delete<T>(endpoint, // <-- Gọi dio.delete
        data: data, queryParameters: query, options: options ?? getOptions()));
  }

  // Execute PATCH request with error handling
  Future<Response<T>> patch<T>(String endpoint,
      {dynamic data, Map<String, dynamic>? query, Options? options}) {
    return handleApiError(() => dio.patch<T>(endpoint,
        data: data, queryParameters: query, options: options ?? getOptions()));
  }
}

// History API Service
class HistoryApiService extends BaseApiService {
  Future<Map<String, dynamic>> getListeningHistory() async {
    return handleApiError(() async {
      final response = await get(ApiUrl.listeningHistory);
      debugPrint('Raw getListeningHistory response: ${response.data}');
      return response.data;
    });
  }

  Future<List<String>> getRecentHistory() async {
    return handleApiError(() async {
      debugPrint(">>> [HistoryApiService.getRecentHistory] Calling API...");
      final response = await get(ApiUrl.listeningHistory);
      debugPrint(">>> [HistoryApiService.getRecentHistory] Response: ${response.data}");
      
      if (response.data['status'] == 1 && 
          response.data['data'] != null && 
          response.data['data']['track_ids'] != null) {
        final List<dynamic> trackIds = response.data['data']['track_ids'];
        debugPrint(">>> [HistoryApiService.getRecentHistory] Found ${trackIds.length} track IDs");
        return trackIds.map((id) => id.toString()).toList();
      }
      debugPrint(">>> [HistoryApiService.getRecentHistory] No track IDs found in response");
      return [];
    });
  }

  Future<bool> addTrackToHistory(String trackId) async {
    return handleApiError(() async {
      final response = await post(ApiUrl.addToHistory, data: {'track_id': trackId});
      debugPrint('API Response (addTrackToHistory): status=${response.statusCode}, data=${response.data}');
      if (response.statusCode == 201 && response.data['success'] == true) {
        return true;
      }
      throw Exception(response.data['message'] ?? 'Failed to add to history');
    });
  }

  Future<bool> removeTrackFromHistory(String trackId) async {
    return handleApiError(() async {
      final response = await delete(ApiUrl.removeFromHistory, data: {'track_id': trackId});
      debugPrint('API Response (removeTrackFromHistory): status=${response.statusCode}, data=${response.data}');
      if (response.statusCode == 200) {
        return true;
      }
      throw Exception(response.data['message'] ?? 'Failed to remove from history');
    });
  }

  Future<bool> clearHistory() async {
    return handleApiError(() async {
      final response = await delete(ApiUrl.clearHistory);
      debugPrint('API Response (clearHistory): status=${response.statusCode}, data=${response.data}');
      if (response.statusCode == 200) {
        return true;
      }
      throw Exception(response.data['message'] ?? 'Failed to clear history');
    });
  }
}

// UserApiService handles all user-related API operations
class UserApiService extends BaseApiService {
  // ... (các hàm sendOtp, verify, register, login, getPlaylists, etc. giữ nguyên) ...
    Future<bool> sendOtp(String phone, String countryCode) async {
    try {
      final res = await ApiClient.connect(
        ApiUrl.sendOtp,
        method: ApiMethod.post,
        data: {
          "recipient": {
            "phone_number": phone,
            "country_code": countryCode,
          }
        },
      );
      return res.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }
  Future<FavoriteGenreResponse> getFavoriteGenre() async {
    return handleApiError(() async {
      debugPrint(">>> [UserApiService.getFavoriteGenre] Calling API endpoint: ${ApiUrl.favoriteGenre}");
      final response = await get(ApiUrl.favoriteGenre);
      debugPrint(">>> [UserApiService.getFavoriteGenre] Raw API Response: ${response.data}");
      
      if (response.statusCode == 200) {
        try {
          final result = FavoriteGenreResponse.fromJson(response.data);
          debugPrint(">>> [UserApiService.getFavoriteGenre] Parsed response: $result");
          debugPrint(">>> [UserApiService.getFavoriteGenre] Favorite genre: ${result.data.favoriteGenre}");
          return result;
        } catch (e, stack) {
          debugPrint(">>> [UserApiService.getFavoriteGenre] Error parsing response: $e");
          debugPrint(">>> [UserApiService.getFavoriteGenre] Stack trace: $stack");
          throw Exception('Failed to parse favorite genre response: $e');
        }
      } else {
        debugPrint(">>> [UserApiService.getFavoriteGenre] API returned error status: ${response.statusCode}");
        throw Exception(response.data['message'] ?? 'Failed to get favorite genre');
      }
    });
  }
  // Favorite API
    Future<Map<String, dynamic>> getFavorites() async {
      return handleApiError(() async {
        final response = await get(ApiUrl.favorites, query: {'t': DateTime.now().millisecondsSinceEpoch.toString()});
        debugPrint('Raw getFavorites response: ${response.data}');
        return response.data;
      });
    }

    Future<bool> addToFavorite(String trackId) async {
      return handleApiError(() async {
        final response = await post(ApiUrl.addToFavorite, data: {'song_id': trackId});
        debugPrint('API Response (addToFavorite): status=${response.statusCode}, data=${response.data}');
        if (response.statusCode == 201 && response.data['success'] == true) {
          return true; // Thêm thành công
        } else if (response.statusCode == 400 || response.statusCode == 409) {
          // Bài hát đã có trong danh sách yêu thích, coi là thành công
          debugPrint('Song $trackId already in favorites (status: ${response.statusCode})');
          return true;
        }
        throw Exception(response.data['message'] ?? 'Failed to add to favorites');
      });
    }

    Future<bool> removeFavorite(String trackId) async {
      return handleApiError(() async {
        final response = await delete(ApiUrl.removeFavorite(trackId));
        debugPrint('API Response (removeFavorite): status=${response.statusCode}, data=${response.data}');
        if (response.statusCode == 200 && response.data['success'] == true) {
          debugPrint('Successfully removed song $trackId from favorites');
          return true;
        }
        throw Exception(response.data['message'] ?? 'Failed to remove from favorites');
      });
    }

  Future<dynamic> verify(String userId, String otp, String deviceName) async {
    return handleApiError(() async {
      AppUtils.log(
          'API Request to ${ApiUrl.verifyPhoneOtp} with data: {"user_id": $userId, "otp": $otp, "device_name": $deviceName}');

      final response = await post(
        ApiUrl.verifyPhoneOtp,
        data: {"user_id": userId, "otp": otp, "device_name": deviceName},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      AppUtils.log('API Response from verify-phone-otp: ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == 1) {
        // Store the access token
        if (response.data['access_token'] != null) {
          String accessToken = response.data['access_token'];

          storage.write('access_token', accessToken);

          Preferences.setString(StringUtils.token, accessToken);

          Preferences.setString(StringUtils.currentId, userId);

          AppUtils.log('Đã lưu token và thông tin người dùng');
        }

        // Store refresh token if available
        if (response.data['refresh_token'] != null) {
          String refreshToken = response.data['refresh_token'];
          Preferences.setString(StringUtils.refreshToken, refreshToken);
        }
      }

      return response.data;
    });
  }

  Future<String?> refreshToken() async {
    try {
      final deviceToken = await FirebaseMessaging.instance.getToken();
      final res = await ApiClient.connect(
        ApiUrl.refreshToken,
        method: ApiMethod.post,
        data: {
          "recipient": {
            "refresh_token": Preferences.getString(StringUtils.refreshToken),
            "device_token": deviceToken,
            "device_type": Platform.operatingSystem
          }
        },
      );
      final data = res.data['data'];
      if (res.statusCode == 200 && res.data['success'] == true) {
        Preferences.setString(StringUtils.token, data['access_token']);
        Preferences.setString(StringUtils.refreshToken, data['refresh_token']);
        return data['access_token'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> register(String name, String email, String password, String deviceName) async {
    return handleApiError(() async {
      AppUtils.log(
          'API Request to ${ApiUrl.register} with data: {"registration_type": "email","name": $name, "email": $email,"password": $password, "device_name": $deviceName');

      final response = await post(
        ApiUrl.register,
        data: {
          "registration_type": "email",
          "name": name,
          "email": email,
          "password": password,
          "device_name": deviceName,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      AppUtils.log('API Response from register: ${response.data}');
      return response.data;
    });
  }

  Future<dynamic> resendOtp(String phone) async {
    return handleApiError(() async {
      AppUtils.log(
          'API Request to ${ApiUrl.resendOtp} with data: {"phone": $phone}');

      final response = await post(
        ApiUrl.resendOtp,
        data: {"phone": phone},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      AppUtils.log('API Response from resend-otp: ${response.data}');
      return response.data;
    });
  }

  Future<dynamic> setPassword(String phone, String otp, String password,
      String passwordConfirmation, String userId, String deviceName) async {
    return handleApiError(() async {
      AppUtils.log(
          'API Request to ${ApiUrl.setPassword} with data: {"phone": $phone, "otp": $otp, "password": $password, "password_confirmation": $passwordConfirmation, "user_id": $userId, "device_name": $deviceName}');

      final response = await post(
        ApiUrl.setPassword,
        data: {
          "phone": phone,
          "otp": otp,
          "password": password,
          "password_confirmation": passwordConfirmation,
          "user_id": userId,
          "device_name": deviceName
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (getToken() != null) 'Authorization': 'Bearer ${getToken()}',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      AppUtils.log('API Response from set-password: ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == 1) {
        if (response.data['access_token'] != null) {
          String accessToken = response.data['access_token'];
          storage.write('access_token', accessToken);
          Preferences.setString(StringUtils.token, accessToken);
          Preferences.setString(StringUtils.currentId, userId);
          Preferences.setString(StringUtils.phoneNumber, phone);

          AppUtils.log(
              'Đã lưu token và thông tin người dùng sau khi đặt mật khẩu');
        }
        if (response.data['refresh_token'] != null) {
          String refreshToken = response.data['refresh_token'];
          Preferences.setString(StringUtils.refreshToken, refreshToken);
        }
      }

      return response.data;
    });
  }
  Future<dynamic> forgotPasswordEmail(String email) async {
    return handleApiError(() async {
      AppUtils.log(
          'API Request to ${ApiUrl.forgotPasswordEmail} with data: {"email": $email}'); // Assuming ApiUrl.forgotPasswordEmail exists

      final response = await post(
        ApiUrl.forgotPasswordEmail, // Define this URL in ApiUrl
        data: {"email": email},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      AppUtils.log('API Response from forgot-password-email: ${response.data}');
      // Expecting a response like: { status: 1, message: 'OTP sent to email', data: { user_id: ... } } or error
      return response.data;
    });
  }

  Future<dynamic> forgotPassword(String phone) async {
    return handleApiError(() async {
      AppUtils.log(
          'API Request to ${ApiUrl.forgotPassword} with data: {"phone": $phone}');

      final response = await post(
        ApiUrl.forgotPassword,
        data: {"phone": phone},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      AppUtils.log('API Response from forgot-password: ${response.data}');
      return response.data;
    });
  }

  Future<dynamic> resetPasswordEmail(String email, String password,
      String passwordConfirmation) async {
    return handleApiError(() async {
      AppUtils.log(
          'API Request to ${ApiUrl.resetPasswordEmail} with data: {"email": $email, "password": $password, "password_confirmation": $passwordConfirmation}'); // Assuming ApiUrl.resetPasswordEmail exists

      final response = await post(
        ApiUrl.resetPasswordEmail, // Define this URL in ApiUrl
        data: {
          "email": email,
          // "otp": otp,
          "password": password,
          "password_confirmation": passwordConfirmation
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      AppUtils.log('API Response from reset-password-email: ${response.data}');

      // No automatic login/token saving here usually, just confirm success/failure
      // Example success: { status: 1, message: 'Password reset successfully' }
      return response.data;
    });
  }

  Future<dynamic> resetPassword(String phone, String password,
      String passwordConfirmation) async {
    return handleApiError(() async {
      AppUtils.log(
          'API Request to ${ApiUrl.resetPassword} with data: {"phone": $phone, "password": $password, "password_confirmation": $passwordConfirmation}');

      final response = await post(
        ApiUrl.resetPassword,
        data: {
          "phone": phone,
          // "otp": otp,
          "password": password,
          "password_confirmation": passwordConfirmation
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      AppUtils.log('API Response from reset-password: ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == 1) {
        if (response.data['access_token'] != null) {
          String accessToken = response.data['access_token'];
          storage.write('access_token', accessToken);
          Preferences.setString(StringUtils.token, accessToken);
          if (response.data['user_id'] != null) {
            String userId = response.data['user_id'].toString();
            Preferences.setString(StringUtils.currentId, userId);
          }
          Preferences.setString(StringUtils.phoneNumber, phone);
          AppUtils.log(
              'Đã lưu token và thông tin người dùng sau khi đặt lại mật khẩu');
        }
        // Store refresh token if available
        if (response.data['refresh_token'] != null) {
          String refreshToken = response.data['refresh_token'];
          Preferences.setString(StringUtils.refreshToken, refreshToken);
        }
      }

      return response.data;
    });
  }

  Future<dynamic> login(
      String email, String password, String deviceName) async {
    return handleApiError(() async {
      AppUtils.log(
          'API Request to ${ApiUrl.login} with data: {"email": $email, "password": $password, "device_name": $deviceName}');

      final response = await post(
        ApiUrl.login,
        data: {"email": email, "password": password, "device_name": deviceName},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      AppUtils.log('API Response from login: ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == 1) {
        if (response.data['access_token'] != null) {
          String accessToken = response.data['access_token'];
          storage.write('access_token', accessToken);
          AppUtils.log('Đã lưu token cho session hiện tại');
        }
        return response.data;
      }

      return response.data;
    });
  }

  Future<dynamic> changePassword(String currentPassword, String newPassword,
      String newPasswordConfirmation) async {
    return handleApiError(() async {
      AppUtils.log('API Request to ${ApiUrl.changePassword}');

      final token = getToken();
      if (token == null) {
        AppUtils.log('No token available for change password request');
        throw Exception('User not authenticated');
      }

      final response = await post(
        ApiUrl.changePassword,
        data: {
          "current_password": currentPassword,
          "password": newPassword,
          "password_confirmation": newPasswordConfirmation
        },
      );

      AppUtils.log('API Response from change-password: ${response.data}');
      return response.data;
    });
  }

  Future<void> logout() async {
    try {
      // Delete Firebase token
      await FirebaseMessaging.instance.deleteToken();
      
      // Call logout API
      await ApiClient.connect(ApiUrl.logout, method: ApiMethod.delete);
      
      // Clear all stored data
      await GetStorage().erase();
      await Preferences.clear();
      
      // Force navigation to login screen
      Get.offAllNamed(Routes.login);
    } catch (e) {
      debugPrint('Error during logout: $e');
      // Even if API call fails, still clear local data and redirect
      await GetStorage().erase();
      await Preferences.clear();
      Get.offAllNamed(Routes.login);
    }
  }

  Future<UserModel> getDetail() async {
    return handleApiError(() async {
      final response = await get(ApiUrl.userRecipient);
      debugPrint(">>> [UserApiService.getDetail] RAW API Response Data: ${response.data}");
      try {
        // Giả sử API trả về {'data': { ... user data ... }}
        if (response.data != null && response.data['data'] is Map<String, dynamic>) {
           return UserModel.fromMap(response.data['data'] as Map<String, dynamic>);
        } else {
           debugPrint(">>> [UserApiService.getDetail] LỖI: API response không chứa key 'data' hoặc 'data' không phải là Map.");
           throw Exception("Invalid API response structure for user details.");
        }
      } catch (e, stack) {
         debugPrint(">>> [UserApiService.getDetail] LỖI trong quá trình parsing UserModel.fromMap: $e\nStack: $stack");
         // Ném lại lỗi để ProfileController có thể bắt và hiển thị thông báo (nhưng không clear Prefs)
         rethrow;
      }
    });
  }

  Future<UserModel> updateUser(Map<String, dynamic> updatedData) async {
    return handleApiError(() async {
      final response = await post(ApiUrl.userRecipient, data: updatedData);

      if (response.statusCode == 200) {
        return UserModel.fromMap(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Lỗi không xác định.');
      }
    });
  }
  Future<UserModel> updateUserProfile(Map<String, dynamic> updatedData) async {
    return handleApiError(() async {
      AppUtils.log('API Request to ${ApiUrl.updateUserProfile} with data: $updatedData');

      // Sử dụng phương thức post (hoặc put nếu bạn định nghĩa route là PUT)
      final response = await post(ApiUrl.updateUserProfile, data: updatedData);

      AppUtils.log('API Response from update profile: ${response.data}');

      // Kiểm tra response thành công và có data user trả về
      if (response.statusCode == 200 && response.data['status'] == 1 && response.data['data'] is Map<String, dynamic>) {
        // Giả sử API trả về thông tin user đã cập nhật trong key 'data'
        return UserModel.fromMap(response.data['data']);
      } else {
        // Ném lỗi với message từ API nếu có, hoặc lỗi chung
        throw Exception(response.data['message'] ?? 'Failed to update profile');
      }
    });
  }

  Future<bool> verifyInformation(Map<String, dynamic> body) async {
    return handleApiError(() async {
      final response = await post(ApiUrl.verifyInformation, data: body);
      if(response.statusCode == 200){
        return true;
      }else{
        Get.snackbar(
          'Lỗi',
          response.data['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
        return false;
      }
    });
  }

  Future<int?> uploadFile(File newFile,{int? folderId}) async {
    final fileName = newFile.path.split('/').last;
    final file = await MultipartFile.fromFile(newFile.path, filename: fileName);
    return handleApiError(() async {
      debugPrint(">>> [UserApiService.uploadFile] Uploading avatar...");
      final response = await post(ApiUrl.uploadFile,
          data: FormData.fromMap(
              {'file': file,
              // "folder_id": folderId,
              "type": "image"
          }),
          options: Options(
            headers: getAuthHeaders()..addAll({'Content-Type': 'multipart/form-data'}),
            validateStatus: (status) => status != null && status < 500,
        )
      );
        debugPrint(">>> [UserApiService.uploadFile] Response: ${response.data}");

        if (response.statusCode == 200 && response.data['uploaded'] == 1 && response.data?['id'] != null) {
           debugPrint(">>> [UserApiService.uploadFile] Upload success, file ID: ${response.data['data']['id']}");
           return response.data['data']['id'] as int?;
        } else {
           String errorMsg = response.data['error']?['message'] ?? 'Failed to upload avatar.';
           debugPrint(">>> [UserApiService.uploadFile] Upload failed: $errorMsg");
           throw Exception(errorMsg);
        }
    });
  }

  Future<UserModel> uploadAvatar(Uint8List bytes) async {
    try {
      final name = DateTime.now().millisecondsSinceEpoch;
      final file = MultipartFile.fromBytes(bytes, filename: '$name.png');
      final res = await ApiClient.connect(
        ApiUrl.updateAvatar(Preferences.getString(StringUtils.currentId)!),
        method: ApiMethod.put,
        data: FormData.fromMap({'recipient[avatar]': file}),
      );
      AppUtils.log(res);
      return UserModel.fromMap(res.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addAddress(String address, String apartment) async {
    try {
      final res = await ApiClient.connect(
        ApiUrl.addresses,
        method: ApiMethod.post,
        data: {
          "address": {"full_address": address, "apartment": apartment}
        },
      );
      if (res.data['success'] != true) {
        throw (res.data['errors']?.first);
      }
      return res.data['success'] == true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> toggleNotify(bool val) async {
    try {
      final uid = Preferences.getString(StringUtils.currentId)!;
      final res = await ApiClient.connect(
        val ? ApiUrl.enableNotify(uid) : ApiUrl.disableNotify(uid),
        method: ApiMethod.put,
      );
      return res.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> deleteRecipient() async {
    try {
      final res = await ApiClient.connect(
        ApiUrl.deleteRecipient(Preferences.getString(StringUtils.currentId)!),
        method: ApiMethod.delete,
      );
      return UserModel.fromMap(res.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> restoreRecipient() async {
    try {
      final res = await ApiClient.connect(
        ApiUrl.restoreRecipient,
        method: ApiMethod.post,
      );
      return UserModel.fromMap(res.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Dashboard> getDashboard() async {
    try {
      final res = await ApiClient.connect(
        ApiUrl.getDashboard,
        method: ApiMethod.get,
      );
      return Dashboard.fromJson(res.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> saveWishlist(int id) async {
    return handleApiError(() async {
      final response = await post(ApiUrl.userWishlist,
          data: {"object_id": id, "object_model": "car"});
      return response.data['status'] == 1;
    });
  }

  Future<dynamic> createPlaylist(String name) async {
    return handleApiError(() async {
      AppUtils.log('API Request to ${ApiUrl.createPlaylist} with data: {"name": "$name"}');

      final response = await post(
        ApiUrl.createPlaylist,
        data: {'name': name}, // Gửi tên playlist trong body
        // options: getOptions() // getOptions đã bao gồm header Authorization
      );

      AppUtils.log('API Response from create playlist: ${response.data}');

      // Kiểm tra response thành công từ backend
      // Backend của bạn đang trả về status=1 và data của playlist mới
      if (response.statusCode == 200 && response.data['status'] == 1 && response.data['data'] != null) {
        // Có thể trả về dữ liệu playlist mới nếu cần
        return response.data; // Hoặc response.data['data']
      } else {
        // Ném lỗi với message từ API hoặc lỗi chung
        throw Exception(response.data['message'] ?? 'Failed to create playlist');
      }
    });
  }

  Future<Map<String, dynamic>> getPlaylists() async {
  return handleApiError(() async {
    AppUtils.log('API Request to ${ApiUrl.getPlaylists}');
    // Gọi API GET, không cần data body
    final response = await get(ApiUrl.getPlaylists /* options: getOptions() đã bao gồm */);

    // Kiểm tra cấu trúc response chuẩn từ backend của bạn
    if (response.statusCode == 200 && response.data['status'] == 1 && response.data['data'] is List) {
      // Trả về toàn bộ map để Repository xử lý parsing
      return response.data;
    } else {
      throw Exception(response.data['message'] ?? 'Failed to fetch playlists');
    }
  });
}

  // --- HÀM removeTrackFromPlaylist ĐÃ ĐƯỢC ĐẶT ĐÚNG CHỖ ---
  Future<bool> removeTrackFromPlaylist(int playlistId, String trackId) async {
    // Gọi hàm delete từ BaseApiService đã bao gồm handleApiError và auth headers
    // Sử dụng this.delete hoặc delete đều được vì nó kế thừa từ BaseApiService
    final response = await delete<dynamic>(
      ApiUrl.removeTrackFromPlaylist(playlistId, trackId),
      // options: getOptions() // Không cần thiết vì delete đã tự gọi getOptions
    );

    // Kiểm tra status code thành công (200 hoặc 204)
    if (response.statusCode == 200 || response.statusCode == 204) {
      AppUtils.log('Successfully removed track $trackId from playlist $playlistId');
      return true;
    } else {
      // Lỗi đã được handleApiError log, nhưng vẫn trả về false ở đây
      AppUtils.log('Failed to remove track, status: ${response.statusCode}');
      // Bạn có thể throw Exception ở đây nếu muốn Repository bắt lỗi cụ thể hơn
      // throw Exception(response.data['message'] ?? 'Failed to remove track');
      return false;
    }
    // handleApiError sẽ tự động xử lý DioException và lỗi 401
  }

  Future<bool> deletePlaylist(int playlistId) async {
    // Gọi hàm delete từ BaseApiService đã bao gồm handleApiError và auth headers
    final response = await delete<dynamic>(
      ApiUrl.deletePlaylist(playlistId),
    );

    // Kiểm tra status code thành công (200 hoặc 204 No Content là chuẩn)
    if (response.statusCode == 200 || response.statusCode == 204) {
      AppUtils.log('Successfully deleted playlist $playlistId');
      return true; // Trả về true nếu thành công
    } else {
      // Lỗi đã được handleApiError log, nhưng vẫn trả về false ở đây
      AppUtils.log('Failed to delete playlist $playlistId, status: ${response.statusCode}, message: ${response.data?['message']}');
      // Bạn có thể throw Exception ở đây nếu muốn Repository bắt lỗi cụ thể hơn
      // throw Exception(response.data?['message'] ?? 'Failed to delete playlist');
      return false; // Trả về false nếu thất bại
    }
    // handleApiError sẽ tự động xử lý DioException và lỗi 401
  }

  Future<AddTrackResult> addTrackToPlaylist(int playlistId, String trackId) async {
    // Gọi phương thức post kế thừa từ BaseApiService
    // Nó đã bao gồm handleApiError và auth header
    try {
      final response = await post<dynamic>( // Kiểu trả về có thể là dynamic hoặc Map<String, dynamic>
        ApiUrl.addTrackToPlaylist(playlistId), // Lấy URL từ ApiUrl
        data: {'track_id': trackId},          // Body của request
        // options: getOptions() // Không cần thiết, post đã tự gọi
      );

      // Xử lý kết quả dựa trên status code và body response từ backend của bạn
      if (response.statusCode == 200 || response.statusCode == 201) {
          // Kiểm tra thêm status trong body nếu backend trả về {status: 1, ...}
          if (response.data != null && response.data['status'] == 1) {
             AppUtils.log('Successfully added track $trackId to playlist $playlistId via API.');
             return AddTrackResult.success;
          } else {
             AppUtils.log('API indicated failure adding track (status != 1 or missing). Response: ${response.data}');
             return AddTrackResult.failure;
          }
      } else if (response.statusCode == 409) { // Conflict - Track đã tồn tại
          AppUtils.log('Track $trackId already exists in playlist $playlistId (409 Conflict).');
          return AddTrackResult.alreadyExists;
      } else {
          // Các lỗi khác (403, 404, 500...)
          AppUtils.log('Failed to add track. API returned status ${response.statusCode}. Response: ${response.data}');
          // handleApiError có thể đã log lỗi, nhưng ta trả về failure ở đây
          return AddTrackResult.failure;
      }
    } catch (e) {
       // Lỗi DioException hoặc lỗi khác đã được handleApiError log
       // Chỉ cần trả về failure
       AppUtils.log('Exception caught during addTrackToPlaylist API call: $e');
       return AddTrackResult.failure;
    }
  }

  Future<Map<String, dynamic>> updatePlaylist(int playlistId, String newName) async {
    return handleApiError(() async {
      AppUtils.log('API Request to ${ApiUrl.updatePlaylist(playlistId)} with data: {"name": "$newName"}');

      final response = await put<dynamic>(
        ApiUrl.updatePlaylist(playlistId),
        data: {'name': newName},
      );

      AppUtils.log('API Response from update playlist: ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == 1) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update playlist');
      }
    });
  }

  // Listening History API
  Future<Map<String, dynamic>> getListeningHistory() async {
    return handleApiError(() async {
      final response = await get(ApiUrl.listeningHistory);
      return response.data;
    });
  }

  Future<bool> addTrackToHistory(String trackId) async {
    return handleApiError(() async {
      final response = await post(
        ApiUrl.addToHistory,
        data: {'track_id': trackId},
      );
      return response.statusCode == 200;
    });
  }

  Future<bool> removeTrackFromHistory(String trackId) async {
    return handleApiError(() async {
      final response = await delete(
        ApiUrl.removeFromHistory,
        query: {'track_id': trackId},
      );
      return response.statusCode == 200;
    });
  }

  Future<bool> clearHistory() async {
    return handleApiError(() async {
      final response = await delete(ApiUrl.clearHistory);
      return response.statusCode == 200;
    });
  }
  
}


// NotificationApiService handles all notification-related API operations
class NotificationApiService extends BaseApiService {
    // ... (code của NotificationApiService giữ nguyên) ...
    Future<List<NotificationModel>> getNotifications({Map<String, dynamic>? query}) async {
    return handleApiError(() async {
      final res = await get(ApiUrl.notifications, query: query);
      final data = res.data['data'] as List;
      var items = data.map((e) => NotificationModel.fromMap(e)).toList();
      return items;
    });
  }

  Future<bool> markRead(String id) async {
    return handleApiError(() async {
      final res = await post(ApiUrl.markRead(),data: {"id":id});
      return res.statusCode == 200;
    });
  }

  Future<NotificationModel> detailNotify(String id) async {
    return handleApiError(() async {
      final res = await get(ApiUrl.detailNotify(id));
      return NotificationModel.fromMap(res.data['data']);
    });
  }

  Future<bool> deleteNotify(String id) async {
    return handleApiError(() async {
      final res = await delete(ApiUrl.detailNotify(id));
      return res.statusCode == 200;
    });
  }

  Future<int> numberUnread() async {
    try {
      final res = await get(ApiUrl.numberUnread);
      return res.data['data']['unread_notifications'];
    } catch (e) {
      return 0;
    }
  }

  Future<void> markReadAll(String id) async {
    return handleApiError(() async {
      await patch(ApiUrl.markReadAll(id));
    });
  }
}

// CarApiService handles all car-related API operations
class CarApiService extends BaseApiService {
   // ... (code của CarApiService giữ nguyên) ...
     Future<List<CarModel>> getListCar({Map<String, dynamic>? params}) async {
    return handleApiError(() async {
      // Log the API call for debugging
      AppUtils.log('Calling /api/cars with params: $params');
      final response = await get(ApiUrl.listCar, query: params);

      // Check if response contains expected data format
      if (response.data['data'] == null ||
          response.data['data']['cars'] == null) {
        AppUtils.log('Unexpected API response format: ${response.data}');
        return [];
      }

      final carResponse = CarResponse.fromJson(response.data);
      return carResponse.cars;
    });
  }

  Future<List<ReviewListingModel>> getReviewList(int carId, {Map<String, dynamic>? params}) async {
    return handleApiError(() async {
      // Log the API call for debugging
      AppUtils.log('Calling /api/review with params: $params');
      AppUtils.log('Url ${ApiUrl.listReview}/$carId');
      final response = await get("${ApiUrl.listReview}/$carId", query: params);
      // Check if response contains expected data format
      if (response.data['data'] == null ||
          response.data['data']['reviews'] == null) {
        AppUtils.log('Unexpected API response format: ${response.data}');
        return [];
      }

      final List<dynamic> reviewListJson = response.data['data']['reviews'];
      return reviewListJson.map((json) => ReviewListingModel.fromMap(json)).toList();
    });
  }

  Future<List<CarModel>> getWishlistCar() async {
    return handleApiError(() async {
      final response = await get(ApiUrl.wishlistCar);
      final List<dynamic> carListJson = response.data['data']['cars'];
      return carListJson.map((json) => CarModel.fromJson(json)).toList();
    });
  }

  Future<bool> createReview(FormData body, String carId) async {
    return handleApiError(() async {
      final response = await post("${ApiUrl.createReview}/$carId",data: body);
      return response.data['status']==1;
    });
  }

  // Future<CalculateFeeModel?> calculateFee(Map<String, dynamic> body) async {
  //   return handleApiError(() async {
  //     final response = await post(ApiUrl.calculateFee,data: body);
  //     return CalculateFeeModel.fromMap(response.data);
  //   });
  // }

  Future<List<CarModel>> getRecommendedCar() async {
    return handleApiError(() async {
      final response = await get(ApiUrl.rerecommendedCar);
      final List<dynamic> carListJson = response.data['data']['cars'];
      return carListJson.map((json) => CarModel.fromJson(json)).toList();
    });
  }

  Future<List<Brand>> getCarBrands() async {
    return handleApiError(() async {
      final response = await get(ApiUrl.carBrands);
      final List<dynamic> brands = response.data['data']['brands'];
      return brands.map((json) => Brand.fromJson(json)).toList();
    });
  }

  Future<List<LocationCar>> getCarLocation() async {
    return handleApiError(() async {
      final response = await get(ApiUrl.carLocation);
      final List<dynamic> location = response.data['data']['locations'];
      return location.map((json) => LocationCar.fromJson(json)).toList();
    });
  }

  Future<CarDetailResponse> getCarDetail(int id) async {
    return handleApiError(() async {
      debugPrint("Calling car detail API with ID: $id");
      final response = await get(ApiUrl.carDetail(id));
      debugPrint("Car detail API response: ${response.data}");

      try {
        return CarDetailResponse.fromJson(response.data);
      } catch (e) {
        debugPrint("Error converting response to CarDetailResponse: $e");
        rethrow;
      }
    });
  }

  Future<CarFiltersResponse> getCarFilters() async {
    return handleApiError(() async {
      final response = await get(ApiUrl.carFilters);
      return CarFiltersResponse.fromJson(response.data);
    });
  }
}

// VoucherApiService handles all voucher-related API operations
class VoucherApiService extends BaseApiService {
    // ... (code của VoucherApiService giữ nguyên) ...
    Future<VoucherResponse> getVoucher() async {
    return handleApiError(() async {
      final response = await get(ApiUrl.voucher);
      return VoucherResponse.fromJson(response.data);
    });
  }
}

// BookingApiService handles all booking-related API operations
class BookingApiService extends BaseApiService {
   // ... (code của BookingApiService giữ nguyên) ...
     Future<Map<String,dynamic>?> checkCarAvailability(Map<String, dynamic> body) async {
    return handleApiError(() async {
      final response = await post(
        ApiUrl.checkCarAvailability,
        data: body,
      );
      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    });
  }

  Future<BookingResponse?> addToCart(Map<String, dynamic> body) async {
    return handleApiError(() async {
      final response = await post(
        ApiUrl.addToCart,
        data: body,
      );
      return BookingResponse.fromJson(response.data);
    });
  }

  Future<bool> doCheckout(Map<String, dynamic> body) async {
    return handleApiError(() async {
      final response = await post(
        ApiUrl.doCheckout,
        data: body,
      );
      return response.data["url"].toString().contains("thankyou");
    });
  }
}

class ApiProvider {
  // ... (code của ApiProvider giữ nguyên) ...
  // Private constructor for singleton
  ApiProvider._internal();

  static final ApiProvider _instance = ApiProvider._internal();

  // Singleton accessor
  factory ApiProvider() => _instance;

  // Service instances
  static final UserApiService _userService = UserApiService();
  static final NotificationApiService _notificationService =NotificationApiService();
  // static final MessageApiService _messageService = MessageApiService();
  static final CarApiService _carService = CarApiService();
  // static final LifestyleApiService _lifestyleService = LifestyleApiService();
  // static final FeedbackApiService _feedbackService = FeedbackApiService();
  static final HistoryApiService _historyService = HistoryApiService();
  // User API methods
  static Future<bool> sendOtp(String phone, String countryCode) =>
      _userService.sendOtp(phone, countryCode);

  static Future<dynamic> verify(String userId, String otp, String deviceName) =>
      _userService.verify(userId, otp, deviceName);

  static Future<String?> refreshToken() => _userService.refreshToken();

  static Future<void> logout() => _userService.logout();

  static Future<UserModel> getDetail({String? userId}) => _userService.getDetail();

  static Future<UserModel?> updateUser(Map<String, dynamic> data) =>
      _userService.updateUser(data);

   static Future<UserModel> updateUserProfile(Map<String, dynamic> data) =>
      _userService.updateUserProfile(data);

  static Future<bool> verifyInformation(Map<String, dynamic> data) =>
      _userService.verifyInformation(data);

  static Future<int?> uploadFile(File file, {int? folderId}) =>
      _userService.uploadFile(file, folderId: folderId);

  static Future<UserModel> uploadAvatar(Uint8List bytes) =>
      _userService.uploadAvatar(bytes);

  static Future<bool> addAddress(String address, String apartment) =>
      _userService.addAddress(address, apartment);

  static Future<bool> toggleNotify(bool val) => _userService.toggleNotify(val);

  static Future<UserModel> deleteRecipient() => _userService.deleteRecipient();

  static Future<UserModel> restoreRecipient() =>
      _userService.restoreRecipient();

  static Future<Dashboard> getDashboard() => _userService.getDashboard();

  static Future<dynamic> register(String name, String email, String password, String deviceName) =>
      _userService.register(name,email,password, deviceName);

  static Future<dynamic> resendOtp(String phone) =>
      _userService.resendOtp(phone);

  static Future<dynamic> setPassword(String phone, String otp, String password,
          String passwordConfirmation, String userId, String deviceName) =>
      _userService.setPassword(
          phone, otp, password, passwordConfirmation, userId, deviceName);

  static Future<dynamic> forgotPassword(String phone) =>
      _userService.forgotPassword(phone);

  static Future<dynamic> forgotPasswordEmail(String email) =>
      _userService.forgotPasswordEmail(email);

  static Future<dynamic> resetPassword(String phone,
          String password, String passwordConfirmation) =>
      _userService.resetPassword(phone, password, passwordConfirmation);

  static Future<dynamic> resetPasswordEmail(String email,
          String password, String passwordConfirmation) =>
      _userService.resetPasswordEmail(email, password, passwordConfirmation);

  static Future<dynamic> login(
          String email, String password, String deviceName) =>
      _userService.login(email, password, deviceName);

  static Future<dynamic> changePassword(String currentPassword,
          String newPassword, String newPasswordConfirmation) =>
      _userService.changePassword(
          currentPassword, newPassword, newPasswordConfirmation);

  // static Future<BookingHistoryResponse> getBookingHistory() =>
  //     _userService.getBookingHistory();

  // static Future<bool> cancelBooking(int id) => _userService.cancelBooking(id);

  static Future<bool> saveWishlist(int id) => _userService.saveWishlist(id);

  // Notification API methods
  static Future<List<NotificationModel>> getNotifications({Map<String, dynamic>? query}) =>
      _notificationService.getNotifications(query: query);

  static Future<bool> markRead(String id) => _notificationService.markRead(id);

  static Future<NotificationModel> detailNotify(String id) =>
      _notificationService.detailNotify(id);

  static Future<bool> deleteNotify(String id) =>
      _notificationService.deleteNotify(id);

  static Future<int> numberUnread() => _notificationService.numberUnread();

  static Future<void> markReadAll(String id) =>
      _notificationService.markReadAll(id);

  // Message API methods
  // static Future<List<MessageModel>> sentMessage(String content) =>
  //     _messageService.sentMessage(content);

  // Car API methods
  static Future<List<CarModel>> getListCar({Map<String, dynamic>? params}) {
    return _carService.getListCar(params: params);
  }

  static Future<List<ReviewListingModel>> getReviewList(int carId, {Map<String, dynamic>? params}) {
    return _carService.getReviewList(carId,params: params);
  }

  static Future<bool> createReview(FormData params, String carId) {
    return _carService.createReview(params,carId);
  }

  // static Future<CalculateFeeModel?> calculateFee(Map<String, dynamic> body) {
  //   return _carService.calculateFee(body);
  // }

  static Future<List<CarModel>> getWishlistCar() =>
      _carService.getWishlistCar();

  static Future<List<CarModel>> getRecommendedCar() =>
      _carService.getRecommendedCar();

  static Future<List<Brand>> getCarBrands() => _carService.getCarBrands();

  // static Future<List<LocationCar>> getCarLocation() =>
  //     _carService.getCarLocation();

  static Future<CarDetailResponse> getCarDetail(int id) =>
      _carService.getCarDetail(id);

  static Future<CarFiltersResponse> getCarFilters() =>
      _carService.getCarFilters();

  // Lifestyle API methods
  // static Future<List<LifestyleItem>> getLifeStyle() =>
  //     _lifestyleService.getLifeStyle();

  // static Future<List<cate.Category>> getCateLifeStyle() =>
  //     _lifestyleService.getCateLifeStyle();

  // static Future<LifeDetail> getDetailLifeStyle(int idPost) =>
  //     _lifestyleService.getDetailLifeStyle(idPost);

  // Voucher API methods
  // static Future<VoucherResponse> getVoucher() => _voucherService.getVoucher();

  // static Future<List<address.AddressModel>> getAddressListFromPosition(
  //         double latitude, double longitude) =>
  //     _addressService.getAddressListFromPosition(latitude, longitude);

  // static Future<List<address.AddressModel>> getAddressListFromSearchText(
  //         String searchText) =>
  //     _addressService.getAddressListFromSearchText(searchText);

  // static Future<location.LocationModel?> getPositionFromAddress(
  //         address.AddressModel address) =>
  //     _addressService.getPositionFromAddress(address);

  //Booking API methods
  // static Future<Map<String,dynamic>?> checkCarAvailability(Map<String, dynamic> body) =>
  //     _bookingService.checkCarAvailability(body);

  // static Future<BookingResponse?> addToCart(Map<String, dynamic> body) =>
  //     _bookingService.addToCart(body);

  // static Future<bool> doCheckout(Map<String, dynamic> body) =>
  //     _bookingService.doCheckout(body);

  // static Future<bool> sendFeedback(Map<String, dynamic> body) =>
  //     _feedbackService.sendFeedback(body);

  static Future<dynamic> createPlaylist(String name) =>
    _userService.createPlaylist(name);

  static Future<Map<String, dynamic>> getPlaylists() => _userService.getPlaylists();

  // Đảm bảo dòng này gọi đúng hàm trong _userService
  static Future<bool> removeTrackFromPlaylist(int playlistId, String trackId) =>
      _userService.removeTrackFromPlaylist(playlistId, trackId);
  
  static Future<bool> deletePlaylist(int playlistId) =>
      _userService.deletePlaylist(playlistId);
  static Future<AddTrackResult> addTrackToPlaylist(int playlistId, String trackId) =>
      _userService.addTrackToPlaylist(playlistId, trackId);


  static Future<Map<String, dynamic>> getFavorites() => _userService.getFavorites();
  static Future<bool> addToFavorite(String trackId) => _userService.addToFavorite(trackId);
  static Future<bool> removeFavorite(String songId) => _userService.removeFavorite(songId);

  static Future<Map<String, dynamic>> updatePlaylist(int playlistId, String newName) =>
      _userService.updatePlaylist(playlistId, newName);

  // Listening History API methods
  static Future<Map<String, dynamic>> getListeningHistory() =>_historyService.getListeningHistory();
  static Future<List<String>> getRecentHistory() => _historyService.getRecentHistory();
  static Future<bool> addTrackToHistory(String trackId) =>_historyService.addTrackToHistory(trackId);
  static Future<bool> removeTrackFromHistory(String trackId) => _historyService.removeTrackFromHistory(trackId);
  static Future<bool> clearHistory() => _historyService.clearHistory();
  static Future<FavoriteGenreResponse> getFavoriteGenre() => _userService.getFavoriteGenre();
}