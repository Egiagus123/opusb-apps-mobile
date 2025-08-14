class AuthConstant {
  static const String authenticationKey = 'jwt0';
  static const String authorizationKey = 'jwt1';
  static const String usernameKey = 'username';
  static const String passwordKey = 'password';
  static const String clientKey = 'client';
  static const String roleKey = 'role';
  static const String organizationKey = 'organization';
  static const String pinKey = 'pin';
  static const bool fingerOn = false;

  // TODO Try to use i18n.
  static const String invalidCredentialsMessage =
      'Invalid username and/or password';
  static const String authenticationFailedMessage =
      'Server error when authenticating the user';
  static const String sessionExpiredMessage = 'Login session has been expired';
  static const String unauthorizedUserMessage = 'User is unauthorized';
}
