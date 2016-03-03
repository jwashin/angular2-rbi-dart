import 'dart:html';
import 'dart:async';

import 'package:angular2/angular2.dart';

/// Slider Directive
///     usage: make an `<input type="range">` tag with class 'mdl-slider'
///     and tag attributes max, min, value, and step.
///
///     min, max, value, and step may be dynamic inputs and can be numbers or
///     strings that parse to numbers.
///
///     use FORM_DIRECTIVES and Slider as directives in enclosing components.
///
///     use e.g., `[(ngModel)]="someVariable"` to operate on the value.
///
///       `<input class="mdl-slider" type="range" min="0"
///       max="100" [(ngModel)]="sliderValue1" tabindex="0">
///       <p>{{sliderValue1}}</p>`
///
///       `int sliderValue1 = 0;`
///

num asNumber(dynamic aValue) {
  return aValue is String ? num.parse(aValue) : aValue;
}

@Directive(selector: '.mdl-slider')
class SliderElement implements OnChanges {
  @Input() dynamic min = 0;
  @Input() dynamic max = 100;
  @Input() dynamic value = 0;

  @HostBinding('class.is-upgraded') bool isUpgraded = true;
  @HostBinding('class.is-lowest-value') bool valueIsLowestValue = false;

  @HostListener('change', const ['\$event.target.value'])
  void onChange(dynamic value) => updateValueAndStyles(value);

  @HostListener('input', const ['\$event.target.value'])
  void onInput(dynamic value) => updateValueAndStyles(value);

  @HostListener('mouseup', const ['\$event.target'])
  void onMouseUp(InputElement target) => target.blur();

//  @Output() EventEmitter<num> newValue = new EventEmitter();

  void ngOnChanges(Map<String, SimpleChange> changes) {
    print('changes: ${changes.keys}');
//    print ('new value: ${changes['value'].currentValue}');
    Timer.run(() => updateValueAndStyles(value));
  }

  void updateValueAndStyles(dynamic inputValue) {
    value = inputValue;
    num calcValue = asNumber(inputValue);
    num calcMin = asNumber(min);
    valueIsLowestValue = calcValue == calcMin;
  }
}

@Component(
    selector: '.mdl-slider__container', template: '<ng-content></ng-content>')
class Slider implements AfterContentInit {
  @ContentChild(SliderElement) SliderElement sliderElement;
  @ContentChild(SliderBackgroundLower) SliderBackgroundLower backgroundLower;
  @ContentChild(SliderBackgroundUpper) SliderBackgroundUpper backgroundUpper;
  @ContentChild(NgModel) NgModel ngModelInput;

  num max;
  num min;
  num value;

  void ngAfterContentInit() {
    if (sliderElement != null) {
      max = asNumber(sliderElement.max);
      min = asNumber(sliderElement.min);
      value = asNumber(sliderElement.value);
//      setSliderValues();
      print('we have slider element $min, $max, $value');
    }
    if (ngModelInput != null) {
      value = asNumber(ngModelInput.value);
      setSliderValues();
      ngModelInput.update.listen((dynamic newValue) {
        value = asNumber(newValue);
        setSliderValues();
      });
    }
  }

  void setSliderValues() {
    num fraction = (value - min) / (max - min);
    backgroundLower.flex = '$fraction';
    backgroundUpper.flex = '${1.0 - fraction}';
  }
}

@Directive(selector: '.mdl-slider__background-lower')
class SliderBackgroundLower {
  @HostBinding('style.flex') String flex = '';
}

@Directive(selector: '.mdl-slider__background-upper')
class SliderBackgroundUpper {
  @HostBinding('style.flex') String flex = '';
}
