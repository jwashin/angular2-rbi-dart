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
        '<div *ngIf="open" class="mdl-menu__outline ng-animate" '
        '[style.height]="height" '
        '[style.width]="width" '
        '[style.left]="left" '
        '[style.top]="top" '
        '[style.right]="right" '
        '[style.bottom]="bottom" '
        '[style.z-index]="999" '
        '[class.mdl-menu--bottom-left]="projection==\'bottom-left\'" '
        '[class.mdl-menu--top-left]="projection==\'top-left\'" '
        '[class.mdl-menu--bottom-right]="projection==\'bottom-right\'" '
        '[class.mdl-menu--top-right]="projection==\'top-right\'"'
        '>'
        '<ng-content></ng-content>'
        '</div>',
    styles: const [
      '.mdl-menu__outline{transition-delay:0s;'
          'will-change:initial;'
          'transition: all .3s cubic-bezier(.4,0,.2,1);'
          'opacity:1;transform:scale(1)}',
      '.mdl-menu__outline.ng-enter{transform: scale(0)}',
      '.mdl-menu__outline.ng-enter-active{transform: scale(1);}'
    ],
    directives: const [
      CORE_DIRECTIVES,
      Ripple,
      MenuItem
    ])
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

  StreamSubscription<dynamic> clickAwayListener;

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
      item.active = false;
    }
  }

  void onButtonClick(Element button) {
//    while (!(['button'].contains(button.localName))) {
//      button = button.parent;
//    }
    if (clickAwayListener != null) {
      clickAwayListener.cancel();
    }
    Rectangle<num> rect = button.getBoundingClientRect();
    // parent.parent because we wrapped the button in a rbi-menu-button
    // container
    Rectangle<num> forRect = button.parent.parent.getBoundingClientRect();
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
    setItemTransitions();
    toggleDisplay();
    Timer.run(() {
      clickAwayListener = document.onClick.listen((_) => clickedAway());
    });
  }

  void clickedAway() {
    print('got event: clicked away');
//    print('show Event: $showEvent, click event: $clickEvent');
    print('I\'m open: $open');
    clickAwayListener.cancel();
    hide();
  }

  void toggleDisplay() {
    print('toggle away from $open');
    if (open) {
      hide();
    } else {
      open = true;
      print('now open');
    }
  }

  void hide() {

    resetTransitions();
    open = false;
    print('now closed');
  }

  void setItemTransitions() {
    List<MenuItem> items = menuItems.toList(growable: false);
    num menuLength = items.length;
    if (projection.startsWith('top')) {
      items = items.reversed.toList(growable: false);
    }
    num itemIncrement =
        transitionDurationSeconds * transitionDurationFraction / menuLength;
    num itemDelay = -itemIncrement;
    for (MenuItem item in items) {
      itemDelay += itemIncrement;
      item.transitionDelay = '${itemDelay}s';
      item.active = true;
    }
  }

  void ngAfterContentInit() {
    subscriptions.add(menuButtonClickedNotifier.menuButtonClicked
        .listen((Map<String, Element> data) {
      if (data.containsKey(buttonId)) {
        onButtonClick(data[buttonId]);
      }
    }));
    for (MenuItem menuItem in menuItems) {
      subscriptions.add(menuItem.menuItemClicked.listen((bool isClicked) {
        if (clickAwayListener != null) {
          clickAwayListener.cancel();
        }
        new Timer(new Duration(milliseconds: closeTimeout), () {
          hide();
        });
      }));
    }
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
        '<div *ngIf="active" class="item-text ng-animate"'
        ' [style.transition-delay]="transitionDelay"> '
        '<ng-content></ng-content>'
        '</div>',
    styles: const [
      '.item-text{opacity:1;  transition:all .3s cubic-bezier(.4,0,.2,1);}',
      '.item-text.ng-enter {opacity: 0;}',
      '.item-text.ng-enter-active {opacity: 1;}'
    ],
    directives: const [
      CORE_DIRECTIVES
    ])
class MenuItem {
  @Attribute('tabindex')
  String tabIndex = '-1';

  @HostBinding('style.opacity')
  String opacity = '1';
  @ContentChild(Ripple)
  Ripple ripple;
  @Output()
  EventEmitter<bool> menuItemClicked = new EventEmitter<bool>();

  bool active = false;
  String transitionDelay = '';

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
