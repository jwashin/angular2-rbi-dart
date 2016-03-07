/// probably not very efficient, but works.
/// angular2_rbi transformer goes before angular2 transformer in pubspec.yaml
/// only works on .html files, not templates in .dart files
/// only necessary for slider, menu

import 'dart:async';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:barback/barback.dart';

class UpdateHtml extends Transformer {
  UpdateHtml.asPlugin();

  Document document;

  String get allowedExtensions => '.html';

  Future apply(Transform transform) async {
    String content = await transform.primaryInput.readAsString();
    // use lowercaseAttrName so that [(ngModel)] doesn't become [(ngmodel)]
    HtmlParser parser = new HtmlParser(content, lowercaseAttrName: false);
    document = parser.parse();
    fixMenus();
    fixSliders();
    fixButtons();
    AssetId id = transform.primaryInput.id;
    transform.addOutput(new Asset.fromString(id, document.outerHtml));
  }

  void fixButtons() {
    // just so we don't don't need Button and ButtonNoRipple classes
    List<Element> buttons = document.querySelectorAll('button.mdl-button');
//    print('buttons: ${buttons.length}');
    for (Element button in buttons) {
      if (button.classes.contains('mdl-js-ripple-effect')) {
        button.attributes.addAll({'[ripple]': 'true'});
      }
    }
  }

  void fixMenus() {
    List<Element> menus = document.querySelectorAll('ul.mdl-js-menu');
    String projection;
    for (Element element in menus) {
      for (String className in element.classes) {
        if (className.startsWith('mdl-menu--')) {
          projection = "'${className.split('--')[1]}'";
        }
      }
      String elFor;
      for (String attr in ['mdl-for', 'for', 'data-for']) {
        elFor = element.attributes[attr];
        if (elFor != null && elFor.isNotEmpty) {
          break;
        }
      }
      if (elFor == null || elFor.isEmpty) {
        continue;
      }
      Element prevButton = document.querySelector('#$elFor');
      bool hasPrevButton =
          prevButton != null && prevButton.localName == 'button';
      if (hasPrevButton) {
        Element parent = prevButton.parent;
        Element newDiv = new Element.tag('rbi-menu-manager');
        parent.insertBefore(newDiv, prevButton);
        Element buttonContainer = new Element.tag('rbi-menu-button');
        buttonContainer.append(prevButton);
        newDiv.append(buttonContainer);
        Element menuContainer = new Element.tag('rbi-menu-container');
        menuContainer.attributes.addAll({'[projection]': projection});
        if (element.classes.contains('mdl-js-ripple-effect')) {
          menuContainer.attributes.addAll({'[ripple]': 'true'});
        }
        menuContainer.append(element);
        newDiv.append(menuContainer);
      }
    }
  }

  void fixSliders() {
    List<Element> sliders = document.querySelectorAll('.mdl-slider');
    for (Element element in sliders) {
      Element parent = element.parent;
      Element container = new Element.tag('div');
      container.classes.add('mdl-slider__container');
      parent.append(container);
      container.append(element);
      Element backgroundFlex = new Element.tag('div');
      backgroundFlex.classes.add('mdl-slider__background-flex');
      Element backgroundLower = new Element.tag('div');
      backgroundLower.classes.add('mdl-slider__background-lower');
      backgroundFlex.append(backgroundLower);
      Element backgroundUpper = new Element.tag('div');
      backgroundUpper.classes.add('mdl-slider__background-upper');
      backgroundFlex.append(backgroundUpper);
      container.append(backgroundFlex);
    }
  }
}
