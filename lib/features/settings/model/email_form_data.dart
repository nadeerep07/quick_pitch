class EmailFormData {
  final String newEmail;
  final String currentPassword;

  EmailFormData({required this.newEmail, required this.currentPassword});
}
class PasswordFormData {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  PasswordFormData({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });
}