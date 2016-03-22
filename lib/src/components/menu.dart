import 'dart:async';

import 'package:angular2/angular2.dart';

//import 'package:angular2_rbi/src/util/target_util.dart';

import 'ripple.dart';
import 'button.dart';

const num transitionDurationSeconds = 0.3;
const num transitionDurationFraction = 0.8;
const num closeTimeout = 150;

const int enter = 13;
const int escape = 27;
const int space = 32;
const int upArrow = 38;
const int downArrow = 40;

class MenuButtonNotifier {
  EventEmitter<ButtonMessage> buttonInfo = new EventEmitter<ButtonMessage>();

  void notify(ButtonMessage info) {
    buttonInfo.add(info);
  }
}

MenuButtonNotifier menuButtonNotifier = new MenuButtonNotifier();

class ButtonMessage {
  String buttonId;
  String message;
  dynamic data;

  ButtonMessage(this.buttonId, this.message, this.data);
}

@Component(selector: 'rbi-menu-button', template: '<ng-content></ng-content>')
class MenuButton implements AfterContentInit, OnDestroy {
  @Input()
  String buttonId;

  StreamSubscription<bool> focusListener;

  @ContentChild(Button)
  Button button;

  @HostListener('click', const ['\$event.target'])
  void onClick(dynamic target) {
    button.focus();
    menuButtonNotifier.notify(new ButtonMessage(buttonId, 'click', target));
  }

  void focusHandler(bool focused) {
    menuButtonNotifier.notify(new ButtonMessage(buttonId, 'focus', focused));
  }

  @HostListener('keydown', const ['\$event'])
  void onKeyDown(dynamic event) {
    int keyCode = event.keyCode;
    if ([upArrow, downArrow].contains(keyCode)) {
      event.preventDefault();
      menuButtonNotifier
          .notify(new ButtonMessage(buttonId, 'keydown', keyCode));
    }
  }

  void ngAfterContentInit() {
    button.keepFocus = true;
    focusListener = button.hasFocus.listen((bool hasFocus) {
      focusHandler(hasFocus);
    });
  }

  void ngOnDestroy() {
    focusListener.cancel();
  }
}

