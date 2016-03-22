library component_switch;

import 'dart:async';

import 'package:angular2/angular2.dart';

import 'input_directives.dart';
import 'ripple.dart';

@Component(
    selector: '.mdl-switch',
    template: '<ng-content></ng-content>'
        '<span class="mdl-switch__label"></span>'
        '<div class="mdl-switch__track"></div>'
        '<div class="mdl-switch__thumb">'
        '  <span class="mdl-switch__focus-helper"></span>'
        '</div>'
        '<span *ngIf="shouldRipple" class="mdl-switch__ripple-container" '
        '>'
        '</span>',
    directives: const [NgIf, Ripple])
class Switch implements AfterContentInit, OnDestroy {
  @HostBinding('class.is-checked')
  bool isChecked = false;
  @HostBinding('class.is-upgraded')
  bool isUpgraded = true;
  @HostBinding('class.is-disabled')
  bool isDisabled = false;
  @HostBinding('class.is-focused')
  bool isFocused = false;

  @Input()
  bool shouldRipple = false;

  @ContentChild(InputSource)
  InputSource checkboxInput;
  @ContentChild(NgModel)
  NgModel ngModelInput;

  @ViewChild(Ripple)
  Ripple ripple;

  List<StreamSubscription<bool>> subscriptions = [];

  @HostListener('mousedown')
  void onMouseDown() {
    if (checkboxInput != null && !isDisabled) {
      ripple?.startRipple(ripple.ref.nativeElement.getBoundingClientRect());
      Timer.run(() => checkboxInput.onFocus());
    }
  }

  @HostListener('mouseup')
  void onMouseUp() {
    if (checkboxInput != null) {
      Timer.run(() => checkboxInput.onBlur());
//      ripple?.endRipple();
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
