import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:safe_view/models/create_parent_profile_model.dart';
import 'package:safe_view/models/delete_history_model.dart';
import 'package:safe_view/models/edit_parent_profile_model.dart';
import 'package:safe_view/models/generate_code_model.dart';
import 'package:safe_view/models/get_content_filter_model.dart';
import 'package:safe_view/models/get_kids_activities_model.dart';
import 'package:safe_view/models/get_parent_profile_model.dart';
import 'package:safe_view/models/get_remaining_time_model.dart';
import 'package:safe_view/models/info_model.dart';
import 'package:safe_view/models/pairing_status_model.dart';
import 'package:safe_view/models/send_kids_activities.dart';
import 'package:safe_view/models/set_pin_model.dart';
import 'package:safe_view/models/show_videos_model.dart';
import 'package:safe_view/models/track_time_limit_model.dart';
import 'package:safe_view/models/trail_status_model.dart';
import 'package:safe_view/models/unlink_device_model.dart';
import 'package:safe_view/models/update_content_filter_model.dart';
import 'package:safe_view/models/upgrade_model.dart';
import 'package:safe_view/models/verify_code_model.dart';
import 'package:safe_view/models/verify_pin_model.dart';
import 'package:safe_view/untilities/api_urls.dart';

import '../untilities/api_response.dart';

class ApiService {
  Map<String, String> header = {'Content-Type': 'application/json'};

