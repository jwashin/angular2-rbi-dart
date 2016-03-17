import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';

import 'ripple.dart';

const num transitionDurationSeconds = 0.3;
const num transitionDurationFraction = 0.8;
const num closeTimeout = 150;

const int enter = 13;
const int escape = 27;
const int space = 32;
const int upArrow = 38;
const int downArrow = 40;

class MenuButtonClickedNotifier {
  EventEmitter<Map<String, Element>> menuButtonClicked =
  new EventEmitter<Map<String, Element>>();

  void click(Map<String, Element> clickInfo) {
    menuButtonClicked.add(clickInfo);
  }
}

class MenuButtonKeyNotifier {
  EventEmitter<Map<String, int>> menuButtonKeyPressed =
  new EventEmitter<Map<String, int>>();

  void keyPress(Map<String, int> keyInfo) {
    menuButtonKeyPressed.add(keyInfo);
  }
}

MenuButtonClickedNotifier menuButtonClickedNotifier =
new MenuButtonClickedNotifier();

MenuButtonKeyNotifier menuButtonKeyNotifier = new MenuButtonKeyNotifier();

@Component(selector: 'rbi-menu-button', template: '<ng-content></ng-content>')
class MenuButton {
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

  @HostListener('focus', const ['\$event.target'])
  void onFocus(Element target) => onClick(target);

  @HostListener('keydown', const ['\$event'])
  void onKeyDown(KeyboardEvent event) {
    int keyCode = event.keyCode;
    if ([upArrow, downArrow].contains(keyCode)) {
      event.preventDefault();
      print('key pressed $keyCode');
      menuButtonKeyNotifier.keyPress({buttonId: keyCode});
    }
  }
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
        '[style.z-index]="\'999\'" '
        '[class.mdl-menu--bottom-left]="projection==\'bottom-left\'" '
        '[class.mdl-menu--top-left]="projection==\'top-left\'" '
        '[class.mdl-menu--bottom-right]="projection==\'bottom-right\'" '
        '[class.mdl-menu--top-right]="projection==\'top-right\'"'
        '>'
        '<ng-content></ng-content>'
        '</div>',
    styles: const [
      '.mdl-menu__outline{transition-delay:0s;'
          'padding:8px 0;'
          'transition: all .3s cubic-bezier(.4,0,.2,1);'
          'opacity:1;transform:scale(1)}',
      '.mdl-menu__outline.ng-enter{transform: scale(0)}',
      '.mdl-menu__outline.ng-enter-active{transform: scale(1);}',
    ],
    directives: const [
      NgIf,
      Ripple
    ])
class Menu implements AfterContentInit, OnDestroy {
  @Input()
  String projection = '';
  @Input()
  bool shouldRipple = false;
  @Input()
  String buttonId;

  @ContentChildren(MenuItem, descendants: true)
  QueryList<MenuItem> menuItems;

  List<StreamSubscription<dynamic>> subscriptions = [];

  StreamSubscription<dynamic> clickAwayListener;

