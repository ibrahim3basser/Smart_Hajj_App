class AyatModel{
  String text;

  AyatModel({
    required this.text,
  });

  factory AyatModel.fromJson(json) {
    return AyatModel(
      text: json['text'] as String,
    );
  }
}