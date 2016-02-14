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
  void init() {
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
        RippleBehavior rb = new RippleBehavior(tab);
        rb.init();
      }
      tab.addEventListener('click', tabClickHandler);
    }
    element.classes.add(IS_UPGRADED);
  }

  List<Element> get tabs => element.querySelectorAll('.' + TAB_CLASS);
  List<Element> get panels => element.querySelectorAll('.' + PANEL_CLASS);

  void destroy() {
    bool rippling = element.classes.contains(RIPPLE_EFFECT);
    for (Element tab in tabs) {
      tab.removeEventListener('click', tabClickHandler);
      if (rippling) {
        RippleBehavior rb = new RippleBehavior(tab);
        rb.destroy();
      }
    }
  }

  void resetTabState() {
    for (Element k in tabs) {
      k.classes.remove(IS_ACTIVE);
    }
  }

  void resetPanelState() {
    for (Element j in panels) {
      j.classes.remove(IS_ACTIVE);
    }
  }

  void tabClickHandler(Event event) {
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
