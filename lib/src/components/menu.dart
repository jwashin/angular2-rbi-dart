import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';

import 'ripple.dart';

const num transitionDurationSeconds = 0.3;
const num transitionDurationFraction = 0.8;
const num closeTimeout = 150;

@Component(selector: 'rbi-menu-manager', template: '<ng-content></ng-content>')
class MenuManager implements AfterContentInit, OnDestroy {
  @ContentChild(MenuButton) MenuButton menuButton;
  @ContentChild(Menu) Menu menu;

  List<StreamSubscription> subscriptions = [];

//
//
  void show(Element button) {
//    menu.isAnimating = true;
//    menuContainer.isVisible = true;
//    for (MenuItem item in menuItems){
//      if (['top-left','top-right'].contains(menu.projection)){
//        animateTopToBottom();
//      }
//      else{
//        animateBottomToTop();
//      }
//    }
    print('open set');
    menu.open = true;
  }

  void animateTopToBottom() {}

  void animateBottomToTop() {}

//
  void handleButtonClicked(Element button) {
    Rectangle rect = button.getBoundingClientRect();
    Rectangle forRect = button.parent.getBoundingClientRect();
    print(menu.projection);
    if (menu.projection == 'bottom-left' || menu.projection == '') {
      menu.left = '${button.offsetLeft}px';
      menu.top = '${button.offsetTop + button.offsetHeight}px';
    } else if (menu.projection == 'bottom-right') {
      menu.right = '${forRect.right - rect.right}px';
      menu.top = '${button.offsetTop + button.offsetHeight}px';
    } else if (menu.projection == 'top-left') {
      menu.left = '${button.offsetLeft}px';
      menu.bottom = '${forRect.bottom - rect.top}px';
    } else if (menu.projection == 'top-right') {
      menu.right = '${forRect.right - rect.right}px';
      menu.bottom = '${forRect.bottom - rect.top}px';
    }
    toggle(button);
  }

  void toggle(Element button) {
    if (menu.open) {
      hide();
    } else {
      show(button);
    }
  }

  void hide() {
    menu.resetTransitions();
    menu.open = false;
//    menu.isAnimating = false;
  }

  void ngAfterContentInit() {
    print("afterContentInit called");
    if (menuButton != null && subscriptions.isEmpty) {
      subscriptions.add(menuButton.menuButtonClicked.listen((Element value) {
        handleButtonClicked(value);
      }));
    }
  }

  void ngOnDestroy() {
    print("menumanager Destroy  called");
    for (StreamSubscription subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
  }
}

@Component(selector: 'rbi-menu-button', template: '<ng-content></ng-content>')
class MenuButton {
  EventEmitter<Element> menuButtonClicked = new EventEmitter();
  EventEmitter menuButtonKey = new EventEmitter();

  bool open = false;

  @HostListener('click', const ['\$event.target'])
  void onClick(Element target) {
    print("menubuttonclick.onclick");
    menuButtonClicked.add(target);
  }

  @HostListener('keydown')
  void onKeyDown() {}
}

@Component(
    selector: 'rbi-menu-container',
    template: ''
//        '<div *ngIf="open" class="mdl-menu__container is-visible is-animating" '
//        '[style.left]="left" '
//        '[style.top]="top" '
//        '[style.right]="right" '
//        '[style.bottom]="bottom" '
//        '[style.width]="width" '
//        '[style.height]="height">'
        '<div *ngIf="open" class="mdl-menu__outline" '
        '[style.height]="height" '
        '[style.width]="width" '
        '[style.left]="left" '
        '[style.top]="top" '
        '[style.right]="right" '
        '[style.bottom]="bottom" '
        '[class.mdl-menu--bottom-left]="projection==\'bottom-left\'" '
        '[class.mdl-menu--top-left]="projection==\'top-left\'" '
        '[class.mdl-menu--bottom-right]="projection==\'bottom-right\'" '
        '[class.mdl-menu--top-right]="projection==\'top-right\'">'
        '<ng-content></ng-content>'
//        '</div>'
        '</div>',
    styles: const [
      'rbi-menu-container{transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);position:absolute;}',
      '.mdl-menu__outline{height:auto;width:auto;overflow:auto;position:static;}',
      '.mdl-menu__container{height:200px;width:200px;z-index:999;}',
      '.mdl-menu{z-index:1000;clip:auto;position:static;}',
    ],
    directives: const [
      NgIf
    ])
class Menu implements AfterContentInit, OnDestroy {
  @Input() String projection = '';
  @Input() bool ripple = false;

  @HostBinding('class.mdl-menu__container') bool isMenuContainer = true;
  @HostBinding('class.is-visible') bool isVisible = true;
  @HostBinding('class.is-animating') bool isAnimating = true;

  @ContentChildren(MenuItem) QueryList<MenuItem> menuItems;

  List<StreamSubscription> subscriptions = [];

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

  void setTransitions() {}

  void ngAfterContentInit() {
    subscriptions.add(menuItems.changes.listen((_) {
      menuItemCount = 0;
      for (MenuItem item in menuItems) {
        menuItemCount += 1;
        if (ripple) {
          item.ripple = true;
        }
      }
    }));

//    for (MenuItem item in menuItems) {
//      if (ripple) {
//        item.ripple = true;
//      }
//      menuItemCount += 1;
//      subscriptions.add(item.menuItemClicked.listen((_) {
//        menuItemClicked();
//      }));
//    }
  }

  void ngOnDestroy() {
    for (StreamSubscription subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
  }
}

@Directive(selector: '.mdl-menu')
class MdlMenu {
  @HostBinding('class.is-animating') bool isAnimating = true;
  @HostBinding('class.is-visible') bool isVisible = true;
}

@Component(
    selector: '.mdl-menu__item',
    template: '<ng-content></ng-content>'
        '<span *ngIf="ripple" class="mdl-menu__item-ripple-container"></span>',
    directives: const [NgIf, RippleContainer])
class MenuItem {
  @Input() String disabled;
  @Input() bool ripple = false;
  @Attribute('tabindex') String tabIndex = '-1';
  @HostBinding('style.transition-delay') String transitionDelay = '';
  @Output() EventEmitter<bool> menuItemClicked = new EventEmitter();

  @HostListener('click')
  void onClick() => menuItemClicked.add(true);
}

const List menu = const [MenuManager, Menu, MenuButton, MenuItem, MdlMenu];
