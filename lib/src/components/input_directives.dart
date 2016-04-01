import 'package:angular2/angular2.dart';

/// Input element. We need to know the focused state of the element for the
/// MDL visuals. This is also where we get the name for Radio controls.
/// Cleverly, we also know disabled if an input is not found where expected.
@Directive(selector: "input:not([disabled]), textarea:not([disabled])")
class InputSource {
  @Output()
  EventEmitter<bool> hasFocus = new EventEmitter<bool>();
  @Input()
  String name;

  @HostListener('focus')
  void onFocus() {
    hasFocus.add(true);
  }

  @HostListener('blur')
  void onBlur() {
    hasFocus.add(false);
  }
}
