library component_icon_toggle;

import 'dart:async';
import 'package:angular2/angular2.dart';
import 'input_directives.dart';
import 'ripple.dart';

@Component(
    selector: '.mdl-icon-toggle',
    template: '''
<ng-content></ng-content>
<span class="mdl-icon-toggle__ripple-container"></span>
''',
    directives: const [NgIf, CenteredRippleContainer])
class IconToggle implements AfterContentInit {
  @Input('class') String hostClasses;
  @HostBinding('class.is-checked') bool isChecked;
  @HostBinding('class.is-upgraded') bool isUpgraded = true;
  @HostBinding('class.is-focused') bool isFocused = false;
  @ContentChild(NgModel) NgModel ngModelInput;
  @ContentChild(FocusSource) FocusSource checkboxInput;

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
  }
}
