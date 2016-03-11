import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';

import 'ripple.dart';

const num transitionDurationSeconds = 0.3;
const num transitionDurationFraction = 0.8;
const num closeTimeout = 150;

class MenuButtonClickedNotifier {
  EventEmitter<Map<String, Element>> menuButtonClicked =
  new EventEmitter<Map<String, Element>>();

  void click(Map<String, Element> clickInfo) {
    print('${clickInfo.keys} clicked');
    menuButtonClicked.add(clickInfo);
  }
}

MenuButtonClickedNotifier menuButtonClickedNotifier =
new MenuButtonClickedNotifier();

@Component(selector: 'rbi-menu-button', template: '<ng-content></ng-content>')
class MenuButton {
  EventEmitter<Element> menuButtonClicked = new EventEmitter<Element>();

//  EventEmitter menuButtonKey = new EventEmitter();

  @Input()
  String buttonId;

  bool open = false;

  @HostListener('click', const ['\$event.target'])
  void onClick(Element target) {
    while (!(['button'].contains(target.localName))) {
      target = target.parent;
    }
    menuButtonClickedNotifier.click({buttonId: target});
  }

  @HostListener('keydown')
  void onKeyDown() {}
}

// mdl-menu__outline rbi-menu-outline

@Component(
    selector: 'rbi-menu-container',
    template: ''
        '<div *ngIf="open" class="mdl-menu__outline" '
        '[style.height]="height" '
        '[style.width]="width" '
        '[style.left]="left" '
        '[style.top]="top" '
        '[style.right]="right" '
        '[style.bottom]="bottom" '
        '[style.opacity]="1" '
        '[style.transform]="\'none\'" '
        '[style.transition]="\'none\'"'
        '[style.z-index]="999" '
        '[class.mdl-menu--bottom-left]="projection==\'bottom-left\'" '
        '[class.mdl-menu--top-left]="projection==\'top-left\'" '
        '[class.mdl-menu--bottom-right]="projection==\'bottom-right\'" '
        '[class.mdl-menu--top-right]="projection==\'top-right\'"'
        '>'
        '<ng-content></ng-content>'
        '</div>',
    directives: const [NgIf, Ripple])
class Menu implements AfterContentInit, OnDestroy {
  @Input()
  String projection = '';
  @Input()
  bool ripple = false;
  @Input()
  String buttonId;

  @ContentChildren(MenuItem)
  QueryList<MenuItem> menuItems;

  List<StreamSubscription<dynamic>> subscriptions = [];

  bool open = false;
  int menuItemCount = 0;

  void menuItemClicked() {}

  String left,
      right,
      top,
      bottom,
      width,
      height = '';

  void resetTransitions() {
    for (MenuItem item in menuItems) {
      item.transitionDelay = '';
    }
  }

  void onButtonClick(Element button) {
    Rectangle<num> rect = button.getBoundingClientRect();
    // parent.parent because we wrapped the button in a rbi-menu-button
    // container
    Rectangle<num> forRect = button.parent.parent.getBoundingClientRect();
    print(projection);

    // since mdl-menu__outline sets left=top=0, we set left and top to 'auto'
    // if we are not otherwise setting them
    if (projection == 'bottom-left' || projection == '') {
      left = '${button.offsetLeft}px';
      top = '${button.offsetTop + button.offsetHeight}px';
    } else if (projection == 'bottom-right') {
      right = '${forRect.right - rect.right}px';
      top = '${button.offsetTop + button.offsetHeight}px';
      left = 'auto';
    } else if (projection == 'top-left') {
      left = '${button.offsetLeft}px';
      bottom = '${forRect.bottom - rect.top}px';
      top = 'auto';
    } else if (projection == 'top-right') {
      right = '${forRect.right - rect.right}px';
      bottom = '${forRect.bottom - rect.top}px';
      left = 'auto';
      top = 'auto';
    }
    toggle(button);
  }

  void toggle(Element button) {
    if (open) {
      hide();
    } else {
      open = true;
    }
  }

  void hide() {
    resetTransitions();
    open = false;
//    menu.isAnimating = false;
  }

  void setTransitions() {}

  void ngAfterContentInit() {
    subscriptions.add(menuButtonClickedNotifier.menuButtonClicked
        .listen((Map<String, Element> data) {
      if (data.containsKey(buttonId)) {
        onButtonClick(data[buttonId]);
      }
    }));
  }

  void ngOnDestroy() {
    for (StreamSubscription<dynamic> subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
  }
}

@Component(
    selector: '.mdl-menu__item',
    template: ''
        '<ng-content></ng-content>')
class MenuItem {
  @Attribute('tabindex')
  String tabIndex = '-1';
  @HostBinding('style.transition-delay')
  String transitionDelay = '';
  @HostBinding('style.opacity')
  String opacity = '1';
  @ContentChild(Ripple)
  Ripple ripple;
  @Output()
  EventEmitter<bool> menuItemClicked = new EventEmitter<bool>();

  @HostListener('mousedown', const ['\$event.client', '\$event.target'])
  void onMouseDown(Point<num> client, Element target) {
    if (ripple != null) {
      ripple.onMouseDown(client, target);
    }
  }

  @HostListener('mouseup')
  void onMouseUp() {
    if (ripple != null) {
      ripple.onMouseUp();
    }
  }

  @HostListener('click')
  void onClick() => menuItemClicked.add(true);
}

const List<Type> menu = const [Menu, MenuButton, MenuItem];
