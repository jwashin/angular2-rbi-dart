import 'package:angular2/angular2.dart';
import 'dart:html';

/// Slider Component
///     usage: make a <mdl-js-slider></mdl-js-slider> tag
///     with attributes max, min, value, and step.
///
///     min, max, value, and step may be dynamic inputs and can be numbers or
///     strings that parse to numbers.
///
///     value is available as an output.
///
///     include 'Slider' in your component's directives.

@Component(
    selector: 'mdl-js-slider',
    template: '''
    <div class="mdl-slider__container">
    <input class="mdl-slider is-upgraded"
    [class.is-lowest-value]="value.toString()==min.toString()"
    (input)="onChange(\$event.target)"
    (change)="onChange(\$event.target)"
    tabindex="0"
    (mouseup)="\$event.target.blur()"
    [max]="max" [min]="min" tabindex="0" type="range" [value]="value">
    <div class="mdl-slider__background-flex">
    <div class="mdl-slider__background-lower" [style.flex]="lowerFlex">
    </div>
    <div class="mdl-slider__background-upper" [style.flex]="upperFlex">
    </div>
    </div>
    </div>

    ''')
class Slider implements OnInit {
  @Input() dynamic min = 0;
  @Input() dynamic max = 100;
  @Input() dynamic value = 0;
  @Input() dynamic step = 1;

  @Output() EventEmitter valueChange = new EventEmitter();

  String lowerFlex = '';
  String upperFlex = '';

  void onChange(InputElement target) {
    dynamic newValue = (value is num && target.value is String)
        ? num.parse(target.value)
        : target.value;
    valueChange.add(newValue);
    updateValueStyles();
  }

  void updateValueStyles() {
    num calcValue, calcMin, calcMax;
    calcValue = (value is String) ? num.parse(value) : value;
    calcMin = (min is String) ? num.parse(min) : min;
    calcMax = (max is String) ? num.parse(max) : max;

    num fraction = (calcValue - calcMin) / (calcMax - calcMin);
    lowerFlex = '$fraction';
    upperFlex = '${1.0 - fraction}';
  }

  void ngOnInit() {
    updateValueStyles();
  }
}
