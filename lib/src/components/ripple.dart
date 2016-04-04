library rbi_components_ripple;

import 'dart:math' show sqrt;
import 'dart:async';
import 'package:angular2/angular2.dart';

/// The transformer replaces class "mdl-js-ripple-effect" with a property,
/// [shouldRipple]="true". This mostly alleviates the need for two Dart classes,
/// one with ripple, and one without, for each affected component. So, many of
/// these components can stand alone without the transformer, by using this
/// property instead.
///
/// This implementation differs substantially from the MDL js implementation. It
/// uses ng-animate, and it is (presumably) distilled to something minimal and
/// understandable, yet functional.

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
      // at the moment, angular2 only allows one transition timing
      '.mdl-ripple {transform: translate(-50%, -50%) scale(1);'
          'transition: all 0.45s cubic-bezier(0, 0, 0.2, 1);'
          '}',
      '.mdl-ripple.ng-enter {opacity: 0;'
          'transform: translate(-50%, -50%) scale(0);}',
      '.mdl-ripple.ng-enter-active {opacity: 0.3;'
          'transform: translate(-50%, -50%) scale(1);}'
    ],
    directives: const [
      NgIf
    ])
class Ripple {
  // active invokes the *ngIf in the template and makes ng-animate magic happen.
  bool active = false;

  // calculated values for the ripple thing: x and y for centering, and a size,
  // which needs to be larger than the target.
  String rippleX,
      rippleY,
      rippleSize = '';

  // We hold on to a ref here because sometimes, the rippling target is the
  // ripple container itself, like in checkbox or radio.
  ElementRef ref;
  Ripple(this.ref);

  /// Calculate center of the ripple effect and activate it.
  /// If clickPoint is null, center on the target.
  void startRipple(dynamic targetRect, [dynamic clickPoint]) {
    active = false;
    rippleSize = '${
        (sqrt(targetRect.width * targetRect.width
            + targetRect.height * targetRect.height) * 2 + 2)
            .round()}px';
    if (clickPoint == null) {
      rippleX = '${(targetRect.right - targetRect.left) / 2}px';
      rippleY = '${(targetRect.bottom - targetRect.top) / 2}px';
    } else {
      rippleY = '${clickPoint.y - targetRect.top}px';
      rippleX = '${clickPoint.x - targetRect.left}px';
    }
    active = true;
    new Timer(new Duration(milliseconds: 500), () => active = false);
  }
}
