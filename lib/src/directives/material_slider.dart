library material_slider;

import 'dart:html';

//css constants
const String IE_CONTAINER = 'mdl-slider__ie-container';
const String SLIDER_CONTAINER = 'mdl-slider__container';
const String BACKGROUND_FLEX = 'mdl-slider__background-flex';
const String BACKGROUND_LOWER = 'mdl-slider__background-lower';
const String BACKGROUND_UPPER = 'mdl-slider__background-upper';
const String IS_LOWEST_VALUE = 'is-lowest-value';
const String IS_UPGRADED = 'is-upgraded';

class SliderBehavior {
  InputElement element;
  String value;
  String max;
  String min;
  String step = '1';
  Element backgroundLower;
  Element backgroundUpper;

  SliderBehavior(this.element) {
    Element container = new DivElement()..classes.add(SLIDER_CONTAINER);
    element.parent.insertBefore(container, element);
    element.parent.children.remove(element);
    container.append(element);
    Element backgroundFlex = new DivElement()..classes.add(BACKGROUND_FLEX);
    container.append(backgroundFlex);
    backgroundLower = new DivElement()..classes.add(BACKGROUND_LOWER);
    backgroundFlex.append(backgroundLower);
    backgroundUpper = new DivElement()..classes.add(BACKGROUND_UPPER);
    backgroundFlex.append(backgroundUpper);

    element.addEventListener('input', onChange);
    element.addEventListener('change', onChange);
    element.addEventListener('mouseup', onMouseUp);

    if (element.getAttribute('value') == element.getAttribute('min')) {
      element.classes.add(IS_LOWEST_VALUE);
    }
    element.classes.add(IS_UPGRADED);
  }

  void updateValueStyles() {
    if (value != null && min != null && max != null) {
      num fraction = (num.parse(value) - num.parse(min)) /
          (num.parse(max) - num.parse(min));
      if (fraction == 0) {
        element.classes.add(IS_LOWEST_VALUE);
      } else {
        element.classes.remove(IS_LOWEST_VALUE);
      }
      backgroundLower.style.flex = '$fraction';
      backgroundUpper.style.flex = '${1.0 - fraction}';
    }
  }

  void onChange(Event event) {
    InputElement target = event.currentTarget;
    value = target.value;
    updateValueStyles();
  }

  void onInput(Event event) {
    updateValueStyles();
  }

  void onMouseUp(MouseEvent event) {
    Element target = event.currentTarget;
    target.blur();
  }
}
