library material_switch;

import 'material_ripple.dart' show RippleBehavior;
import 'dart:html';
import 'dart:async' show Timer;

const String SWITCH_INPUT = 'mdl-switch__input';
const String TRACK = 'mdl-switch__track';
const String THUMB = 'mdl-switch__thumb';
const String FOCUS_HELPER = 'mdl-switch__focus-helper';
const String RIPPLE_EFFECT = 'mdl-js-ripple-effect';
const String RIPPLE_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';
const String SWITCH_RIPPLE_CONTAINER = 'mdl-switch__ripple-container';
const String RIPPLE_CENTER = 'mdl-ripple--center';
const String RIPPLE = 'mdl-ripple';
const String IS_FOCUSED = 'is-focused';
const String IS_DISABLED = 'is-disabled';
const String IS_CHECKED = 'is-checked';
const String IS_UPGRADED = 'is-upgraded';

class SwitchBehavior {
  Element element;
  CheckboxInputElement inputElement;

  SwitchBehavior(this.element);
  void init() {
    inputElement = element.querySelector('.' + SWITCH_INPUT);
    Element track = new DivElement()..classes.add(TRACK);
    Element thumb = new DivElement()..classes.add(THUMB);
    Element focusHelper = new SpanElement()..classes.add(FOCUS_HELPER);
    thumb.append(focusHelper);
    element.children.addAll([track, thumb]);
    if (element.classes.contains(RIPPLE_EFFECT)) {
      element.classes.add(RIPPLE_IGNORE_EVENTS);
      Element rippleContainer = new SpanElement()
        ..classes
            .addAll([SWITCH_RIPPLE_CONTAINER, RIPPLE_EFFECT, RIPPLE_CENTER])
        ..addEventListener('mouseup', onMouseUp);
      Element ripple = new SpanElement()..classes.add(RIPPLE);
      rippleContainer.append(ripple);
      element.append(rippleContainer);
      RippleBehavior rb = new RippleBehavior(rippleContainer);
      rb.init();
    }
    inputElement.addEventListener('change', onChange);
    inputElement.addEventListener('focus', onFocus);
    inputElement.addEventListener('blur', onBlur);
    element.addEventListener('mouseup', onMouseUp);
    // wait a click for angular2
    Timer.run(() {
      updateClasses();
      element.classes.add(IS_UPGRADED);
    });
  }

  void onChange(Event event) {
    updateClasses();
  }

  void onFocus(Event event) {
    element.classes.add(IS_FOCUSED);
  }

  void onBlur(Event event) {
    element.classes.remove(IS_FOCUSED);
  }

  void onMouseUp(Event event) {
    blur();
  }

  void updateClasses() {
    checkDisabled();
    checkToggleState();
  }

  void blur() {
    Timer.run(() {
      inputElement.blur();
    });
  }

  void checkDisabled() {
    if (inputElement.disabled) {
      element.classes.add(IS_DISABLED);
    } else {
      element.classes.remove(IS_DISABLED);
    }
  }

  void checkToggleState() {
    if (inputElement.checked) {
      element.classes.add(IS_CHECKED);
    } else {
      element.classes.remove(IS_CHECKED);
    }
  }

  void disable() {
    inputElement.disabled = true;
  }

  void enable() {
    inputElement.disabled = false;
  }

  void on() {
    inputElement.checked = true;
  }

  void off() {
    inputElement.checked = false;
  }
}
