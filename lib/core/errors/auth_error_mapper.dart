String mapFirebaseError(String error) {
  if (error.contains('email-already-in-use')) {
    return 'This email is already registered.';
  } else if (error.contains('invalid-email')) {
    return 'The email address is not valid.';
  } else if (error.contains('weak-password')) {
    return 'The password is too weak.';
  } else if (error.contains('network-request-failed')) {
    return 'Network error. Please check your connection.';
  } else if (error.contains('user-not-found')) {
    return 'No account found for this email.';
  } else if (error.contains('wrong-password')) {
    return 'Incorrect password. Please try again.';
  } else if (error.contains('invalid-credential')) {
    return 'Invalid email or password. Please try again.';
  } else if (error.contains('too-many-requests')) {
    return 'Too many login attempts. Please wait a few minutes before trying again.';
  } else {
    return 'Something went wrong. Please try again.';
  }
}
