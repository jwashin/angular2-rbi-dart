library component_checkbox;

import 'dart:html';
import 'dart:async';

import 'package:angular2/angular2.dart';

import 'ripple.dart';
import 'input_directives.dart';

@Component(
    selector: '.mdl-checkbox',
    template: '''
<ng-content></ng-content>
<span class="mdl-checkbox__focus-helper"></span>
<span class="mdl-checkbox__box-outline">
  <span class="mdl-checkbox__tick-outline"></span>
</span>
<span class="mdl-checkbox__ripple-container"></span>
''',
    directives: const [CenteredRippleContainer])
class Checkbox implements AfterContentInit {
  @HostBinding('class.is-checked') bool isChecked;
  @HostBinding('class.is-upgraded') bool isUpgraded = true;
  @HostBinding('class.is-focused') bool isFocused = false;
  @HostBinding('class.is-disabled') bool isDisabled = false;

  @ContentChild(NgModel) NgModel ngModelInput;
  @ContentChild(FocusSource) FocusSource checkboxInput;
  @ContentChild(DisabledInput) DisabledInput disabledInput;

  @ViewChild(Ripple) Ripple ripple;

  @HostListener('mouseup')
  void onMouseUp() {
    if (checkboxInput != null) {
      Timer.run(() => checkboxInput.onBlur());
    }
  }

  @HostListener('mousedown', const ['\$event.client', '\$event.target'])
  void onMouseDown(Point client, Element target) {
    if (checkboxInput != null) {
      Timer.run(() => checkboxInput.onFocus());
    }
  }

  void ngAfterContentInit() {
    //get initial value and set listeners on the checkbox properties

    if (ngModelInput != null) {
      isChecked = ngModelInput.value;
      ngModelInput.update.listen((bool newValue) {
        isChecked = newValue;
      });
    }
    if (checkboxInput != null) {
      checkboxInput.hasFocus.listen((bool event) => isFocused = event);
    }
    if (disabledInput != null) {
      isDisabled = true;
    }
  }
}
