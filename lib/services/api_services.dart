import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:safe_view/models/generate_code_model.dart';
import 'package:safe_view/models/get_content_filter_model.dart';
import 'package:safe_view/models/get_kids_activities_model.dart';
import 'package:safe_view/models/info_model.dart';
import 'package:safe_view/models/pairing_status_model.dart';
import 'package:safe_view/models/send_kids_activities.dart';
import 'package:safe_view/models/show_videos_model.dart';
import 'package:safe_view/models/update_content_filter_model.dart';
import 'package:safe_view/models/verify_code_model.dart';
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

    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "childDeviceId": childDeviceId,
        }));

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

    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "code": pairingCode,
          "parentDeviceId": parentDeviceId,
        }));
    log("response.......${response.body}");
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
      {required String childDeviceId, required String searchKey}) async {
    final url = Uri.parse(
        ApiUrls.showVideoUrl(childDeviceId: childDeviceId, query: searchKey));

    final response = await http.get(
      url,
      headers: header,
    );
    // log("response:::::::${response.body}");
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      final modelResponse = ShowVideosModel.fromJson(decodedResponse);

      return ApiResponse<ShowVideosModel>(data: modelResponse, error: false);
    } else {
      return ApiResponse<ShowVideosModel>(error: true);
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
}


