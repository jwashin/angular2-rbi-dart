library material_tooltip;

import 'dart:html';

const String IS_ACTIVE = 'is-active';

class TooltipBehavior {
  Element element;

  TooltipBehavior(Element this.element) {
    Element forElement;
    String ForElId = element.getAttribute('for');
    if (ForElId == null) {
      ForElId = element.getAttribute('data-for');
    }
    if (ForElId != null) {
      forElement = document.getElementById(ForElId);
      if (forElement != null) {
        if (!forElement.attributes.containsKey('tabindex')) {
          forElement.setAttribute('tabindex', '0');
        }
        forElement.addEventListener('mouseenter', handleMouseEnter, false);
        forElement.addEventListener('click', handleMouseEnter, false);
        forElement.addEventListener('touchstart', handleMouseEnter, false);
        forElement.addEventListener('blur', handleMouseLeave);
        forElement.addEventListener('mouseleave', handleMouseLeave);
      }
    }
  }
  handleMouseEnter(Event event) {
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

  handleMouseLeave(Event event) {
    event.stopPropagation();
    element.classes.remove(IS_ACTIVE);
    window.removeEventListener('scroll', handleMouseLeave);
    window.removeEventListener('touchmove', handleMouseLeave, false);
  }
}
