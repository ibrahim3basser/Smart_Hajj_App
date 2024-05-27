class DoaaModel {
  String text;
   String audio ;

  DoaaModel({
    required this.text,
    required this.audio,
  });

   factory DoaaModel.fromJson( json) {
      return DoaaModel(
        text: json['text']  as String,
        audio: json['audio']as String,
      );
  
  }
}