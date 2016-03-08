import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';

import 'ripple.dart';

const num transitionDurationSeconds = 0.3;
const num transitionDurationFraction = 0.8;
const num closeTimeout = 150;

class MenuButtonClickedNotifier {
  EventEmitter<Map<String, Element>> menuButtonClicked = new EventEmitter();

  void click(Map<String, Element> clickInfo) {
    print('${clickInfo.keys} clicked');
    menuButtonClicked.add(clickInfo);
  }
}

MenuButtonClickedNotifier menuButtonClickedNotifier =
new MenuButtonClickedNotifier();

@Component(selector: 'rbi-menu-button', template: '<ng-content></ng-content>')
class MenuButton {
  EventEmitter<Element> menuButtonClicked = new EventEmitter();
  EventEmitter menuButtonKey = new EventEmitter();

  @Input() String buttonId;

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

@Component(
    selector: 'rbi-menu-container',
    template: ''
        '<div *ngIf="open" class="rbi-menu-outline mdl-shadow--2dp" '
        '[style.height]="height" '
        '[style.width]="width" '
        '[style.left]="left" '
        '[style.top]="top" '
        '[style.right]="right" '
        '[style.overflow]="\'visible\'" '
        '[style.bottom]="bottom" '
        '[style.padding-top]="\'.5em\'" '
        '[style.padding-bottom]="\'.5em\'" '
        '[class.bottom-left]="projection==\'bottom-left\'" '
        '[class.top-left]="projection==\'top-left\'" '
        '[class.bottom-right]="projection==\'bottom-right\'" '
        '[class.top-right]="projection==\'top-right\'">'
        '<ng-content></ng-content>'
//        '</div>'
        '</div>',
    styles: const [
//      'rbi-menu-container{transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);position:absolute;}',
      '.rbi-menu-outline{'
          'transform:none;'
          'visibility:visible;'
          'z-index:999;'
          'position:absolute;'
          'display:block;'
//          'border:solid black 1px;'
          'margin:0;'
//          'width: -webkit-fit-content;'
//          'width: fit-content;'
//          'height: -moz-fit-content;'
//          'height: -webkit-fit-content;'
//          'height: fit-content;'
          'background:white;'
          'color:#757575;'
          'outline-color:#BDBDBD;'
//          'background-color:white;'
          '}',
////      '.mdl-menu__container{height:200px;width:200px;z-index:999;}',
////      '.mdl-menu.rbi-menu{clip: initial;z-index:999}',
    ],
    directives: const [NgIf, Ripple])
class Menu implements AfterContentInit, OnDestroy {
  @Input() String projection = '';
  @Input() bool ripple = false;
  @Input() String buttonId;

//  @HostBinding('class.mdl-menu__container') bool isMenuContainer = true;
//  @HostBinding('class.is-visible') bool isVisible = true;
//  @HostBinding('class.is-animating') bool isAnimating = false;

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

  void onButtonClick(Element button) {
    Rectangle rect = button.getBoundingClientRect();
    // parent.parent because we wrapped the button in a rbi-menu-button
    // container
    Rectangle forRect = button.parent.parent.getBoundingClientRect();
    print(projection);
    if (projection == 'bottom-left' || projection == '') {
      left = '${button.offsetLeft}px';
      top = '${button.offsetTop + button.offsetHeight}px';
    } else if (projection == 'bottom-right') {
      right = '${forRect.right - rect.right}px';
      top = '${button.offsetTop + button.offsetHeight}px';
    } else if (projection == 'top-left') {
      left = '${button.offsetLeft}px';
      bottom = '${forRect.bottom - rect.top}px';
    } else if (projection == 'top-right') {
      right = '${forRect.right - rect.right}px';
      bottom = '${forRect.bottom - rect.top}px';
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
    for (StreamSubscription subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
  }
}

@Directive(selector: '.rbi-menu')
class MdlMenu {
//  @HostBinding('class.is-animating') bool isAnimating = true;
//  @HostBinding('class.is-visible') bool isVisible = true;
//  @HostBinding('class.rbi-menu') bool isRbi = true;
//  @HostBinding('style.clip') String clip = 'initial';
//  @HostBinding('style.position') String position = 'relative';
}

@Component(
    selector: 'rbi-menu-item',
    template: ''
        '<div class="rbi-menu-item-content">'
        '<ng-content></ng-content>'
        '</div>',
    styles: const [
      '.rbi-menu-item-content{'
          'display:block;'
//          'border:none;'
          'margin:0;'
          'white-space:nowrap;'
          'text-decoration:none;'
          'cursor:pointer;'
//          'width: 100%;'
//          'padding:0 16px;'
//          'background-color:lightblue;'
//          'position:relative;'
          'overflow:hidden;'
//          'height:48px;'
//          'line-height:48px;'
          'opacity:1;'
          '}'
    ]
)
class MenuItem {
  @Input() String disabled;
  @Attribute('tabindex') String tabIndex = '-1';
  @HostBinding('style.transition-delay') String transitionDelay = '';
  @HostBinding('style.display') String display = 'block';

//  @HostBinding('style.width') String width = '100%';
  @HostBinding('style.position') String position = 'relative';

//  @HostBinding('style.margin') String margin = '0';
  @HostBinding('style.padding') String padding = '0 16px';
  @HostBinding('style.height') String height = '48px';
  @HostBinding('style.line-height') String lineHeight = '48px';

//  @HostBinding('style.text-align') String textAlign = 'left';
  @HostBinding('style.overflow') String overflow = 'hidden';
  @ContentChild(Ripple) Ripple ripple;
  @Output() EventEmitter<bool> menuItemClicked = new EventEmitter();

  @HostListener('mousedown', const ['\$event.client', '\$event.target'])
  void onMouseDown(Point client, Element target) {
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

const List menu = const [Menu, MenuButton, MenuItem, MdlMenu];