@Component(
    selector: 'rbi-menu-container',
    template: ''
        '<div *ngIf="open" class="mdl-menu__outline ng-animate" '
        '[style.height]="height" '
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
          'opacity:1;transform:scale(1);'
          'width: -webkit-max-content;'
          'width: -moz-max-content;'
          'width: max-content;}',
      '.mdl-menu__outline.ng-enter{transform: scale(0)}',
      '.mdl-menu__outline.ng-enter-active{transform: scale(1);}',
      '.mdl-menu__outline.ng-leave{transform: scale(1);}',
      '.mdl-menu__outline.ng-leave-active{transform: scale(0);}',
      '.mdl-menu__item{position:relative;}',
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

  bool open = false;
  bool buttonFocused = false;
  bool willCheckFocusSoon = false;

  bool get focused =>
      buttonFocused || menuItems.any((MenuItem i) => i.isFocused);

  String left,
      right,
      top,
      bottom,
      height = 'auto';

  void resetMenu() {
    buttonFocused = false;
    for (MenuItem item in menuItems) {
      item.transitionDelay = '';
      item.active = false;
      item.isFocused = false;
    }
  }

  void onButtonClick(dynamic button) {
    dynamic rect = button.getBoundingClientRect();
    // parent.parent because the transformer wrapped the button in a
    // rbi-menu-button container
    dynamic forRect = button.parent.parent.getBoundingClientRect();
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
  }

  void toggleDisplay() {
    if (open) {
      hide();
    } else {
      open = true;
    }
  }

  void hide() {
    resetMenu();
    open = false;
  }

  void handleForKeyboardEvent(int keyCode) {
    List<MenuItem> items = menuItems
        .where((MenuItem item) => !item.isDisabled)
        .toList(growable: false);
    if (items.length > 0 && open) {
      if (keyCode == upArrow) {
        items.last.focus();
      } else if (keyCode == downArrow) {
        items.first.focus();
      }
    }
  }

  void handleItemKeyboardEvent(MenuItem item, dynamic event) {
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
          items.first.focus();
        }
      } else if (keyCode == space || keyCode == enter) {
        event.preventDefault();
        item.keyRipple(event.target.getBoundingClientRect());
        item.click();
      } else if (keyCode == escape) {
        event.preventDefault();
        hide();
      }
    }
  }

  void setItemProperties() {
    dynamic items = menuItems.toList(growable: false);
    num menuLength = items.length;
    if (projection.startsWith('top')) {
      items = items.reversed;
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
    subscriptions
        .add(menuButtonNotifier.buttonInfo.listen((ButtonMessage data) {
      if (data.buttonId == buttonId) {
        if (data.message == 'click') {
          onButtonClick(data.data);
        } else if (data.message == 'keydown') {
          handleForKeyboardEvent(data.data);
        } else if (data.message == 'focus') {
          buttonFocused = data.data;
          checkFocusSoon();
        }
      }
    }));

    for (MenuItem menuItem in menuItems) {
      subscriptions
          .add(menuItem.menuItemNotifier.listen((MenuItemMessage info) {
        if (info.message == 'click') {
          new Timer(new Duration(milliseconds: closeTimeout), () {
            hide();
          });
        } else if (info.message == 'keydown') {
          handleItemKeyboardEvent(info.data['item'], info.data['event']);
        } else if (info.message == 'focus') {
          checkFocusSoon();
        }
      }));
    }
  }

  void checkFocus() {
    if (open && !focused) {
      hide();
    }
    willCheckFocusSoon = false;
  }

  void checkFocusSoon() {
    if (!willCheckFocusSoon) {
      willCheckFocusSoon = true;
      new Timer(new Duration(milliseconds: 250), checkFocus);
    }
  }

  void ngOnDestroy() {
    for (StreamSubscription<dynamic> subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
  }
}

class MenuItemMessage {
  String message;
  dynamic data;

  MenuItemMessage(this.message, [this.data]);
}

@Component(
    selector: '.mdl-menu__item',
    template: ''
        '<div *ngIf="active" class="item-text ng-animate"'
        ' [style.transition-delay]="transitionDelay" '
        '> '
        '  <ng-content></ng-content> '
        '  <div *ngIf="shouldRipple" class="mdl-menu__item--ripple-container">'
        '  </div>'
        '</div>',
    styles: const [
      '.item-text{opacity:1;  '
          'transition:all .3s cubic-bezier(.4,0,.2,1);'
          'font-family: \'Roboto\',\'Helvetica\',\'Arial\',sans-serif;}',
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

  @HostBinding('style.position')
  String position = 'relative';

  @Input()
  dynamic disabled = false;

  bool get isDisabled => disabled == '' ? true : disabled;

  bool isFocused = false;

  @ViewChild(Ripple)
  Ripple ripple;

  @Output()
  EventEmitter<MenuItemMessage> menuItemNotifier =
  new EventEmitter<MenuItemMessage>();

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
    isFocused = true;
    menuItemNotifier.add(new MenuItemMessage('focus'));
  }

  @HostListener('blur')
  void blurred() {
    isFocused = false;
    menuItemNotifier.add(new MenuItemMessage('focus'));
  }

  @HostListener('mousedown',
      const ['\$event.client', '\$event.target.getBoundingClientRect()'])
  void onMouseDown(dynamic client, dynamic target) {
    if (!isDisabled) {
      ripple?.startRipple(target, client);
    }
  }

  @HostListener('touchstart',
      const ['\$event.touches[0]', '\$event.target.getBoundingClientRect()'])
  void onTouchStart(dynamic client, dynamic target) {
    onMouseDown(client, target);
  }

  @HostListener('click')
  void onClick() => menuItemNotifier.add(new MenuItemMessage('click'));

  @HostListener('keydown', const ['\$event'])
  void onKeyDown(dynamic event) {
    menuItemNotifier
        .add(new MenuItemMessage('keydown', {'item': this, 'event': event}));
  }

  void keyRipple(dynamic target) {
    ripple?.startRipple(target);
  }
}

const List<Type> menu = const [Menu, MenuButton, MenuItem];
