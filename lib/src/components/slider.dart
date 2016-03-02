import 'dart:html';

import 'package:angular2/angular2.dart';

/// Slider Directive
///     usage: make an `<input type="range">` tag with classes 'mdl-slider' and
///     'mdl-js-slider' with tag attributes max, min, value, and step.
///
///     min, max, value, and step may be dynamic inputs and can be numbers or
///     strings that parse to numbers.
///
///     use FORM_DIRECTIVES and Slider as directives in enclosing components.
///
///     use e.g., `[(ngModel)]="someVariable"` to operate on the value.
///
///       `<input class="mdl-slider mdl-js-slider" type="range" min="0"
///       max="100" [(ngModel)]="sliderValue1" tabindex="0">
///       <p>{{sliderValue1}}</p>`
///
///       `int sliderValue1 = 0;`
///

@Directive(selector: '.mdl-js-slider')
class Slider implements OnInit, AfterContentInit {
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

  ElementRef _ref;
  Renderer _renderer;

  Element backgroundLower;
  Element backgroundUpper;

  Slider(this._ref, this._renderer);

  void ngOnInit() {
    // we do this here instead of a template because we have to enclose
    // the host input element in another element
    InputElement hostElement = _ref.nativeElement;
    Element parent = hostElement.parent;
    Element container = _renderer.createElement(parent, 'div');
    _renderer.setElementClass(container, 'mdl-slider__container', true);
    parent.insertBefore(container, hostElement);
    container.append(hostElement);
    Element backgroundFlex = _renderer.createElement(container, 'div');
    _renderer.setElementClass(
        backgroundFlex, 'mdl-slider__background-flex', true);
    backgroundLower = _renderer.createElement(container, 'div');
    _renderer.setElementClass(
        backgroundLower, 'mdl-slider__background-lower', true);
    backgroundUpper = _renderer.createElement(container, 'div');
    _renderer.setElementClass(
        backgroundUpper, 'mdl-slider__background-upper', true);
    backgroundFlex.append(backgroundLower);
    backgroundFlex.append(backgroundUpper);
    container.append(backgroundFlex);
  }

  num asNumber(dynamic aValue) {
    return aValue is String ? num.parse(aValue) : aValue;
  }

  void updateValueAndStyles(dynamic inputValue) {
    value = inputValue;
    num calcValue = asNumber(inputValue);
    num calcMin = asNumber(min);
    num calcMax = asNumber(max);
    valueIsLowestValue = calcValue == calcMin;
    num fraction = (calcValue - calcMin) / (calcMax - calcMin);
    backgroundLower.style.setProperty('flex', '$fraction');
    backgroundUpper.style.setProperty('flex', '${1.0 - fraction}');
  }

  void ngAfterContentInit() {
    updateValueAndStyles(_ref.nativeElement.value);
  }
}
