library material_textfield;

import 'dart:html';
import 'dart:async';

const int NO_MAX_ROWS = -1;
const String MAX_ROWS_ATTRIBUTE = 'maxrows';

const String LABEL = 'mdl-textfield__label';
const String TEXTFIELD_INPUT = 'mdl-textfield__input';
const String IS_DIRTY = 'is-dirty';
const String IS_FOCUSED = 'is-focused';
const String IS_DISABLED = 'is-disabled';
const String IS_INVALID = 'is-invalid';
const String IS_UPGRADED = 'is-upgraded';

class TextfieldBehavior {
  Element element;
  int maxRows = NO_MAX_ROWS;
  Element input;

  TextfieldBehavior(this.element);
  void init() {
    input = element.querySelector('.' + TEXTFIELD_INPUT);
    if (input != null) {
      if (input.attributes.containsKey(MAX_ROWS_ATTRIBUTE)) {
        try {
          maxRows = int.parse(input.getAttribute(MAX_ROWS_ATTRIBUTE));
        } catch (e) {
          maxRows = NO_MAX_ROWS;
        }
      }
      input.addEventListener('input', onInput);
      input.addEventListener('focus', onFocus);
      input.addEventListener('blur', onBlur);
      input.addEventListener('reset', onReset);

      if (maxRows != NO_MAX_ROWS) {
        input.addEventListener('keydown', onKeyDown);
      }

      //wait a click for angular2 to init the value
      Timer.run(() {
        updateClasses();
        element.classes.add(IS_UPGRADED);
      });
    }
  }

  void destroy() {
    input.removeEventListener('input', onInput);
    input.removeEventListener('focus', onFocus);
    input.removeEventListener('blur', onBlur);
    input.removeEventListener('reset', onReset);
    if (maxRows != NO_MAX_ROWS) {
      input.removeEventListener('keydown', onKeyDown);
    }
  }

  void onKeyDown(KeyboardEvent event) {
    InputElement target = event.target;
    int currentRowCount = target.value.split('\n').length;
    if (event.keyCode == 13) {
      if (currentRowCount >= maxRows) {
        event.preventDefault();
      }
    }
  }

  void onInput(Event event) {
    updateClasses();
  }

  void onFocus(Event event) {
    element.classes.add(IS_FOCUSED);
  }

  void onBlur(Event event) {
    element.classes.remove(IS_FOCUSED);
  }

  void onReset(Event event) {
    updateClasses();
  }

  void updateClasses() {
    checkDisabled();
    checkValidity();
    checkDirty();
  }

  void checkDisabled() {
    bool disabled = false;
    if (input is TextInputElement) {
      TextInputElement test = input;
      disabled = test.disabled;
    } else if (input is TextAreaElement) {
      TextAreaElement test = input;
      disabled = test.disabled;
    }
    if (disabled) {
      element.classes.add(IS_DISABLED);
    } else {
      element.classes.remove(IS_DISABLED);
    }
  }

  void checkValidity() {
    ValidityState validity;
    if (input is TextInputElement) {
      TextInputElement test = input;
      validity = test.validity;
    } else if (input is TextAreaElement) {
      TextAreaElement test = input;
      validity = test.validity;
    }
    if (validity.valid && !input.classes.contains('ng-invalid')) {
      element.classes.remove(IS_INVALID);
    } else {
      element.classes.add(IS_INVALID);
    }
  }

  void checkDirty() {
    String value;
    if (input is TextInputElement) {
      TextInputElement test = input;
      value = test.value;
    } else if (input is TextAreaElement) {
      TextAreaElement test = input;
      value = test.value;
    }
    if (value != null && value.length > 0) {
      element.classes.add(IS_DIRTY);
    } else {
      element.classes.remove(IS_DIRTY);
    }
  }

  void disable() {
    if (input is TextInputElement) {
      TextInputElement test = input;
      test.disabled = true;
    } else if (input is TextAreaElement) {
      TextAreaElement test = input;
      test.disabled = true;
    }
  }

  void enable() {
    if (input is TextInputElement) {
      TextInputElement test = input;
      test.disabled = false;
    } else if (input is TextAreaElement) {
      TextAreaElement test = input;
      test.disabled = false;
    }
  }

  void change(String value) {
    if (value != null && value is String) {
      if (input is TextInputElement) {
        TextInputElement test = input;
        test.value = value;
      } else if (input is TextAreaElement) {
        TextAreaElement test = input;
        test.value = value;
      }
    }
    updateClasses();
  }
}
