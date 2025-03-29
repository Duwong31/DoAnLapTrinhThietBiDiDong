class CreateUserReq {
  final String fullname;
  final String phone;
  final String email;
  final String password;
  CreateUserReq({
    required this.fullname,
    required this.phone,
    required this.email,
    required this.password,
  });
}