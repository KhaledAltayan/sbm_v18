class ApiUrls {
  static const String _baseUrl = 'http://192.168.225.78:8000';

  // Auth

  // static const String signIn = '$_baseUrl/auth/login';
  // static const String signUp = '$_baseUrl/api/auth/register';

  //Task
  static const String getMeetings = '$_baseUrl/api/meeting/get-meeting';
  static const String createMeeting = '$_baseUrl/api/meeting/create';
  static const String recordMeeting = '$_baseUrl/api/meeting/recording-meeting';
  static const String searchUserByEmail =
      '$_baseUrl/api/auth/search-user-by-email';
  static const String searchMeetings = '$_baseUrl/api/meeting/search-by-date';
static const String respondToCreatorInvitation = '$_baseUrl/api/invitation/respond-to-join-request';
static const String inviteByCreator = '$_baseUrl/api/invitation/invite-by-creator';
static const String responseUser = '$_baseUrl/api/invitation/ask-to-join-using-fcm';

  static const String register = '$_baseUrl/api/auth/register';
  static const String login = '$_baseUrl/api/auth/login';
  static const String logout = '$_baseUrl/api/auth/logout';
  static const String askToJoin = '$_baseUrl/api/invitation/ask-to-join';
  // static const String login = '$_baseUrl/api/auth/login';
  // static const String register = '$_baseUrl/api/auth/register';

  static const String token =
      '30|7SdglaiemK2Fm3Svo7EU3bOB0ujo6ed7pGv6ZlFM7df08cd9';
}
