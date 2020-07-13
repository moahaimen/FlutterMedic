enum AttachmentType { Image, Video }

class Attachment {
  final AttachmentType type;
  final String url;

  Attachment(this.type, this.url);
}