  bool open = false;
  int menuItemCount = 0;

//  void menuItemClicked() {}

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
    setItemProperties();
    toggleDisplay();
    // If we start the listener right now, then we have to check whether the
    // click that got here came from the listener.
    Timer.run(() {
      clickAwayListener = document.onClick.listen((_) => clickedAway());
    });
  }

  void clickedAway() {
    clickAwayListener.cancel();
    hide();
  }

  void toggleDisplay() {
    if (open) {
      hide();
    } else {
      open = true;
    }
  }

  void hide() {
    resetTransitions();
    open = false;
  }

  void handleForKeyboardEvent(int keyCode) {
    List<MenuItem> items = menuItems.toList(growable: false);
    if (items.length > 0 && open) {
      if (keyCode == upArrow) {
        items.last.focus();
      } else if (keyCode == downArrow) {
        items.first.focus();
      }
    }
  }

  void handleItemKeyboardEvent(MenuItem item, KeyboardEvent event) {
    List<MenuItem> items = menuItems
        .where((MenuItem item) => !item.isDisabled)
        .toList(growable: false);
    int keyCode = event.keyCode;
    if (items.length > 0) {
      int currentIndex = items.indexOf(item);
      if (keyCode == upArrow) {
        event.preventDefault();
        if (currentIndex > 0) {
          items[currentIndex - 1].focus();
        } else {
          items[items.length - 1].focus();
        }
      } else if (keyCode == downArrow) {
        event.preventDefault();
        if (items.length > currentIndex + 1) {
          items[currentIndex + 1].focus();
        } else {
          items[0].focus();
        }
      } else if (keyCode == space || keyCode == enter) {
        event.preventDefault();
//        event.target.dispatchEvent(new MouseEvent('mousedown'));
        item.keyRipple(event.target);
//        event.target.dispatchEvent(new MouseEvent('mouseup'));
//        event.target.dispatchEvent(new MouseEvent('click'));
        item.click();
      } else if (keyCode == escape) {
        event.preventDefault();
        hide();
      }
    }
  }

  void setItemProperties() {
    List<MenuItem> items = menuItems.toList(growable: false);
    num menuLength = items.length;
//    print('menu length: $menuLength');
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
      item.shouldRipple = shouldRipple;
    }
  }

  void ngAfterContentInit() {
    subscriptions.add(menuButtonClickedNotifier.menuButtonClicked
        .listen((Map<String, Element> data) {
      if (data.containsKey(buttonId)) {
        onButtonClick(data[buttonId]);
      }
    }));

    subscriptions.add(menuButtonKeyNotifier.menuButtonKeyPressed
        .listen((Map<String, int> data) {
      if (data.containsKey(buttonId)) {
        handleForKeyboardEvent(data[buttonId]);
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
      subscriptions.add(menuItem.keyPressed.listen((Map<String, dynamic> data) {
        handleItemKeyboardEvent(data['item'], data['event']);
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
        ' [style.transition-delay]="transitionDelay"'
        '> '
        '  <ng-content></ng-content> '
        '  <div *ngIf="shouldRipple" class="mdl-menu__item--ripple-container">'
        '  </div>'
        '</div>',
    styles: const [
      '.item-text{overflow:hidden; opacity:1;  '
          'transition:all .3s cubic-bezier(.4,0,.2,1);}',
      '.item-text.ng-enter {opacity: 0;}',
      '.item-text.ng-enter-active {opacity: 1;}'
    ],
    directives: const [
      NgIf,
      Ripple
    ])
class MenuItem {
  ElementRef ref;
  Renderer renderer;

  MenuItem(this.ref, this.renderer);

  @Input()
  dynamic disabled = false;

  bool get isDisabled => disabled == '' ? true : disabled;

  @ViewChild(Ripple)
  Ripple ripple;

  @Output()
  EventEmitter<bool> menuItemClicked = new EventEmitter<bool>();

  @Output()
  EventEmitter<Map<String, dynamic>> keyPressed =
  new EventEmitter<Map<String, dynamic>>();

  bool active = false;
  String transitionDelay = '';
  bool shouldRipple = false;

  void focus() {
    renderer.invokeElementMethod(ref.nativeElement, 'focus', []);
  }

  void click() {
    renderer.invokeElementMethod(ref.nativeElement, 'click', []);
  }

  @HostListener('focus')
  void gotFocus() {
    print('got Focus');
  }

  @HostListener('mousedown', const ['\$event.client', '\$event.target'])
  void onMouseDown(Point<num> client, Element target) {
    ripple?.onMouseDown(client, target);
  }

  @HostListener('mouseup')
  void onMouseUp() {
    ripple?.onMouseUp();
  }

  @HostListener('click')
  void onClick() => menuItemClicked.add(true);

  @HostListener('keydown', const ['\$event'])
  void onKeyDown(KeyboardEvent event) {
    keyPressed.add({'item': this, 'event': event});
  }

  void keyRipple(Element target) {
    ripple?.onMouseDown(null, target, true);
  }
}

const List<Type> menu = const [Menu, MenuButton, MenuItem];
