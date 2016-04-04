library rbi_component_icon_toggle;

import 'dart:async';
import 'package:angular2/angular2.dart';
import 'input_directives.dart';
import 'ripple.dart';

@Component(
    selector: '.mdl-js-icon-toggle',
    template: '<ng-content></ng-content>'
        '<span *ngIf="shouldRipple" class="mdl-icon-toggle__ripple-container" '
        '></span>',
    directives: const [NgIf, Ripple])
class IconToggle implements AfterContentInit, OnDestroy {
  @HostBinding('class.is-checked')
  bool isChecked = false;
  @HostBinding('class.is-upgraded')
  bool isUpgraded = true;
  @HostBinding('class.is-disabled')
  bool isDisabled = false;
  @HostBinding('class.is-focused')
  bool isFocused = false;

  @ContentChild(NgModel)
  NgModel ngModelInput;
  @ContentChild(InputSource)
  InputSource checkboxInput;

  @Input()
  bool shouldRipple = false;

  @ViewChild(Ripple)
  Ripple ripple;

  List<StreamSubscription<bool>> subscriptions = [];

  @HostListener('mouseup')
  void onMouseUp() {
    if (checkboxInput != null) {
//      ripple?.endRipple();
      Timer.run(() => checkboxInput.onBlur());
    }
  }

  @HostListener('mousedown')
  void onMouseDown() {
    if (checkboxInput != null && !isDisabled) {
      ripple?.startRipple(ripple.ref.nativeElement.getBoundingClientRect());
      Timer.run(() => checkboxInput.onFocus());
    }
  }

  void ngAfterContentInit() {
    //set listeners on the checkbox properties

    if (checkboxInput != null) {
      subscriptions.add(
          checkboxInput.hasFocus.listen((bool event) => isFocused = event));
    } else {
      Timer.run(() => isDisabled = true);
    }
    if (ngModelInput != null) {
      Timer.run(() => isChecked = ngModelInput.value);
      subscriptions.add(
          ngModelInput.update.listen((bool newValue) => isChecked = newValue));
    }
  }

  void ngOnDestroy() {
    for (StreamSubscription<bool> subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
  }
}
