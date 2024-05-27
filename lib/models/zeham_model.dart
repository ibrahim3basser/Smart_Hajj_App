class ZehamModel {
  List<double> sahn;
  List<double> ardi;
  List<double> sath;
  List<double> madina;

  ZehamModel({
    required this.sahn,
    required this.ardi,
    required this.sath,
    required this.madina,
  });

   factory ZehamModel.fromJson(Map<String, dynamic> json) {
    return ZehamModel(
      sahn: List<double>.from(json['sahn'].map((x) => x.toDouble())),
      ardi: List<double>.from(json['ardi'].map((x) => x.toDouble())),
      sath: List<double>.from(json['sath'].map((x) => x.toDouble())),
      madina: List<double>.from(json['madina'].map((x) => x.toDouble())),
    );
  }
}

