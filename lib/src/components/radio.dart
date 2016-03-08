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
    <span class="mdl-radio__ripple-container" [centered]="true"></span>
    ''',
    directives: const [Ripple])
class Radio implements OnInit, AfterContentInit, OnDestroy {
  @HostBinding('class.is-checked') bool isChecked = false;
  @HostBinding('class.is-upgraded') bool isUpgraded = true;
  @HostBinding('class.is-disabled') bool isDisabled = false;
  @HostBinding('class.is-focused') bool isFocused = false;

  @ContentChild(FocusSource) FocusSource radioInput;
  @ContentChildren(DisabledInput) QueryList<DisabledInput> disabledInput;
  @ContentChild(NgModel) NgModel ngModelInput;

  List<StreamSubscription> subscriptions = [];

  @HostListener('mouseup')
  void onMouseUp() {
    if (radioInput != null) {
      Timer.run(() => radioInput.onBlur());
    }
  }

  RadioNotifier checkedNotifier = radioNotifier;
  String name = '';

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
      subscriptions
          .add(radioInput.hasFocus.listen((bool event) => isFocused = event));
    }
    if (ngModelInput != null) {
      Timer.run(() => isChecked = ngModelInput.value.checked);
      name = ngModelInput.name;
      subscriptions.add(ngModelInput.update.listen((RadioButtonState newValue) {
        isChecked = newValue.checked;
        checkedNotifier.newCheck(this);
      }));
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
