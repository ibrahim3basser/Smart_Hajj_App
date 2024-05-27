class UmrahModel{
  String name;
  String description;
  List<String> details;


UmrahModel({
  required this.name,
  required this.description,
  required this.details,

});

factory UmrahModel.fromJson(json){
  return UmrahModel(
    name: json['name'] as String,
    description: json['description'] as String,
    details: json['details'].cast<String>(),
   
  );
}
}