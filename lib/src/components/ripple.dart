library component_ripple;

import 'dart:html';
import 'dart:math' show sqrt;
import 'dart:async';
import 'package:angular2/angular2.dart';

@Component(
    selector: '.mdl-button__ripple-container, '
        '.mdl-menu__item--ripple-container, '
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
          'transition: all 0.4s cubic-bezier(0, 0, 0.2, 1);}',
      '.mdl-ripple.ng-enter {opacity: 0;'
          'transform: translate(-50%, -50%) scale(0);}',
      '.mdl-ripple.ng-enter-active {opacity: .4;'
          'transform: translate(-50%, -50%) scale(1);}'
    ],
    directives: const [
      CORE_DIRECTIVES
    ])
class Ripple {
  @Input()
  bool centered = false;
  bool active = false;
  String rippleX, rippleY, rippleSize;

  @HostListener('mousedown', const ['\$event.client', '\$event.target'])

  /// Calculate center of the ripple effect and activate it.
  void onMouseDown(Point<num> clickPoint, Element rippleTarget,
      [bool centerOnTarget]) {
    Rectangle<num> containerRect = rippleTarget.getBoundingClientRect();
    rippleSize = '${
        (sqrt(containerRect.width * containerRect.width
            + containerRect.height * containerRect.height) * 2 + 2).round()}px';
    bool centerRipple = centerOnTarget == null ? centered : centerOnTarget;
    if (centerRipple) {
      rippleX = '${(containerRect.right - containerRect.left) / 2}px';
      rippleY = '${(containerRect.bottom - containerRect.top) / 2}px';
    } else {
      rippleY = '${clickPoint.y - containerRect.top}px';
      rippleX = '${clickPoint.x - containerRect.left}px';
    }
    active = true;
//    print('rippling');
    new Timer(new Duration(milliseconds: 500), (() => active = false));
  }

  @HostListener('mouseup')
  void onMouseUp() {
    active = false;
  }

  @HostListener('touchstart', const ['\$event.touches[0]', '\$event.target'])
  void onTouchStart(Point<num> client, Element target) =>
      onMouseDown(client, target);
}
