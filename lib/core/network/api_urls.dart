class ApiUrls {
  static const String _baseUrl = 'http://10.0.2.2:8000';

  // Auth

  static const String signIn = '$_baseUrl/auth/login';
  static const String signUp = '$_baseUrl/api/auth/register';

  //Task
  static const String addTask = '$_baseUrl/task/create-task-user';
  static const String editTask = '$_baseUrl/task/update-task-user';
  static const String deleteTask = '$_baseUrl/task/delete-task';

   static const String token = '11|jnLMGbP1p4WwjgW10BiLD1uOffT8aoSSgaY5HwD52519af2b';
}