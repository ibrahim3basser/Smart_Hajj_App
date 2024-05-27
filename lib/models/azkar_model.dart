class AzkarModel {
  String zekr;
  String repeat;
  String? bless;

  AzkarModel({
    required this.zekr,
    required this.repeat,
     this.bless,
  });

   factory AzkarModel.fromJson( json) {
      return AzkarModel(
      zekr: json['zekr'] as String,
      repeat: json['repeat'] as String,
      bless: json['bless'] as String?,
      );
  
  }
}
 