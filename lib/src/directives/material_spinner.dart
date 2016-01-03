library material_spinner;

import 'dart:html';

// constants
const int SPINNER_LAYER_COUNT = 4;
// css classes
const String SPINNER_LAYER = 'mdl-spinner__layer';
const String SPINNER_CIRCLE_CLIPPER = 'mdl-spinner__circle-clipper';
const String SPINNER_CIRCLE = 'mdl-spinner__circle';
const String SPINNER_GAP_PATCH = 'mdl-spinner__gap-patch';
const String SPINNER_LEFT = 'mdl-spinner__left';
const String SPINNER_RIGHT = 'mdl-spinner__right';

const String IS_ACTIVE = 'is-active';
const String IS_UPGRADED = 'is-upgraded';

class SpinnerBehavior {
  Element element;
  SpinnerBehavior(this.element) {
    if (element != null) {
      for (int i = 1; i <= SPINNER_LAYER_COUNT; i++) {
        createLayer(i);
      }
      element.classes.add(IS_UPGRADED);
    }
  }

  createLayer(index) {
    Element layer = new DivElement()
      ..classes.addAll([SPINNER_LAYER, '${SPINNER_LAYER}-${index}']);
    Element leftClipper = new DivElement()
      ..classes.addAll([SPINNER_CIRCLE_CLIPPER, SPINNER_LEFT]);
    Element gapPatch = new DivElement()..classes.add(SPINNER_GAP_PATCH);
    Element rightClipper = new DivElement()
      ..classes.addAll([SPINNER_CIRCLE_CLIPPER, SPINNER_RIGHT]);
    List<Element> circleOwners = [leftClipper, gapPatch, rightClipper];
    for (Element item in circleOwners) {
      DivElement circle = new DivElement()..classes.add(SPINNER_CIRCLE);
      item.append(circle);
    }
    layer.children.addAll(circleOwners);
    element.append(layer);
  }

  stop() {
    element.classes.remove(IS_ACTIVE);
  }

  start() {
    element.classes.add(IS_ACTIVE);
  }
}
