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

  static String showVideoUrl(
      {required String childDeviceId, required String query}) {
    return "$baseUrl/youtube/search?query=$query&maxResults=5&childDeviceId=$childDeviceId";
  }

  static String sendKidsActivitiesUrl = "$baseUrl/activity/log";

   static String getKidsActivitiesUrl(
      {required String childDeviceId}) {
    return "$baseUrl/activity/history/$childDeviceId";
  }
 
 
}
