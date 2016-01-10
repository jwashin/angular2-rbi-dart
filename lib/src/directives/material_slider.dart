library material_slider;

import 'dart:html';
import 'dart:math';

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
//  bool isIE;
  String _value;
  String _max;
  String _min;
  String _step = '1';
  int decimals = 0;
  Element backgroundLower;
  Element backgroundUpper;

  SliderBehavior(this.element);
  init(){
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

  updateValueStyles() {
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

  onChange(Event event) {
    InputElement target = event.currentTarget;
    value = target.value;
    updateValueStyles();
  }

  get value => _value;
  set value(aValue) {
    String t = aValue;
    if (aValue != null) {
      int factor = pow(10, decimals);
      t = ((num.parse(aValue) * factor).round() / factor).toString();
    }
    _value = _sanitize(t);
    updateValueStyles();
  }

  get min => _min;
  set min(aValue) {
    _min = _sanitize(aValue);
  }

  get max => _max;
  set max(aValue) {
    _max = _sanitize(aValue);
  }

  get step => _step;
  set step(aValue) {
    _step = _sanitize(aValue);
    List<String> stepDecimals = _step.split('.');
    if (stepDecimals.length == 2) {
      decimals = stepDecimals[1].length;
    }
  }

  _sanitize(aValue) {
    if (aValue is num) {
      return aValue.toString();
    } else {
      return aValue;
    }
  }

  onInput(Event event) {
    updateValueStyles();
  }

  onMouseUp(MouseEvent event) {
    Element target = event.currentTarget as Element;
    target.blur();
  }
}
