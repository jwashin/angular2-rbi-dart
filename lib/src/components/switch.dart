library component_switch;

import 'dart:async';

import 'package:angular2/angular2.dart';

import 'input_directives.dart';
import 'ripple.dart';

@Component(
    selector: '.mdl-switch',
    template: '''
<ng-content></ng-content>
<span class="mdl-switch__label"></span>
<div class="mdl-switch__track"></div>
<div class="mdl-switch__thumb">
  <span class="mdl-switch__focus-helper"></span>
</div>
<span class="mdl-switch__ripple-container" [centered]="true">
</span>
''',
    directives: const [Ripple])
class Switch implements AfterContentInit, OnDestroy {
  @HostBinding('class.is-checked') bool isChecked = false;
  @HostBinding('class.is-upgraded') bool isUpgraded = true;
  @HostBinding('class.is-disabled') bool isDisabled = false;
  @HostBinding('class.is-focused') bool isFocused = false;

  @ContentChild(FocusSource) FocusSource checkboxInput;
  @ContentChild(NgModel) NgModel ngModelInput;
  @ContentChildren(DisabledInput) QueryList<DisabledInput> disabledInput;

  List<StreamSubscription> subscriptions = [];

  @HostListener('mouseup')
  void onMouseUp() {
    if (checkboxInput != null) {
      Timer.run(() => checkboxInput.onBlur());
    }
  }

  void ngAfterContentInit() {
    //set listeners on the checkbox properties

    if (checkboxInput != null) {
      subscriptions.add(
          checkboxInput.hasFocus.listen((bool event) => isFocused = event));
    }
    if (ngModelInput != null) {
      Timer.run(() => isChecked = ngModelInput.value);
      subscriptions.add(
          ngModelInput.update.listen((bool newValue) => isChecked = newValue));
    }
    if (disabledInput.isNotEmpty) {
      Timer.run(() => isDisabled = true);
    }
    disabledInput.changes.listen((_) {
      if (disabledInput.isNotEmpty) {
        isDisabled = true;
      }
    });
  }

  void ngOnDestroy() {
    for (StreamSubscription subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
  }
}
