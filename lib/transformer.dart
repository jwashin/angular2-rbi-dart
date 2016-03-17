/// This is where we do things to MDL source that would otherwise require
/// special DOM manipulation for within Angular2.
/// It's probably not very efficient.
/// DO NOT USE with directives side of this project.
/// "angular2_rbi" transformer goes before angular2 transformer in pubspec.yaml
/// only works on .html files, not templates in .dart files
/// required only for Component version of button, slider, menu

import 'dart:async';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:barback/barback.dart';

class UpdateHtml extends Transformer {
  UpdateHtml.asPlugin();

  Document document;

  String get allowedExtensions => '.html';

  Future<dynamic> apply(Transform transform) async {
    String content = await transform.primaryInput.readAsString();
    // lowercaseAttrName: false so [(ngModel)] doesn't become [(ngmodel)]
    HtmlParser parser = new HtmlParser(content, lowercaseAttrName: false);
    document = parser.parse();
    fixMenus();
    fixSliders();
    setRipples();
    AssetId id = transform.primaryInput.id;
    transform.addOutput(new Asset.fromString(id, document.outerHtml));
  }

  //so that we do not have to look up a class at runtime
  void setRipples() {
    List<Element> mdlRipples =
    document.querySelectorAll('.mdl-js-ripple-effect');
    for (Element element in mdlRipples) {
      element.attributes.addAll({'[shouldRipple]': 'true'});
      element.classes.remove('mdl-js-ripple-effect');
    }
  }

  Element cloneWithNewTag(Element element, String newTag) {
    Element newElement = new Element.tag(newTag);
    newElement.classes.addAll(element.classes);
    newElement.attributes.addAll(element.attributes);
    element.reparentChildren(newElement);
    return newElement;
  }

  /// Repackage menu: do the class queries and containerize.
  void fixMenus() {
    List<Element> menus = document.querySelectorAll('.mdl-js-menu');
    String projection;
    String className;
    for (Element element in menus) {
      for (className in element.classes) {
        if (className.startsWith('mdl-menu--')) {
          projection = "'${className.split('--')[1]}'";
          break;
        }
      }
      if (element.classes.contains(className)) {
        element.classes.remove(className);
      }
      element.classes.remove('mdl-menu');
      element.classes.add('rbi-menu');
      String elFor;
      for (String attr in ['data-mdl-for', 'for', 'data-for']) {
        elFor = element.attributes[attr];
        if (elFor != null && elFor.isNotEmpty) {
          break;
        }
      }
      if (elFor == null || elFor.isEmpty) {
        print("found .mdl-js-menu without 'for', 'data-mdl-for' or"
            " 'data-for' attribute");
        continue;
      }
      Element prevButton = document.querySelector('#$elFor');
      bool hasPrevButton =
          prevButton != null && prevButton.localName == 'button';
      if (hasPrevButton) {
        Element parent = prevButton.parent;
        Element buttonContainer = new Element.tag('rbi-menu-button');
        buttonContainer.attributes.addAll({'[buttonId]': "\'$elFor\'"});
        buttonContainer.append(prevButton);
        parent.append(buttonContainer);
        Element menuContainer = new Element.tag('rbi-menu-container');
        bool rippling = element.classes.contains('mdl-js-ripple-effect') ||
            element.classes.contains('[shouldRipple]');
        for (Element li in element.querySelectorAll('.mdl-menu__item')) {
          Element newElement = cloneWithNewTag(li, 'button');
          String style = 'opacity:1;width:100%';
          newElement.attributes.addAll({
            'style': style,
            '[shouldRipple]': '$rippling',
            'tabindex': '-1',
          });
          menuContainer.append(newElement);
          li.remove();
        }

        Map<String, String> attributes = {
          '[projection]': projection,
          '[buttonId]': "\'$elFor\'",
          '[shouldRipple]': '$rippling'
        };
        menuContainer.attributes.addAll(attributes);
        parent.append(menuContainer);
        element.remove();
      }
    }
  }

  /// MDL slider input gets a container and new tags for display.
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
