enum AttachmentType { Image, Video }

class Attachment {
  static List<Attachment> toList(List<dynamic> data) {
    return data.map((e) => Attachment.json(e)).toList();
  }

  final AttachmentType type;
  final String url;

  Attachment(this.type, this.url);

  Attachment.json(data)
      : this(AttachmentType.values[data['type']], data['url']);
}
