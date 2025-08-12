class ApiUrls {
  static const String baseUrl = "https://safeview-backend.onrender.com";

  static String generateCodeUrl = "$baseUrl/pairing/generate-code";
  static String verifyCodeUrl = "$baseUrl/pairing/verify-code";

  static String pairingStatusUrl({required String deviceId}) {
    return "$baseUrl/pairing/status/$deviceId";
  }

  static String infoUrl({required String parentDeviceId}) {
    return "$baseUrl/pairing/me/$parentDeviceId";
  }

  static String updateContentFiltersUrl = "$baseUrl/content/update";

  static String getContentFilterUrl({required String childDeviceId}) {
    return "$baseUrl/content/$childDeviceId";
  }

//(http://localhost:3000/youtube/search?query=science&maxResults=5&childDeviceId=child-child-q987678&page=1&limit=6')
  static String showVideoUrl(
      {required String childDeviceId,
      required String query,
      required int pageNumber}) {
    return  query.isNotEmpty
        ? "$baseUrl/youtube/search?query=$query&childDeviceId=$childDeviceId&page=$pageNumber&limit=3"
        : "$baseUrl/youtube/search?childDeviceId=$childDeviceId&page=$pageNumber&limit=3";
  }

  static String sendKidsActivitiesUrl = "$baseUrl/activity/log";

  static String getKidsActivitiesUrl({required String childDeviceId}) {
    return "$baseUrl/activity/history/$childDeviceId";
  }

  static String setPinUrl = "$baseUrl/pairing/set-pin";
  static String verifyPinUrl = "$baseUrl/pairing/verify-pin";
  static String unlinkDeviceUrl({required String childDeviceId}) {
    return "$baseUrl/pairing/unlink/$childDeviceId";
  }

  static String createParentProfileUrl = "$baseUrl/api/parent-profile";
  static String editGetParentProfileUrl({required String parentDeviceId}) {
    return "$baseUrl/api/parent-profile/$parentDeviceId";
  }

  static String upgradeUrl = "$baseUrl/api/upgrade/interest";
  static String trackTimeLimitUrl = "$baseUrl/limit/track";
  static String getRemainingTimeUrl({required String childDeviceId}) {
    return "$baseUrl/limit/$childDeviceId";
  }

  static String trailStatusUrl({required String parentDeviceId}) {
    return "$baseUrl/api/parent-profile/$parentDeviceId";
  }

   static String deleteHistoryUrl({required String childDeviceId}) {
    return "$baseUrl/activity/clear/$childDeviceId";
  }
}
