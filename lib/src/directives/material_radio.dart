library material_radio;

import 'material_ripple.dart' show RippleBehavior;
import 'dart:html';
import 'dart:async' show Timer;

// css classes
const String JS_RADIO = 'mdl-js-radio';
const String RADIO_BTN = 'mdl-radio__button';
const String RADIO_OUTER_CIRCLE = 'mdl-radio__outer-circle';
const String RADIO_INNER_CIRCLE = 'mdl-radio__inner-circle';
const String RIPPLE_EFFECT = 'mdl-js-ripple-effect';
const String RIPPLE_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';
const String RADIO_RIPPLE_CONTAINER = 'mdl-radio__ripple-container';
const String RIPPLE_CENTER = 'mdl-ripple--center';
const String RIPPLE = 'mdl-ripple';
const String IS_FOCUSED = 'is-focused';
const String IS_DISABLED = 'is-disabled';
const String IS_CHECKED = 'is-checked';
const String IS_UPGRADED = 'is-upgraded';

class RadioBehavior {
  Element element;
  InputElement buttonElement;
  SpanElement rippleContainer;
  RadioBehavior(this.element);

  void init() {
    buttonElement = element.querySelector('.' + RADIO_BTN);

    Element outerCircle = new SpanElement()..classes.add(RADIO_OUTER_CIRCLE);
    Element innerCircle = new SpanElement()..classes.add(RADIO_INNER_CIRCLE);

    element.append(outerCircle);
    element.append(innerCircle);

    if (element.classes.contains(RIPPLE_EFFECT)) {
      element.classes.add(RIPPLE_IGNORE_EVENTS);
      element.classes.remove(RIPPLE_EFFECT);

      rippleContainer = new SpanElement()
        ..classes
            .addAll([RADIO_RIPPLE_CONTAINER, RIPPLE_EFFECT, RIPPLE_CENTER]);
      rippleContainer.addEventListener('mouseup', onMouseup);
      Element ripple = new SpanElement()..classes.add(RIPPLE);
      rippleContainer.append(ripple);
      element.append(rippleContainer);
      RippleBehavior rb = new RippleBehavior(rippleContainer);
      rb.init();
    }
    buttonElement.addEventListener('change', onChange);
    buttonElement.addEventListener('focus', onFocus);
    buttonElement.addEventListener('blur', onBlur);
    buttonElement.addEventListener('m-r-g-updated', onUpdated);
    element.addEventListener('mouseup', onMouseup);
    // wait a click for angular2 to set values
    Timer.run(() {
      updateClasses();
      element.classes.add(IS_UPGRADED);
    });
  }

  void destroy() {
    buttonElement.removeEventListener('change', onChange);
    buttonElement.removeEventListener('focus', onFocus);
    buttonElement.removeEventListener('blur', onBlur);
    buttonElement.removeEventListener('m-r-g-updated', onUpdated);
    element.removeEventListener('mouseup', onMouseup);
    if (rippleContainer != null) {
      rippleContainer.removeEventListener('mouseup', onMouseup);
      RippleBehavior rb = new RippleBehavior(rippleContainer);
      rb.destroy();
    }
  }

  void onUpdated(Event event) {
    updateClasses();
  }

  void onChange(Event event) {
    List<Element> radios = document.querySelectorAll('.' + JS_RADIO);
    String name = buttonElement.getAttribute('name');
    for (Element radio in radios) {
      Element button =
      radio.querySelector("input[type='radio'][name='$name']." + RADIO_BTN);
      if (button != null) {
        button.dispatchEvent(new CustomEvent('m-r-g-updated'));
      }
    }
  }

  void onFocus(Event event) {
    element.classes.add(IS_FOCUSED);
  }

  void onBlur(Event event) {
    element.classes.remove(IS_FOCUSED);
  }

  void blur() {
    Timer.run(() {
      buttonElement.blur();
    });
  }

  void onMouseup(Event event) {
    blur();
  }

  void updateClasses() {
    checkDisabled();
    checkToggleState();
  }

  void checkToggleState() {
    if (buttonElement.checked) {
      element.classes.add(IS_CHECKED);
    } else {
      element.classes.remove(IS_CHECKED);
    }
  }

  void checkDisabled() {
    if (buttonElement.disabled) {
      element.classes.add(IS_DISABLED);
    } else {
      element.classes.remove(IS_DISABLED);
    }
  }

  void disable() {
    buttonElement.disabled = true;
  }

  void enable() {
    buttonElement.disabled = false;
  }

  void check() {
    buttonElement.checked = true;
  }

  void uncheck() {
    buttonElement.checked = false;
  }
}
