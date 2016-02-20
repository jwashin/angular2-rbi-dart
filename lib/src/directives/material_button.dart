library material_button;

import 'dart:html';
import 'material_ripple.dart' show RippleBehavior;
import 'dart:async';

const String RIPPLE_EFFECT = 'mdl-js-ripple-effect';
const String BUTTON_RIPPLE_CONTAINER = 'mdl-button__ripple-container';
const String RIPPLE = 'mdl-ripple';
const String BUTTON_DISABLED = 'mdl-button--disabled';

class ButtonBehavior {
  HtmlElement element;
  ButtonBehavior(this.element);
  SpanElement rippleElement;
  List<StreamSubscription> subscriptions = [];
  List<RippleBehavior> ripples = [];

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

  void init() {
    if (element != null && element.classes.contains(RIPPLE_EFFECT)) {
      SpanElement rippleContainer = new SpanElement();
      rippleContainer.classes.add(BUTTON_RIPPLE_CONTAINER);
      rippleElement = new SpanElement();
      rippleElement.classes.add(RIPPLE);
      rippleContainer.append(rippleElement);
      element.append(rippleContainer);
      subscriptions
          .add(rippleElement.onMouseUp.listen((event) => blurHandler(event)));
      ripples.add(new RippleBehavior(element)
        ..init());
    }
    subscriptions..add(
        element.onMouseUp.listen((event) => blurHandler(event)))..add(
        element.onMouseLeave.listen((event) => blurHandler(event)));
  }

  void enable() {
    if (element is ButtonElement) {
      ButtonElement t = element;
      t.disabled = false;
    }
    element.classes.remove(BUTTON_DISABLED);
  }

  void disable() {
    if (element is ButtonElement) {
      ButtonElement t = element;
      t.disabled = true;
    }
    element.classes.add(BUTTON_DISABLED);
  }

  void blurHandler(MouseEvent event) => Timer.run(() => element.blur());
}
