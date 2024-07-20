
class UserModal{

  final String name;
  final String email;
  final String phone;
  final String address;
  final String password;

  UserModal(
      {
      required this.name,
      required this.email,
      required this.phone,
      required this.address,
      required this.password});

factory UserModal.fromJson(Map<String,dynamic> json){
  
  return UserModal(name: json["user_name"], email: json["user_email"], phone: json["user_phone"], address: json["user_address"], password: json["user_password"]);
}


}

