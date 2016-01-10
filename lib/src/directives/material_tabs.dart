library material_tabs;

import 'dart:html';
import 'material_ripple.dart' show RippleBehavior;

const String TAB_CLASS = 'mdl-tabs__tab';
const String PANEL_CLASS = 'mdl-tabs__panel';
const String IS_ACTIVE = 'is-active';
const String IS_UPGRADED = 'is-upgraded';

const String RIPPLE_EFFECT = 'mdl-js-ripple-effect';
const String TABS_RIPPLE_CONTAINER = 'mdl-tabs__ripple-container';
const String RIPPLE = 'mdl-ripple';
const String RIPPLE_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';

class TabsBehavior {
  Element element;

  TabsBehavior(this.element);
  init(){
    if (element.classes.contains(RIPPLE_EFFECT)) {
      element.classes.add(RIPPLE_IGNORE_EVENTS);
    }
    for (Element tab in tabs) {
      if (element.classes.contains(RIPPLE_EFFECT)) {
        SpanElement ripple = new SpanElement()..classes.add(RIPPLE);
        SpanElement rippleContainer = new SpanElement()
          ..classes.addAll([TABS_RIPPLE_CONTAINER, RIPPLE_EFFECT])
          ..append(ripple);
        tab.append(rippleContainer);
        tab.addEventListener('click', tabClickHandler);
        RippleBehavior rb = new RippleBehavior(tab);
        rb.init();
      }
    }
    element.classes.add(IS_UPGRADED);
  }

  get tabs => element.querySelectorAll('.' + TAB_CLASS);
  get panels => element.querySelectorAll('.' + PANEL_CLASS);

  resetTabState() {
    for (Element k in tabs) {
      k.classes.remove(IS_ACTIVE);
    }
  }

  resetPanelState() {
    for (Element j in panels) {
      j.classes.remove(IS_ACTIVE);
    }
  }

  tabClickHandler(Event event) {
    event.preventDefault();
    AnchorElement tab = event.currentTarget;
    String href = tab.href.split('#')[1];
    Element panel = element.querySelector('#' + href);
    resetTabState();
    resetPanelState();
    tab.classes.add(IS_ACTIVE);
    panel.classes.add(IS_ACTIVE);
  }
}
