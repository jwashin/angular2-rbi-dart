import 'package:angular2/angular2.dart';

@Directive(selector: 'input[disabled]')
class DisabledInput {
  @HostBinding('class.is-disabled') bool isDisabled = true;
}

/// CheckboxInput. We just need to know the focused state of
/// the input element for the MDL visuals.
@Directive(
    selector: "input:not([disabled])")
class FocusSource {
  @Output() EventEmitter<bool> hasFocus = new EventEmitter();

  @HostListener('focus')
  void onFocus() => hasFocus.add(true);

  @HostListener('blur')
  void onBlur() => hasFocus.add(false);
}