  Future<Map<String, String>> getHeaders() async {
    final token = await const FlutterSecureStorage().read(key: "token");

    Map<String, String> header = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };
    return header;
  }

  Future<ApiResponse<GenerateCodeModel>> generateCodeService({
    required String childDeviceId,
  }) async {
    final url = Uri.parse(ApiUrls.generateCodeUrl);
    final body = {
      "childDeviceId": childDeviceId,
    };
    final response =
        await http.post(url, headers: header, body: jsonEncode(body));
    print("body of generate code.....$body");
    print("response..............${response.body}");
    if (response.statusCode == 201) {
      final decodedResponse = jsonDecode(response.body);

      final modelResponse = GenerateCodeModel.fromJson(decodedResponse);

      return ApiResponse<GenerateCodeModel>(data: modelResponse, error: false);
    } else {
      return ApiResponse<GenerateCodeModel>(error: true);
    }
  }

  Future<ApiResponse<VerifyCodeModel>> verifyCodeService(
      {required String parentDeviceId, required String pairingCode}) async {
    final url = Uri.parse(ApiUrls.verifyCodeUrl);
    final body = {
      "code": pairingCode,
      "parentDeviceId": parentDeviceId,
    };
    final response =
        await http.post(url, headers: header, body: jsonEncode(body));
    print("body of verify code........$body");
    print("response.........${response.body}");
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      final modelResponse = VerifyCodeModel.fromJson(decodedResponse);

      return ApiResponse<VerifyCodeModel>(data: modelResponse, error: false);
    } else {
      final errorDecodedResponse = jsonDecode(response.body);

      final errorModelResponse = VerifyCodeModel.fromJson(errorDecodedResponse);
      return ApiResponse<VerifyCodeModel>(
          errorMessage: errorModelResponse.message, error: true);
    }
  }

  Future<ApiResponse<PairingStatusModel>> pairingStausService({
    required String deviceId,
  }) async {
    final url = Uri.parse(ApiUrls.pairingStatusUrl(deviceId: deviceId));

    final response = await http.get(
      url,
      headers: header,
    );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      final modelResponse = PairingStatusModel.fromJson(decodedResponse);

      return ApiResponse<PairingStatusModel>(data: modelResponse, error: false);
    } else {
      return ApiResponse<PairingStatusModel>(error: true);
    }
  }

  Future<ApiResponse<InfoModel>> infoService({
    required String parentDeviceId,
  }) async {
    final url = Uri.parse(ApiUrls.infoUrl(parentDeviceId: parentDeviceId));

    final response = await http.get(
      url,
      headers: header,
    );
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      final modelResponse = InfoModel.fromJson(decodedResponse);

      return ApiResponse<InfoModel>(data: modelResponse, error: false);
    } else {
      return ApiResponse<InfoModel>(error: true);
    }
  }

  Future<ApiResponse<UpdateContentFilterModel>> updateContentFilterService(
      {String? childDeviceId,
      bool? allowSearch,
      bool? allowAutoplay,
      bool? blockUnsafeVideos,
      List<String>? blockedCategories,
      int? screenTimeLimit,
      bool? isLocked}) async {
    final url = Uri.parse(ApiUrls.updateContentFiltersUrl);
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "childDeviceId": childDeviceId,
          "allowSearch": allowSearch,
          "allowAutoplay": allowAutoplay,
          "blockedCategories": blockedCategories,
          "blockUnsafeVideos": blockUnsafeVideos,
          "screenTimeLimitMins": screenTimeLimit,
          "isLocked": isLocked
        }));

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      final modelResponse = UpdateContentFilterModel.fromJson(decodedResponse);

      return ApiResponse<UpdateContentFilterModel>(
          data: modelResponse, error: false);
    } else {
      final errorDecodedResponse = jsonDecode(response.body);

      final errorModelResponse =
          UpdateContentFilterModel.fromJson(errorDecodedResponse);
      return ApiResponse<UpdateContentFilterModel>(
          errorMessage: errorModelResponse.message, error: true);
    }
  }

  Future<ApiResponse<GetContentFilterModel>> getContentFilterService({
    required String childDeviceId,
  }) async {
    final url =
        Uri.parse(ApiUrls.getContentFilterUrl(childDeviceId: childDeviceId));

    final response = await http.get(
      url,
      headers: header,
    );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      final modelResponse = GetContentFilterModel.fromJson(decodedResponse);

      return ApiResponse<GetContentFilterModel>(
          data: modelResponse, error: false);
    } else {
      return ApiResponse<GetContentFilterModel>(error: true);
    }
  }

  Future<ApiResponse<ShowVideosModel>> showVideosService(
      {required String childDeviceId,
      required String searchKey,
      required int pageNumber}) async {
    final url = Uri.parse(ApiUrls.showVideoUrl(
        childDeviceId: childDeviceId,
        query: searchKey,
        pageNumber: pageNumber));

    final response = await http.get(
      url,
      headers: header,
    );
    log("response..............${response.body}");
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      if (decodedResponse is String) {
        decodedResponse = jsonDecode(decodedResponse);
      }
      final modelResponse = ShowVideosModel.fromJson(decodedResponse);

      return ApiResponse<ShowVideosModel>(data: modelResponse, error: false);
    } else {
      var decodedResponse = jsonDecode(response.body);

      final modelResponse = ShowVideosModel.fromJson(decodedResponse);
      return ApiResponse<ShowVideosModel>(
          errorMessage: modelResponse.message, error: true);
    }
  }

  Future<ApiResponse<SendKidsActivitiesModel>> sendKidsActivitiesService({
    required childDeviceId,
    required String videoId,
    required String title,
    required String thumbnail,
    required String channelName,
    required int? duration,
  }) async {
    final url = Uri.parse(ApiUrls.sendKidsActivitiesUrl);
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "childDeviceId": childDeviceId,
          "videoId": videoId,
          "title": title,
          "thumbnail": thumbnail,
          "channelName": channelName,
          "duration": duration
        }));

    if (response.statusCode == 201) {
      final decodedResponse = jsonDecode(response.body);

      final modelResponse = SendKidsActivitiesModel.fromJson(decodedResponse);

      return ApiResponse<SendKidsActivitiesModel>(
          data: modelResponse, error: false);
    } else {
      return ApiResponse<SendKidsActivitiesModel>(error: true);
    }
  }

  Future<ApiResponse<List<GetKidsActivitiesModel>>> GetKidsActivitiesService({
    required String childDeviceId,
  }) async {
    final url =
        Uri.parse(ApiUrls.getKidsActivitiesUrl(childDeviceId: childDeviceId));

    final response = await http.get(
      url,
      headers: header,
    );
    log("response.............${response.body}");
    if (response.statusCode == 200) {
      final List decodedResponse = jsonDecode(response.body);

      final List<GetKidsActivitiesModel> modelResponse = decodedResponse
          .map((json) => GetKidsActivitiesModel.fromJson(json))
          .toList();

      return ApiResponse<List<GetKidsActivitiesModel>>(
          data: modelResponse, error: false);
    } else {
      return ApiResponse<List<GetKidsActivitiesModel>>(error: true);
    }
  }

  Future<ApiResponse<SetPinModel>> setPinService(
      {required String parentDeviceId, required String pin}) async {
    final url = Uri.parse(ApiUrls.setPinUrl);

    final response = await http.post(url,
        headers: header,
        body: jsonEncode({"parentDeviceId": parentDeviceId, "pin": pin}));
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      final modelResponse = SetPinModel.fromJson(decodedResponse);

      return ApiResponse<SetPinModel>(data: modelResponse, error: false);
    } else {
      final decodedResponse = jsonDecode(response.body);

      final modelErrorResponse = SetPinModel.fromJson(decodedResponse);
      return ApiResponse<SetPinModel>(
          error: true, errorMessage: modelErrorResponse.message);
    }
  }

  Future<ApiResponse<VerifyPinModel>> verifyPinService(
      {required String parentDeviceId, required String pin}) async {
    final url = Uri.parse(ApiUrls.verifyPinUrl);
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({"parentDeviceId": parentDeviceId, "pin": pin}));

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      final modelResponse = VerifyPinModel.fromJson(decodedResponse);

      return ApiResponse<VerifyPinModel>(data: modelResponse, error: false);
    } else {
      final decodedResponse = jsonDecode(response.body);

      final modelErrorResponse = VerifyPinModel.fromJson(decodedResponse);
      return ApiResponse<VerifyPinModel>(
          error: true, errorMessage: modelErrorResponse.message);
    }
  }

  Future<ApiResponse<UnlinkDeviceModel>> unlinkDeviceService(
      {required String childDeviceId}) async {
    final url =
        Uri.parse(ApiUrls.unlinkDeviceUrl(childDeviceId: childDeviceId));
    final response = await http.delete(
      url,
      headers: header,
    );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      final modelResponse = UnlinkDeviceModel.fromJson(decodedResponse);

      return ApiResponse<UnlinkDeviceModel>(data: modelResponse, error: false);
    } else {
      final decodedResponse = jsonDecode(response.body);

      final modelErrorResponse = UnlinkDeviceModel.fromJson(decodedResponse);
      return ApiResponse<UnlinkDeviceModel>(
          error: true, errorMessage: modelErrorResponse.message);
    }
  }

  Future<ApiResponse<CreateParentProfileModel>> createParentProfileService({
    required String parentDeviceId,
    required String name,
    required String phoneNumber,
    required String email,
    required String childName,
  }) async {
    final url = Uri.parse(ApiUrls.createParentProfileUrl);
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "parentDeviceId": parentDeviceId,
          "name": name,
          "phone": phoneNumber,
          "email": email,
          "kidName": childName
        }));

    if (response.statusCode == 201) {
      final decodedResponse = jsonDecode(response.body);

      final modelResponse = CreateParentProfileModel.fromJson(decodedResponse);

      return ApiResponse<CreateParentProfileModel>(
          data: modelResponse, error: false);
    } else {
      final errorDecodedResponse = jsonDecode(response.body);

      final errorModelResponse =
          CreateParentProfileModel.fromJson(errorDecodedResponse);
      return ApiResponse<CreateParentProfileModel>(
          errorMessage: errorModelResponse.message, error: true);
    }
  }

  Future<ApiResponse<EditParentProfileModel>> editParentProfileService({
    required String parentDeviceId,
    required String name,
    required String phoneNumber,
    required String email,
    required String childName,
  }) async {
    final url = Uri.parse(
        ApiUrls.editGetParentProfileUrl(parentDeviceId: parentDeviceId));
    final response = await http.put(url,
        headers: header,
        body: jsonEncode({
          "name": name,
          "phone": phoneNumber,
          "email": email,
          "kidName": childName
        }));

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      final modelResponse = EditParentProfileModel.fromJson(decodedResponse);

      return ApiResponse<EditParentProfileModel>(
          data: modelResponse, error: false);
    } else {
      final errorDecodedResponse = jsonDecode(response.body);

      final errorModelResponse =
          EditParentProfileModel.fromJson(errorDecodedResponse);
      return ApiResponse<EditParentProfileModel>(
          errorMessage: errorModelResponse.message, error: true);
    }
  }

  Future<ApiResponse<GetParentProfileModel>> getParentProfileService(
      {required String parentDeviceId}) async {
    final url = Uri.parse(
        ApiUrls.editGetParentProfileUrl(parentDeviceId: parentDeviceId));
    final response = await http.put(
      url,
      headers: header,
    );
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      final modelResponse = GetParentProfileModel.fromJson(decodedResponse);

      return ApiResponse<GetParentProfileModel>(
          data: modelResponse, error: false);
    } else {
      final errorDecodedResponse = jsonDecode(response.body);

      final errorModelResponse =
          GetParentProfileModel.fromJson(errorDecodedResponse);
      return ApiResponse<GetParentProfileModel>(
          errorMessage: errorModelResponse.message, error: true);
    }
  }

  Future<ApiResponse<UpgradeModel>> upgradeService({
    required String parentDeviceId,
    required String name,
    required String phoneNumber,
    required String email,
    required String childName,
  }) async {
    final url = Uri.parse(ApiUrls.upgradeUrl);
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "parentDeviceId": parentDeviceId,
          "name": name,
          "phone": phoneNumber,
          "email": email,
          "kidName": childName,
          "message": "Interested in premium"
        }));
    log("response.......${response.body}");
    if (response.statusCode == 201) {
      final decodedResponse = jsonDecode(response.body);

      final modelResponse = UpgradeModel.fromJson(decodedResponse);

      return ApiResponse<UpgradeModel>(data: modelResponse, error: false);
    } else {
      final errorDecodedResponse = jsonDecode(response.body);

      final errorModelResponse = UpgradeModel.fromJson(errorDecodedResponse);
      return ApiResponse<UpgradeModel>(
          errorMessage: errorModelResponse.message, error: true);
    }
  }

  Future<ApiResponse<TrackTimeLimitModel>> trackTimeService({
    required String childDeviceId,
    required int remainingTime,
  }) async {
    final url = Uri.parse(ApiUrls.trackTimeLimitUrl);
    final response = await http.post(url,
        headers: header,
        body: jsonEncode(
            {"childDeviceId": childDeviceId, "duration": remainingTime}));
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      final modelResponse = TrackTimeLimitModel.fromJson(decodedResponse);

      return ApiResponse<TrackTimeLimitModel>(
          data: modelResponse, error: false);
    } else {
      final errorDecodedResponse = jsonDecode(response.body);

      final errorModelResponse =
          TrackTimeLimitModel.fromJson(errorDecodedResponse);
      return ApiResponse<TrackTimeLimitModel>(
          errorMessage: errorModelResponse.message, error: true);
    }
  }

  Future<ApiResponse<GetRemainingTimeModel>> getRemainingTimeService({
    required String childDeviceId,
  }) async {
    final url =
        Uri.parse(ApiUrls.getRemainingTimeUrl(childDeviceId: childDeviceId));
    final response = await http.get(
      url,
      headers: header,
    );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      final modelResponse = GetRemainingTimeModel.fromJson(decodedResponse);

      return ApiResponse<GetRemainingTimeModel>(
          data: modelResponse, error: false);
    } else {
      final errorDecodedResponse = jsonDecode(response.body);

      final errorModelResponse =
          GetRemainingTimeModel.fromJson(errorDecodedResponse);
      return ApiResponse<GetRemainingTimeModel>(
          errorMessage: " errorModelResponse.message", error: true);
    }
  }

  Future<ApiResponse<TrailStatusModel>> trailStatusService({
    required String parentDeviceId,
  }) async {
    final url =
        Uri.parse(ApiUrls.trailStatusUrl(parentDeviceId: parentDeviceId));
    final response = await http.get(
      url,
      headers: header,
    );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      final modelResponse = TrailStatusModel.fromJson(decodedResponse);

      return ApiResponse<TrailStatusModel>(data: modelResponse, error: false);
    } else {
      final errorDecodedResponse = jsonDecode(response.body);

      final errorModelResponse =
          TrailStatusModel.fromJson(errorDecodedResponse);
      return ApiResponse<TrailStatusModel>(
          errorMessage: "Something went wrong", error: true);
    }
  }

  Future<ApiResponse<DeleteHistoryModel>> deleteHistoryService(
      {required String childDeviceId}) async {
    final url =
        Uri.parse(ApiUrls.deleteHistoryUrl(childDeviceId: childDeviceId));
    final response = await http.delete(
      url,
      headers: header,
    );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      final modelResponse = DeleteHistoryModel.fromJson(decodedResponse);

      return ApiResponse<DeleteHistoryModel>(data: modelResponse, error: false);
    } else {
      final decodedResponse = jsonDecode(response.body);

      final modelErrorResponse = DeleteHistoryModel.fromJson(decodedResponse);
      return ApiResponse<DeleteHistoryModel>(
          error: true, errorMessage: modelErrorResponse.message);
    }
  }
}
