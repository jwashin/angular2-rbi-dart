import 'dart:async';
import 'package:angular2/angular2.dart';
import 'ripple.dart';
import 'input_directives.dart';

class RadioNotifier {
  EventEmitter<Radio> newlyChecked = new EventEmitter();

  void newCheck(Radio radio) {
    newlyChecked.add(radio);
  }
}

RadioNotifier radioNotifier = new RadioNotifier();

@Component(
    selector: '.mdl-radio',
    template: '''
    <ng-content></ng-content>
    <span class="mdl-radio__outer-circle"></span>
    <span class="mdl-radio__inner-circle"></span>
    <span class="mdl-radio__ripple-container"></span>

    ''',
    directives: const [CenteredRippleContainer])
class Radio implements OnInit, AfterContentInit {
  @HostBinding('class.is-checked') bool isChecked;
  @HostBinding('class.is-upgraded') bool isUpgraded = true;
  @HostBinding('class.is-disabled') bool isDisabled = false;
  @HostBinding('class.is-focused') bool isFocused = false;

  @ContentChild(FocusSource) FocusSource radioInput;
  @ContentChild(DisabledInput) DisabledInput disabledInput;
  @ContentChild(NgModel) NgModel ngModelInput;

  @HostListener('mouseup')
  void onMouseUp() {
    if (radioInput != null) {
      Timer.run(() => radioInput.onBlur());
    }
  }

  RadioNotifier checkedNotifier = radioNotifier;
  String name;

  void ngOnInit() {
    checkedNotifier.newlyChecked.listen((Radio radio) {
      if (radio.name == name && radio != this) {
        isChecked = false;
      }
    });
  }

  void ngAfterContentInit() {
    //set listeners on the radio properties

    if (radioInput != null) {
      radioInput.hasFocus.listen((bool event) => isFocused = event);
    }
    if (ngModelInput != null) {
      isChecked = ngModelInput.value.checked;
      name = ngModelInput.name;
      ngModelInput.update.listen((RadioButtonState newValue) {
        isChecked = newValue.checked;
        checkedNotifier.newCheck(this);
      });
    }
    if (disabledInput != null) {
      isDisabled = true;
    }
  }
}
