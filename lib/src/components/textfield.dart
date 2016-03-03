import 'package:angular2/angular2.dart';
import 'input_directives.dart';

/// Textfield Directive
///     usage: make an `<input type="text">` tag with class 'mdl-textfield'
///
///     use FORM_DIRECTIVES and Textfield as directives in enclosing components.
///
///     use e.g., `[(ngModel)]="someVariable"` to operate on the value.
///
///     '<div class="mdl-textfield">
///        <input class="mdl-textfield__input"
///        [(ngModel)]="someVariable"
///        type="text" id="sample1">
///        <label class="mdl-textfield__label" for="sample1">Text...</label>
///      </div>'
///

@Component(selector: '.mdl-textfield', template: '<ng-content></ng-content>')
class Textfield implements AfterContentInit {
  int maxRows;

  @HostBinding('class.is-upgraded') bool isUpgraded = true;
  @HostBinding('class.is-disabled') bool isDisabled = false;
  @HostBinding('class.is-focused') bool isFocused = false;
  @HostBinding('class.is-dirty') bool isDirty = false;
  @HostBinding('class.is-invalid') bool isInvalid = false;

  @ContentChild(FocusSource) FocusSource textInput;
  @ContentChildren(DisabledInput) QueryList<DisabledInput> disabledInput;
  @ContentChild(NgModel) NgModel ngModelInput;

  void ngAfterContentInit() {
    if (textInput != null) {
      textInput.hasFocus.listen((bool event) => isFocused = event);
    }
    if (ngModelInput != null) {
      ngModelInput.update.listen((_) {
        isDirty = ngModelInput.dirty;
        isInvalid = !ngModelInput.valid;
      });
    }
    if (disabledInput.isNotEmpty) {
      isDisabled = true;
    }
    disabledInput.changes.listen((_) {
      if (disabledInput.isNotEmpty) {
        isDisabled = true;
      }
    });
  }
}