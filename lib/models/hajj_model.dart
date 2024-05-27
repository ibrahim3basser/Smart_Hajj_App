class HajjModel{
  String name;
  String description;
  List<String> details;


HajjModel({
  required this.name,
  required this.description,
  required this.details,

});

factory HajjModel.fromJson(json){
  return HajjModel(
    name: json['name'] as String,
    description: json['description'] as String,
    details: json['details'].cast<String>(),
   
  );
}
}
