
 class CatModal{

  final int cat_id;
  final String cat_name;
  final String imagePath;

  CatModal({required this.cat_id, required this.cat_name,required this.imagePath});

  factory CatModal.fromJson(Map<String ,dynamic> json){

    return CatModal(cat_id: json["category_id"], cat_name: json["category_title"],imagePath: json['imagePath']);
  }

 }