import 'package:barback/barback.dart';
import 'dart:async';

class UpdateHtml extends Transformer {
  UpdateHtml.asPlugin();

  String get allowedExtensions => '.html';

  String fixSliders(String document) {
    Set<String> tagsToReplace = new Set();
    Iterable<Match> inputTags = '<input'.allMatches(document, 0);
    for (Match item in inputTags) {
      int found = item.start;
      int end = document.indexOf('>', found);
      String tag = (document.substring(found, end + 1));
      if (tag.contains('range') && tag.contains('mdl-slider')) {
        tagsToReplace.add(tag);
      }
    }
    for (String tag in tagsToReplace) {
      String template = '''<div class="mdl-slider__container">
$tag
<div class="mdl-slider__background-flex">
  <div class="mdl-slider__background-lower"></div>
  <div class="mdl-slider__background-upper"></div>
</div>
</div>''';
      document = document.replaceAll(tag, template);
    }
    return document;
  }

  Future apply(Transform transform) async {
    String content = await transform.primaryInput.readAsString();
    AssetId id = transform.primaryInput.id;
    content = fixSliders(content);
    transform.addOutput(new Asset.fromString(id, content));
  }
}
