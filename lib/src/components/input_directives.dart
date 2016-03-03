import 'package:angular2/angular2.dart';

@Directive(selector: 'input[disabled], textarea[disabled]')
class DisabledInput {
  @HostBinding('class.is-disabled') bool isDisabled = true;
}

/// Input focus manager. We just need to know the focused state of
/// the input element for the MDL visuals.
@Directive(
    selector: "input:not([disabled]), textarea:not([disabled])")
class FocusSource {
  @Output() EventEmitter<bool> hasFocus = new EventEmitter();

  @HostListener('focus')
  void onFocus() => hasFocus.add(true);

  @HostListener('blur')
  void onBlur() => hasFocus.add(false);
}
//
//
//@Directive(selector:'textarea.mdl-textfield')
//class TextAreaField{
//}
//
//@Directive(selector:'input[type=text].mdl-textfield')
//class TextInputField{
//  @Input() int maxrows;
//}
