class AuthResult {
  final bool success;
  final String? errorMessage;
  final List<String> deviceIds;

  AuthResult.success({
    this.deviceIds = const [],
  })  : success = true,
        errorMessage = null;

  AuthResult.failure(this.errorMessage)
      : success = false,
        deviceIds = const [];
}