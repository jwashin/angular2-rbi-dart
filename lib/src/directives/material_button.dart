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
  ButtonBehavior(this.element) {
    if (element != null && element.classes.contains(RIPPLE_EFFECT)) {
      SpanElement rippleContainer = new SpanElement();
      rippleContainer.classes.add(BUTTON_RIPPLE_CONTAINER);
      SpanElement rippleElement = new SpanElement();
      rippleElement.classes.add(RIPPLE);
      rippleContainer.append(rippleElement);
      rippleElement.addEventListener('mouseup', blurHandler);
      element.append(rippleContainer);
      new RippleBehavior(element);
    }
    element.addEventListener('mouseup', blurHandler);
    element.addEventListener('mouseleave', blurHandler);
  }

  enable() {
    if (element is ButtonElement) {
      ButtonElement t = element as ButtonElement;
      t.disabled = false;
    }
    element.classes.remove(BUTTON_DISABLED);
  }

  disable() {
    if (element is ButtonElement) {
      ButtonElement t = element as ButtonElement;
      t.disabled = true;
    }
    element.classes.add(BUTTON_DISABLED);
  }

  blurHandler(MouseEvent event) {
    Timer.run(() {
      element.blur();
    });
  }
}
