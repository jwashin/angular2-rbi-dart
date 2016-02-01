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
  dynamic value = 0;
  dynamic max = 100;
  dynamic min = 0;
  dynamic step = 1;
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

  // void init() {
  //   updateValueStyles();
  // }

  void updateValueStyles() {
    if (value != null && min != null && max != null) {
      num calcValue = num.parse(element.getAttribute('value'));
      num calcMin = num.parse(element.getAttribute('min'));
      num calcMax = num.parse(element.getAttribute('max'));
      double fraction =
          (calcValue - calcMin).toDouble() / (calcMax - calcMin).toDouble();
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
    dynamic newValue = target.value;
    if (value is num && newValue is String) {
      newValue = num.parse(newValue);
    }
    print('$value, (${value.runtimeType})');
    print('$newValue, (${newValue.runtimeType})');
    element.setAttribute('value', '$newValue');
    dispatchValue(newValue);
    updateValueStyles();
  }

  void onInput(Event event) {
    updateValueStyles();
  }

  void onMouseUp(MouseEvent event) {
    Element target = event.currentTarget;
    target.blur();
  }

  void dispatchValue(dynamic aValue) {
    // nop; let the directive handle this
  }
}
