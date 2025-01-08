class MediaFile {
  late final String path;
  final bool isVideo;

  MediaFile(this.path, {this.isVideo = false});
}

class Tag {
  final String name;

  Tag(this.name);
}
