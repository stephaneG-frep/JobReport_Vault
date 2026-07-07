import 'package:flutter/foundation.dart';

import '../models/attachment.dart';

class AttachmentProvider extends ChangeNotifier {
  List<Attachment> _attachments = [];

  List<Attachment> get attachments => _attachments;

  void replace(List<Attachment> attachments) {
    _attachments = attachments;
    notifyListeners();
  }
}
