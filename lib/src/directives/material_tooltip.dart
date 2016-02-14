library material_tooltip;

import 'dart:html';

const String IS_ACTIVE = 'is-active';

class TooltipBehavior {
  Element element;

  TooltipBehavior(this.element);
  void init() {
    Element target = forElement;
    if (target != null) {
      if (!target.attributes.containsKey('tabindex')) {
        target.setAttribute('tabindex', '0');
      }
      target.addEventListener('mouseenter', handleMouseEnter, false);
      target.addEventListener('click', handleMouseEnter, false);
      target.addEventListener('touchstart', handleMouseEnter, false);
      target.addEventListener('blur', handleMouseLeave);
      target.addEventListener('mouseleave', handleMouseLeave);
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
    Element target = forElement;
    if (target != null) {
      target.removeEventListener('mouseenter', handleMouseEnter, false);
      target.removeEventListener('click', handleMouseEnter, false);
      target.removeEventListener('touchstart', handleMouseEnter, false);
      target.removeEventListener('blur', handleMouseLeave);
      target.removeEventListener('mouseleave', handleMouseLeave);
    }
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
    window.addEventListener('scroll', handleMouseLeave, false);
    window.addEventListener('touchmove', handleMouseLeave, false);
  }

  void handleMouseLeave(Event event) {
    event.stopPropagation();
    element.classes.remove(IS_ACTIVE);
    window.removeEventListener('scroll', handleMouseLeave);
    window.removeEventListener('touchmove', handleMouseLeave, false);
  }
}
