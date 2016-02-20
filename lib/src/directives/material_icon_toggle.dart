library material_icon_toggle;

import 'material_ripple.dart' show RippleBehavior;
import 'dart:html';
import 'dart:async';

const String ICON_TOGGLE_INPUT = 'mdl-icon-toggle__input';
const String RIPPLE_EFFECT = 'mdl-js-ripple-effect';
const String RIPPLE_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';
const String ICON_TOGGLE_RIPPLE_CONTAINER = 'mdl-icon-toggle__ripple-container';
const String RIPPLE_CENTER = 'mdl-ripple--center';
const String RIPPLE = 'mdl-ripple';
const String IS_FOCUSED = 'is-focused';
const String IS_DISABLED = 'is-disabled';
const String IS_CHECKED = 'is-checked';
const String IS_UPGRADED = 'is-upgraded';

class IconToggleBehavior {
  Element element;
  InputElement inputElement;
  List<StreamSubscription> subscriptions = [];
  List<RippleBehavior> ripples = [];

  IconToggleBehavior(this.element);

  void init() {
    inputElement = element.querySelector('.' + ICON_TOGGLE_INPUT);

    if (element.classes.contains(RIPPLE_EFFECT)) {
      element.classes.add(RIPPLE_IGNORE_EVENTS);
      SpanElement rippleContainer = new SpanElement()
        ..classes.addAll(
            [ICON_TOGGLE_RIPPLE_CONTAINER, RIPPLE_EFFECT, RIPPLE_CENTER]);
      subscriptions
          .add(rippleContainer.onMouseUp.listen((event) => onMouseUp(event)));
      Element ripple = new SpanElement()..classes.add(RIPPLE);
      rippleContainer.append(ripple);
      element.append(rippleContainer);
      ripples.add(new RippleBehavior(rippleContainer)
        ..init());
    }
    subscriptions..add(
        inputElement.onChange.listen((event) => onChange(event)))..add(
        inputElement.onFocus.listen((event) => onFocus(event)))..add(
        inputElement.onBlur.listen((event) => onBlur(event)))..add(
        inputElement.onMouseUp.listen((event) => onMouseUp(event)));

    // wait a click for Angular to set values
    Timer.run(() {
      updateClasses();
      element.classes.add(IS_UPGRADED);
    });
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

  void onMouseUp(Event event) => blur();

  bool onFocus(Event event) => element.classes.add(IS_FOCUSED);

  bool onBlur(Event event) => element.classes.remove(IS_FOCUSED);

  void blur() => Timer.run(() => inputElement.blur());

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

  void onChange(Event event) => updateClasses();

  bool disable() => inputElement.disabled = true;

  bool enable() => inputElement.disabled = false;

  bool check() => inputElement.checked = true;

  bool uncheck() => inputElement.checked = false;
}
