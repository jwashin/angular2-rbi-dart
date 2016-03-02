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
<span class="mdl-switch__ripple-container">
</span>
''',
    directives: const [CenteredRippleContainer])
class Switch implements AfterContentInit {
  @HostBinding('class.is-checked') bool isChecked;
  @HostBinding('class.is-upgraded') bool isUpgraded = true;
  @HostBinding('class.is-disabled') bool isDisabled = false;
  @HostBinding('class.is-focused') bool isFocused = false;

  @ContentChild(FocusSource) FocusSource checkboxInput;
  @ContentChild(NgModel) NgModel ngModelInput;
  @ContentChild(DisabledInput) DisabledInput disabledInput;

  @HostListener('mouseup')
  void onMouseUp() {
    if (checkboxInput != null) {
      Timer.run(() => checkboxInput.onBlur());
    }
  }

  void ngAfterContentInit() {
    //set listeners on the checkbox properties

    if (checkboxInput != null) {
      checkboxInput.hasFocus.listen((bool event) => isFocused = event);
    }
    if (ngModelInput != null) {
      isChecked = ngModelInput.value;
      ngModelInput.update.listen((bool newValue) => isChecked = newValue);
    }
    if (disabledInput != null) {
      isDisabled = true;
    }
  }
}
