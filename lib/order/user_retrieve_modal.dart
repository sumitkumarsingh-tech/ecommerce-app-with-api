 class UserRetrieveModal{

   final int user_id;
   final String user_name;
   final String user_email;
   final String user_phone;
   final String user_address;

   UserRetrieveModal(
      {required this.user_id,
      required this.user_name,
     required this.user_email,
     required  this.user_phone,
      required this.user_address});

   factory UserRetrieveModal.fromJson(Map<String,dynamic> json){
     return UserRetrieveModal(
         user_id: json["user_id"],
         user_name: json["user_name"],
         user_email: json["user_email"],
         user_phone: json["user_phone"],
         user_address: json["user_address"]);

   }



 }