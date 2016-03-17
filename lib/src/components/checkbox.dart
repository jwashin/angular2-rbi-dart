library component_checkbox;

import 'dart:async';

import 'package:angular2/angular2.dart';

import 'ripple.dart';
import 'input_directives.dart';

@Component(
    selector: '.mdl-checkbox',
    template: '<ng-content></ng-content>'
        '<span class="mdl-checkbox__focus-helper"></span>'
        '<span class="mdl-checkbox__box-outline">'
        '  <span class="mdl-checkbox__tick-outline"></span>'
        '</span>'
        '<span *ngIf="shouldRipple" class="mdl-checkbox__ripple-container" '
        '[centered]="true"></span>',
    directives: const [NgIf, Ripple])
class Checkbox implements AfterContentInit, OnDestroy {
  @HostBinding('class.is-checked')
  bool isChecked = false;
  @HostBinding('class.is-upgraded')
  bool isUpgraded = true;
  @HostBinding('class.is-focused')
  bool isFocused = false;
  @HostBinding('class.is-disabled')
  bool isDisabled = false;
  @ContentChild(NgModel)
  NgModel ngModelInput;
  @ContentChild(InputSource)
  InputSource checkboxInput;

  @Input()
  bool shouldRipple = false;

  List<StreamSubscription<dynamic>> subscriptions = [];

  @HostListener('mouseup')
  void onMouseUp() {
    if (checkboxInput != null) {
      Timer.run(() => checkboxInput.onBlur());
    }
  }

  @HostListener('mousedown')
  void onMouseDown() {
    if (checkboxInput != null) {
      Timer.run(() => checkboxInput.onFocus());
    }
  }

  void ngAfterContentInit() {
    //get initial value and set listeners on the checkbox properties

    if (ngModelInput != null) {
      Timer.run(() => isChecked = ngModelInput.value);
      subscriptions.add(ngModelInput.update.listen((bool newValue) {
        isChecked = newValue;
      }));
    }

    if (checkboxInput != null) {
      subscriptions.add(
          checkboxInput.hasFocus.listen((bool event) => isFocused = event));
    } else {
      Timer.run(() => isDisabled = true);
    }
  }

  void ngOnDestroy() {
    for (StreamSubscription<dynamic> subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
  }
}
