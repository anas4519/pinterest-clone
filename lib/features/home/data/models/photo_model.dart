class PhotoModel {
  final int id;
  final String description;
  final String url;
  final String srcMedium;
  final String srcLarge;
  final int width;
  final int height;

  PhotoModel({
    required this.id,
    required this.description,
    required this.url,
    required this.srcMedium,
    required this.srcLarge,
    required this.width,
    required this.height,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'],
      description: json['alt'] ?? '',
      url: json['url'],
      srcMedium: json['src']['medium'],
      srcLarge: json['src']['large2x'],
      width: json['width'],
      height: json['height'],
    );
  }
}
