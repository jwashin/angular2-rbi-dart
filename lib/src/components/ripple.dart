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
      '.mdl-ripple.ng-enter-active {opacity: .8;'
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
  void onMouseDown(Point clickPoint, Element rippleContainer) {
    Rectangle rect = rippleContainer.getBoundingClientRect();
    rippleSize = '${
        sqrt(rect.width * rect.width + rect.height * rect.height) * 2 + 2}px';
    if (centered) {
      rippleX = '${(rect.right - rect.left) / 2}px';
      rippleY = '${(rect.bottom - rect.top) / 2}px';
    } else {
      rippleY = '${clickPoint.y - rect.top}px';
      rippleX = '${clickPoint.x - rect.left}px';
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
