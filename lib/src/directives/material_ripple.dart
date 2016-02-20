library material_ripple;

import 'dart:html';
import 'dart:async' show Timer, StreamSubscription;
import 'dart:math' show sqrt;
import 'package:angular2_rbi/src/util/animation_frame.dart'
    show getAnimationFrame;

const String RIPPLE_EFFECT = 'mdl-js-ripple-effect';
const String RIPPLE_CENTER = 'mdl-ripple--center';
const String RIPPLE_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';
const String RIPPLE = 'mdl-ripple';
const String IS_ANIMATING = 'is-animating';
const String IS_VISIBLE = 'is-visible';
const String HAS_RIPPLE_EVENTS = 'has-ripple-events';

const String INITIAL_SCALE = 'scale(0.0001, 0.0001)';
const String INITIAL_SIZE = '1px';
const String FINAL_SCALE = '';

class RippleBehavior {
  Element element;
  Element rippleElement;
  int frameCount = 0;
  int x = 0;
  int y = 0;
  int boundWidth;
  int boundHeight;
  List<StreamSubscription> subscriptions = [];

  RippleBehavior(this.element);

  void init() {
    if (element != null) {
      if (!element.classes.contains(HAS_RIPPLE_EVENTS)) {
        if (!element.classes.contains(RIPPLE_IGNORE_EVENTS)) {
          rippleElement = element.querySelector('.' + RIPPLE);
          subscriptions..add(
              element.onMouseDown.listen((event) => downHandler(event)))..add(
              element.onMouseUp.listen((event) => upHandler(event)))..add(
              element.onMouseLeave.listen((event) => upHandler(event)))..add(
              element.onTouchStart.listen((event) => downHandler(event)))..add(
              element.onTouchEnd.listen((event) => upHandler(event)))..add(
              element.onBlur.listen((event) => upHandler(event)));
          element.classes.add(HAS_RIPPLE_EVENTS);
        }
      }
    }
  }

  void destroy() {
    for (StreamSubscription subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
  }

  void upHandler(Event event) {
    if (rippleElement != null) {
      if (event is MouseEvent) {
        if (event != null && event.detail != 2) {
          rippleElement.classes.remove(IS_VISIBLE);
        }
      }
      Timer.run(() {
        rippleElement.classes.remove(IS_VISIBLE);
        rippleElement.classes.remove(IS_ANIMATING);
      });
    }
  }

  void downHandler(Event event) {
    if (rippleElement.style.width == '' && rippleElement.style.height == '') {
      Rectangle rect = element.getBoundingClientRect();
      boundHeight = rect.height.toInt();
      boundWidth = rect.width.toInt();
      int rippleSize =
          (sqrt(boundWidth * boundWidth + boundHeight * boundHeight) * 2 + 2)
              .toInt();
      rippleElement.style.width = '${rippleSize}px';
      rippleElement.style.height = '${rippleSize}px';
    }
    rippleElement.classes.add(IS_VISIBLE);
    if (frameCount > 0) {
      return;
    }
    frameCount = 1;
    Element target = event.currentTarget;
    Rectangle bound = target.getBoundingClientRect();
    if (event is KeyboardEvent) {
      x = (bound.width / 2).round();
      y = (bound.height / 2).round();
    } else {
      int clientX, clientY;
      if (event is TouchEvent) {
        clientX = event.touches[0].client.x;
        clientY = event.touches[0].client.y;
      } else if (event is MouseEvent) {
        clientX = event.client.x;
        clientY = event.client.y;
      }
      x = (clientX - bound.left).round();
      y = (clientY - bound.top).round();
    }

    setRippleStyles(true);
    getAnimationFrame().then((_) {
      animationFrameHandler();
    });
  }

  void setRippleStyles(bool start) {
    if (rippleElement != null) {
      String transformString, scale;
      String offset = 'translate(${x}px, ${y}px)';
      if (start) {
        scale = INITIAL_SCALE;
      } else {
        scale = FINAL_SCALE;
        if (rippleElement.parent.classes.contains(RIPPLE_CENTER)) {
          offset = 'translate(${boundWidth / 2}px, ${boundHeight / 2}px)';
        }
      }
      transformString = 'translate(-50%, -50%) $offset $scale';
      rippleElement.style.transform = transformString;
      if (start) {
        rippleElement.classes.remove(IS_ANIMATING);
      } else {
        rippleElement.classes.add(IS_ANIMATING);
      }
    }
  }

  void animationFrameHandler() {
    if (frameCount-- > 0) {
      getAnimationFrame().then((_) {
        animationFrameHandler();
      });
    } else {
      setRippleStyles(false);
    }
  }
}
