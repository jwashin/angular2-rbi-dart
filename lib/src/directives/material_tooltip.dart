library material_tooltip;

import 'dart:html';
import 'dart:async';

const String IS_ACTIVE = 'is-active';

class TooltipBehavior {
  Element element;
  List<StreamSubscription> subscriptions = [];
  List<StreamSubscription> mouseSubscriptions = [];

  TooltipBehavior(this.element);
  void init() {
    Element target = forElement;
    if (target != null) {
      if (!target.attributes.containsKey('tabindex')) {
        target.setAttribute('tabindex', '0');
      }
//      target.addEventListener('mouseenter', handleMouseEnter, false);
//      target.addEventListener('click', handleMouseEnter, false);
//      target.addEventListener('touchstart', handleMouseEnter, false);
//      target.addEventListener('blur', handleMouseLeave);
//      target.addEventListener('mouseleave', handleMouseLeave);

      subscriptions..add(
          target.onMouseEnter.listen((event) => handleMouseEnter(event)))..add(
          target.onClick.listen((event) => handleMouseEnter(event)))..add(
          target.onTouchStart.listen((event) => handleMouseEnter(event)))..add(
          target.onBlur.listen((event) => handleMouseLeave(event)))..add(
          target.onMouseLeave.listen((event) => handleMouseLeave(event)));
    }
  }

  Element get forElement {
    Element forElement;
    String forElementId = element.getAttribute('for');
    if (forElementId == null) {
      forElementId = element.getAttribute('data-for');
    }
    if (forElementId != null) {
      forElement = document.getElementById(forElementId);
    }
    return forElement;
  }

  void destroy() {
    for (StreamSubscription subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
  }

  void handleMouseEnter(Event event) {
    event.stopPropagation();
    Element target = event.target;
    Rectangle props = target.getBoundingClientRect();
    int left = (props.left + (props.width) / 2).round();
    int marginLeft = (-1 * element.offsetWidth / 2).round();

    if ((left + marginLeft) < 0) {
      element.style.left = '0';
      element.style.marginLeft = '0';
    } else {
      element.style.left = '${left}px';
      element.style.marginLeft = '${marginLeft}px';
    }
    element.style.top = '${props.top + props.height + 10}px';
    element.classes.add(IS_ACTIVE);
//    window.addEventListener('scroll', handleMouseLeave, false);
//    window.addEventListener('touchmove', handleMouseLeave, false);
    mouseSubscriptions..add(
        window.onScroll.listen((event) => handleMouseLeave(event)))..add(
        window.onTouchMove.listen((event) => handleMouseLeave(event)));
  }

  void handleMouseLeave(Event event) {
    event.stopPropagation();
    element.classes.remove(IS_ACTIVE);
    for (StreamSubscription subscription in mouseSubscriptions) {
      subscription.cancel();
    }
    mouseSubscriptions.clear();
  }
}
