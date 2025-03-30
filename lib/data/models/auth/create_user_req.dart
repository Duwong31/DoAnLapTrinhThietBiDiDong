class CreateUserReq {
  final String fullname;
  // final String phone;
  final String email;
  final String password;
  final String confirmPassword;
  CreateUserReq({
    required this.fullname,
    // required this.phone,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}