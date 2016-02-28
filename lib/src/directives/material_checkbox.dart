library material_checkbox;

import 'material_ripple.dart' show RippleBehavior;
import 'dart:html';
import 'dart:async';

// css classes

const String CHECKBOX_INPUT = 'mdl-checkbox__input';
const String BOX_OUTLINE = 'mdl-checkbox__box-outline';
const String FOCUS_HELPER = 'mdl-checkbox__focus-helper';
const String TICK_OUTLINE = 'mdl-checkbox__tick-outline';
const String RIPPLE_EFFECT = 'mdl-js-ripple-effect';
const String RIPPLE_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';
const String CHECKBOX_RIPPLE_CONTAINER = 'mdl-checkbox__ripple-container';
const String RIPPLE_CENTER = 'mdl-ripple--center';
const String RIPPLE = 'mdl-ripple';
const String IS_FOCUSED = 'is-focused';
const String IS_DISABLED = 'is-disabled';
const String IS_CHECKED = 'is-checked';
const String IS_UPGRADED = 'is-upgraded';
const int TINY_TIMEOUT = 1;

class CheckboxBehavior {
  Element element;
  InputElement inputElement;
  CheckboxBehavior(this.element);

  List<StreamSubscription> subscriptions = [];
  List<RippleBehavior> ripples = [];

  void init() {
    if (element != null) {
      if (!element.classes.contains(IS_UPGRADED)) {
        inputElement = element.querySelector('.' + CHECKBOX_INPUT);
        Element boxOutline = new SpanElement()..classes.add(BOX_OUTLINE);
        Element tickContainer = new SpanElement()..classes.add(FOCUS_HELPER);
        Element tickOutline = new SpanElement()..classes.add(TICK_OUTLINE);
        boxOutline.append(tickOutline);
        element.append(tickContainer);
        element.append(boxOutline);
        if (element.classes.contains(RIPPLE_EFFECT)) {
          element.classes.add(RIPPLE_IGNORE_EVENTS);
          SpanElement rippleContainer = new SpanElement()
            ..classes.addAll(
                [CHECKBOX_RIPPLE_CONTAINER, RIPPLE_EFFECT, RIPPLE_CENTER])
            ..append(new SpanElement()..classes.add(RIPPLE));
          subscriptions.add(
              rippleContainer.onMouseUp.listen((event) => onMouseUp(event)));
          element.append(rippleContainer);
          ripples.add(new RippleBehavior(rippleContainer)..init());
        }
        subscriptions
          ..add(inputElement.onChange.listen((event) => onChange(event)))
          ..add(inputElement.onFocus.listen((event) => onFocus(event)))
          ..add(inputElement.onBlur.listen((event) => onBlur(event)))
          ..add(element.onMouseUp.listen((event) => onMouseUp(event)));
        Timer.run(() => updateClasses());
        element.classes.add(IS_UPGRADED);
      }
    }
  }

  void destroy() {
    for (StreamSubscription subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
    for (RippleBehavior ripple in ripples) {
      ripple.destroy();
    }
    ripples.clear();
  }

  void onChange(Event event) => updateClasses();

  bool onFocus(Event event) => element.classes.add(IS_FOCUSED);

  bool onBlur(Event event) => element.classes.remove(IS_FOCUSED);

  void blur() => Timer.run(() => inputElement.blur());

  void onMouseUp(Event event) => blur();

  void updateClasses() {
    checkDisabled();
    checkToggleState();
  }

  void checkToggleState() {
    if (inputElement.checked) {
      element.classes.add(IS_CHECKED);
    } else {
      element.classes.remove(IS_CHECKED);
    }
  }

  void checkDisabled() {
    if (inputElement.disabled) {
      element.classes.add(IS_DISABLED);
    } else {
      element.classes.remove(IS_DISABLED);
    }
  }

  void disable() {
    inputElement.disabled = true;
    updateClasses();
  }

  void enable() {
    inputElement.disabled = false;
    updateClasses();
  }

  void check() {
    inputElement.checked = true;
    updateClasses();
  }

  void uncheck() {
    inputElement.checked = false;
    updateClasses();
  }
}
