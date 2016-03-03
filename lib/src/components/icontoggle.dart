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
class IconToggle implements AfterContentInit, OnDestroy {
  @Input('class') String hostClasses;
  @HostBinding('class.is-checked') bool isChecked;
  @HostBinding('class.is-upgraded') bool isUpgraded = true;
  @HostBinding('class.is-focused') bool isFocused = false;
  @ContentChild(NgModel) NgModel ngModelInput;
  @ContentChild(FocusSource) FocusSource checkboxInput;

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
      isChecked = ngModelInput.value;
      subscriptions.add(
          ngModelInput.update.listen((bool newValue) => isChecked = newValue));
    }
  }

  void ngOnDestroy() {
    for (StreamSubscription subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
  }
}
