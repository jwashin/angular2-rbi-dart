library material_button;

import 'dart:html';
import 'material_ripple.dart' show RippleBehavior;
import 'dart:async' show Timer;

const String RIPPLE_EFFECT = 'mdl-js-ripple-effect';
const String BUTTON_RIPPLE_CONTAINER = 'mdl-button__ripple-container';
const String RIPPLE = 'mdl-ripple';
const String BUTTON_DISABLED = 'mdl-button--disabled';

class ButtonBehavior {
  HtmlElement element;
  ButtonBehavior(this.element);
  SpanElement rippleElement;

  void destroy() {
    if (rippleElement != null) {
      rippleElement.removeEventListener('mouseup', blurHandler);
    }
    if (element != null && element.classes.contains(RIPPLE_EFFECT)) {
      element.removeEventListener('mouseup', blurHandler);
      element.removeEventListener('mouseleave', blurHandler);
      RippleBehavior rb = new RippleBehavior(element);
      rb.destroy();
    }
  }

  void init() {
    if (element != null && element.classes.contains(RIPPLE_EFFECT)) {
      SpanElement rippleContainer = new SpanElement();
      rippleContainer.classes.add(BUTTON_RIPPLE_CONTAINER);
      rippleElement = new SpanElement();
      rippleElement.classes.add(RIPPLE);
      rippleContainer.append(rippleElement);
      rippleElement.addEventListener('mouseup', blurHandler);
      element.append(rippleContainer);
      RippleBehavior rb = new RippleBehavior(element);
      rb.init();
    }
    element.addEventListener('mouseup', blurHandler);
    element.addEventListener('mouseleave', blurHandler);
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

  void blurHandler(MouseEvent event) {
    Timer.run(() {
      element.blur();
    });
  }
}
