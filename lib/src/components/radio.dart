import 'dart:async';
import 'package:angular2/angular2.dart';
import 'ripple.dart';
import 'input_directives.dart';

class RadioNotifier {
  EventEmitter<Radio> newlyChecked = new EventEmitter<Radio>();

  void newCheck(Radio radio) {
    newlyChecked.add(radio);
  }
}

RadioNotifier radioNotifier = new RadioNotifier();

@Component(
    selector: '.mdl-js-radio',
    template: '<ng-content></ng-content>'
        '<span class="mdl-radio__outer-circle"></span>'
        '<span class="mdl-radio__inner-circle"></span>'
        '<span *ngIf="shouldRipple" class="mdl-radio__ripple-container" '
        '></span>',
    directives: const [NgIf, Ripple])
class Radio implements OnInit, AfterContentInit, OnDestroy {
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

  @ViewChild(Ripple)
  Ripple ripple;

  @ContentChild(InputSource)
  InputSource radioInput;
  @ContentChild(NgModel)
  NgModel ngModelInput;

  String name;

  List<StreamSubscription<dynamic>> subscriptions = [];

  @HostListener('mousedown')
  void onMouseDown() {
    if (radioInput != null && !isDisabled) {
      ripple?.startRipple(ripple.ref.nativeElement.getBoundingClientRect());
    }
  }

  @HostListener('mouseup')
  void onMouseUp() {
    if (radioInput != null) {
      Timer.run(() => radioInput.onBlur());
    }
//    ripple?.endRipple();
  }

  RadioNotifier checkedNotifier = radioNotifier;

  void ngOnInit() {
    subscriptions.add(checkedNotifier.newlyChecked.listen((Radio radio) {
      if (radio.name == name && radio != this) {
        isChecked = false;
      }
    }));
  }

  void ngAfterContentInit() {
    //set listeners on the radio properties
    if (radioInput != null) {
      subscriptions
          .add(radioInput.hasFocus.listen((bool event) => isFocused = event));
      name = radioInput.name;
    } else {
      Timer.run(() => isDisabled = true);
    }

    if (ngModelInput != null) {
      Timer.run(() => isChecked = ngModelInput.value.checked);
      subscriptions.add(ngModelInput.update.listen((RadioButtonState newValue) {
        isChecked = newValue.checked;
        checkedNotifier.newCheck(this);
      }));
    }
  }

  void ngOnDestroy() {
    for (StreamSubscription<dynamic> subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
  }
}
