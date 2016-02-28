library component_switch;

import 'dart:html';
import 'package:angular2/angular2.dart';
import 'checkbox.dart';
import 'ripple.dart';

@Component(
    selector: '.mdl-js-switch',
    template: '''
<ng-content></ng-content>
<span class="mdl-switch__label"></span>
<div class="mdl-switch__track"></div>
<div class="mdl-switch__thumb">
  <span class="mdl-switch__focus-helper"></span>
</div>
<span *ngIf="shouldRipple" (mouseup)="onMouseUp()"
class="mdl-switch__ripple-container mdl-ripple--center"
(mousedown)="onMouseDown(\$event)">
<span class="mdl-ripple"></span>
</span>
''',
    directives: const [CORE_DIRECTIVES, Ripple])
class Switch implements AfterContentInit {
  @Input('class') String hostClasses;
  @HostBinding('class.is-checked') bool isChecked;
  @HostBinding('class.is-disabled') bool isDisabled;
  @HostBinding('class.is-upgraded') bool isUpgraded = true;
  @HostBinding('class.is-focused') bool isFocused = false;

  @ContentChild(CheckboxInput) CheckboxInput checkboxInput;
  @ViewChild(Ripple) Ripple ripple;

  @HostListener('mouseup')
  void onMouseUp() {
    isFocused = false;
    if (ripple == null) return;
    ripple.visible = false;
    ripple.animating = false;
  }

  void onMouseDown(MouseEvent event) {
    if (ripple == null) return;
    ripple.doRipple(event.client.x, event.client.y, event.target, true);
  }

  bool get shouldRipple =>
      hostClasses.contains('mdl-js-ripple-effect') &&
          !hostClasses.contains('mdl-js-ripple-effect--ignore-events');

  void ngAfterContentInit() {
    //set listeners on the checkbox properties
    if (checkboxInput == null) return;
    isChecked = checkboxInput.checked;
    isDisabled = checkboxInput.disabled;
    checkboxInput.checkedChanged.listen((bool event) => isChecked = event);
    checkboxInput.disabledChanged.listen((bool event) => isDisabled = event);
    checkboxInput.focusChanged.listen((bool event) => isFocused = event);
  }
}
