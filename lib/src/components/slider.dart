import 'dart:async';

import 'package:angular2/angular2.dart';

/// Slider Directive
///     usage: make an `<input type="range">` tag with classes
///     'mdl-slider' (to get MDL styles)
///     and 'mdl-js-slider' (to get this behavior)
///
///     the <input type="range"> tag uses attributes max, min, value, and step.
///
///     min, max, value, and step may be dynamic inputs and can be numbers or
///     strings that parse to numbers.
///
///     use `FORM_DIRECTIVES` and `slider` as directives in enclosing components.
///
///     use e.g., `[(ngModel)]="someVariable"` to use/operate on the value.
///
///       `<input class="mdl-slider mdl-js-slider" type="range" min="0"
///       max="100" [(ngModel)]="sliderValue1" tabindex="0">
///       <p>{{sliderValue1}}</p>`
///
///       `int sliderValue1 = 0;`
///

@Component(
    selector: 'rbi-slider',
    template: ''
        '<div class="mdl-slider__container">'
        '  <ng-content></ng-content>'
        '  <div class="mdl-slider__background-flex">'
        '    <div [style.flex]="lowerFlex" '
        '    class="mdl-slider__background-lower"></div>'
        '    <div [style.flex]="upperFlex"'
        '     class="mdl-slider__background-upper"></div>'
        '  </div>'
        '</div>'
)
class Slider implements AfterContentInit, OnDestroy {
  @ContentChild(SliderElement)
  SliderElement sliderElement;
  @ContentChild(NgModel)
  NgModel ngModelInput;

  num max = 0;
  num min = 100;
  num value = 0;

  String upperFlex = '';
  String lowerFlex = '';

  List<StreamSubscription<dynamic>> subscriptions = [];

  void ngAfterContentInit() {
    if (sliderElement != null) {
      min = asNumber(sliderElement.min);
      max = asNumber(sliderElement.max);
    }

    if (ngModelInput != null) {
      // display the initial value without getting
      // *changed after checked* notice
      Timer.run(() {
        value = asNumber(ngModelInput.value);
        setSliderValues();
      });
      subscriptions.add(ngModelInput.update.listen((dynamic newValue) {
        value = asNumber(newValue);
        setSliderValues();
      }));
    }
  }

  void setSliderValues() {
    num fraction = (value - min) / (max - min);
    lowerFlex = '$fraction';
    upperFlex = '${1.0 - fraction}';
  }

  void ngOnDestroy() {
    for (StreamSubscription<dynamic> subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
  }
}

num asNumber(dynamic aValue) {
  return aValue is String ? num.parse(aValue) : aValue;
}

@Directive(selector: 'input.mdl-js-slider')
class SliderElement {
  @Input()
  dynamic min = 0;
  @Input()
  dynamic max = 100;
  @Input()
  dynamic value = 0;
  @Input()
  dynamic disabled = false;

  @HostBinding('class.is-upgraded')
  bool isUpgraded = true;
  @HostBinding('class.is-lowest-value')
  bool valueIsLowestValue = false;

  bool get isDisabled => disabled == '' ? true : disabled;

  @HostListener('change', const ['\$event.target.value'])
  void onChange(dynamic value) => updateValueAndStyles(value);

  @HostListener('input', const ['\$event.target.value'])
  void onInput(dynamic value) => updateValueAndStyles(value);

  @HostListener('mouseup', const ['\$event.target'])
  void onMouseUp(dynamic target) => target.blur();

  void updateValueAndStyles(dynamic inputValue) {
    value = inputValue;
    num calcValue = asNumber(inputValue);
    num calcMin = asNumber(min);
    valueIsLowestValue = calcValue == calcMin;
  }
}

const List<Type> slider = const [Slider, SliderElement];
