library component_checkbox;

import 'dart:html';
import 'dart:async';

import 'package:angular2/angular2.dart';

import 'ripple.dart';

@Component(
    selector: '.mdl-js-checkbox',
    template: '''
<ng-content></ng-content>
<span class="mdl-checkbox__focus-helper"></span>
<span class="mdl-checkbox__box-outline">
  <span class="mdl-checkbox__tick-outline"></span>
</span>
<span *ngIf="shouldRipple" (mouseup)="onMouseUp()"
class="mdl-checkbox__ripple-container"
(mousedown)="onMouseDown(\$event)">
<span class="mdl-ripple"></span>
</span>
''',
    directives: const [CORE_DIRECTIVES, Ripple])
class Checkbox implements AfterContentInit {
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

/// Checkbox. checked and disabled properties may not necessarily be in sync
/// with DOM.
@Directive(
    selector: "input[type=checkbox].mdl-checkbox__input,"
        "input[type=checkbox].mdl-switch__input,"
        "input[type=checkbox].mdl-icon-toggle__input")
class CheckboxInput implements OnChanges {
  @Input() bool checked;
  @Input() bool disabled;

  @Output() EventEmitter<bool> checkedChanged = new EventEmitter();
  @Output() EventEmitter<bool> disabledChanged = new EventEmitter();
  @Output() EventEmitter<bool> focusChanged = new EventEmitter();

  @HostListener('change', const ['\$event.target'])
  void onChange(InputElement element) {
    if (disabled) return;
    checked = !checked;
    checkedChanged.add(checked);
    Timer.run(() => element.blur());
  }

  @HostListener('click', const ['\$event'])
  void onClick(Event event) {
    if (disabled) event.preventDefault();
  }

  @HostListener('focus')
  void onFocus() {
    if (disabled) return;
    focusChanged.add(true);
  }

  @HostListener('blur')
  void onBlur() {
    if (disabled) return;
    focusChanged.add(false);
  }

  void ngOnChanges(Map<String, SimpleChange> changeRecord) {
    // if the new value is a String, we have a property, so true
    if (changeRecord.containsKey('checked')) {
      dynamic t = changeRecord['checked'].currentValue;
      checked = t is String ? true : t;
      checkedChanged.add(t);
    }
    if (changeRecord.containsKey('disabled')) {
      dynamic t = changeRecord['disabled'].currentValue;
      disabled = t is String ? true : t;
      disabledChanged.add(t);
    }
  }
}
