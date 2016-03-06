library component_ripple;

import 'dart:html';
import 'dart:math' show sqrt;
import 'package:angular2/angular2.dart';

@Directive(selector: '.mdl-ripple')
class Ripple {
  @HostBinding('class.is-visible') bool visible = false;
  @HostBinding('class.is-animating') bool animating = false;
}

@Component(
    selector: '.mdl-button__ripple-container, '
        '.mdl-menu__item-ripple-container, '
        '.mdl-switch__ripple-container, '
        '.mdl-checkbox__ripple-container, '
        '.mdl-radio__ripple-container, '
        '.mdl-icon-toggle__ripple-container',
    template: '<span class="mdl-ripple ng-animate" *ngIf="active"'
        '[style.width]="rippleWidth" '
        '[style.height]="rippleHeight" '
        '[style.top]="rippleY" '
        '[style.left]="rippleX" '
        '></span>',
    styles: const [
      '.mdl-ripple {transform: translate(-50%, -50%) scale(1);'
          'transition: all 0.6s cubic-bezier(0.0, 0.0, 0.2, 1.0);}',
      '.mdl-ripple.ng-enter {opacity: 0;'
          'transform: translate(-50%, -50%) scale(0.0001);}',
      '.mdl-ripple.ng-enter-active {opacity: .8;'
          'transform: translate(-50%, -50%) scale(1);}'
    ],
    directives: const [
      Ripple,
      NgIf
    ])
class RippleContainer {
  @ViewChild(Ripple) Ripple ripple;
  @Input() bool centered = false;
  bool active = false;
  String rippleX, rippleY, rippleWidth, rippleHeight;

  @HostListener('mousedown', const ['\$event.client', '\$event.target'])
  void onMouseDown(Point client, Element ripple) {
    Rectangle rect = ripple.getBoundingClientRect();
    int boundHeight = rect.height.toInt();
    int boundWidth = rect.width.toInt();
    int rippleSize =
    (sqrt(boundWidth * boundWidth + boundHeight * boundHeight) * 2 + 2)
        .toInt();
    rippleWidth = '${rippleSize}px';
    rippleHeight = '${rippleSize}px';
    num x, y;
    num clientX, clientY;
    clientX = client.x;
    clientY = client.y;
    if (centered) {
      x = (rect.right - rect.left) / 2;
      y = (rect.bottom - rect.top) / 2;
    } else {
      y = clientY - rect.top;
      x = clientX - rect.left;
    }
    rippleX = '${x}px';
    rippleY = '${y}px';
    active = true;
  }

  @HostListener('mouseup')
  void onMouseUp() {
    active = false;
  }

  @HostListener('touchstart', const ['\$event.touches[0]', '\$event.target'])
  void onTouchStart(Point client, Element target) =>
      onMouseDown(client, target);
}

const List ripples = const [Ripple, RippleContainer];
