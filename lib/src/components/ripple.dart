library component_ripple;

import 'dart:html';
import 'dart:math' show sqrt;
import 'package:angular2/angular2.dart';

@Component(
    selector: '.mdl-button__ripple-container, '
        '.mdl-menu__item-ripple-container, '
        '.mdl-switch__ripple-container, '
        '.mdl-checkbox__ripple-container, '
        '.mdl-radio__ripple-container, '
        '.mdl-icon-toggle__ripple-container',
    template: '<span class="mdl-ripple ng-animate" *ngIf="active"'
        '[style.width]="rippleSize" '
        '[style.height]="rippleSize" '
        '[style.top]="rippleY" '
        '[style.left]="rippleX" '
        '></span>',
    styles: const [
      '.mdl-ripple {transform: translate(-50%, -50%) scale(1);'
          'transition: all 0.6s cubic-bezier(0, 0, 0.2, 1);}',
      '.mdl-ripple.ng-enter {opacity: 0;'
          'transform: translate(-50%, -50%) scale(0.0001);}',
      '.mdl-ripple.ng-enter-active {opacity: .4;'
          'transform: translate(-50%, -50%) scale(1);}'
    ],
    directives: const [
      NgIf
    ])
class RippleContainer {
  @Input() bool centered = false;
  bool active = false;
  String rippleX, rippleY, rippleSize;

  @HostListener('mousedown', const ['\$event.client', '\$event.target'])
  void onMouseDown(Point clickPoint, Element rippleContainer, [bool center]) {
    Rectangle containerRect = rippleContainer.getBoundingClientRect();
    rippleSize = '${
        (sqrt(containerRect.width * containerRect.width
            + containerRect.height * containerRect.height) * 2 + 2).round()}px';
    bool centerRipple =
    center == null ? centered : center;
    if (centerRipple) {
      rippleX = '${(containerRect.right - containerRect.left) / 2}px';
      rippleY = '${(containerRect.bottom - containerRect.top) / 2}px';
    } else {
      rippleY = '${clickPoint.y - containerRect.top}px';
      rippleX = '${clickPoint.x - containerRect.left}px';
    }
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
