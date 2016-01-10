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

  TextfieldBehavior(Element this.element);
  init(){
    //Element label = element.querySelector('.' + LABEL);
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
      Timer.run((){
        updateClasses();
      element.classes.add(IS_UPGRADED);
      }
      );
    }
  }

  onKeyDown(KeyboardEvent event) {
    InputElement target = event.target;
    int currentRowCount = target.value.split('\n').length;
    if (event.keyCode == 13) {
      if (currentRowCount >= maxRows) {
        event.preventDefault();
      }
    }
  }

  onInput(Event event) {
    updateClasses();
  }

  onFocus(Event event) {
    element.classes.add(IS_FOCUSED);
  }

  onBlur(Event event) {
    element.classes.remove(IS_FOCUSED);
  }

  onReset(Event event) {
    updateClasses();
  }

  updateClasses() {
    checkDisabled();
    checkValidity();
    checkDirty();
  }

  checkDisabled() {
    bool disabled;
    if (input is TextInputElement) {
      TextInputElement test = input as TextInputElement;
      disabled = test.disabled;
    } else if (input is TextAreaElement) {
      TextAreaElement test = input as TextAreaElement;
      disabled = test.disabled;
    }
    if (disabled == true) {
      element.classes.add(IS_DISABLED);
    } else {
      element.classes.remove(IS_DISABLED);
    }
  }

  checkValidity() {
    ValidityState validity;
    if (input is TextInputElement) {
      TextInputElement test = input as TextInputElement;
      validity = test.validity;
    } else if (input is TextAreaElement) {
      TextAreaElement test = input as TextAreaElement;
      validity = test.validity;
    }

    if (validity.valid) {
      element.classes.remove(IS_INVALID);
    } else {
      element.classes.add(IS_INVALID);
    }
  }

  checkDirty() {
    String value;
    if (input is TextInputElement) {
      TextInputElement test = input as TextInputElement;
      value = test.value;
    } else if (input is TextAreaElement) {
      TextAreaElement test = input as TextAreaElement;
      value = test.value;
    }
    if (value != null && value.length > 0) {
      element.classes.add(IS_DIRTY);
    } else {
      element.classes.remove(IS_DIRTY);
    }
  }

  disable() {
    if (input is TextInputElement) {
      TextInputElement test = input as TextInputElement;
      test.disabled = true;
    } else if (input is TextAreaElement) {
      TextAreaElement test = input as TextAreaElement;
      test.disabled = true;
    }
  }

  enable() {
    if (input is TextInputElement) {
      TextInputElement test = input as TextInputElement;
      test.disabled = false;
    } else if (input is TextAreaElement) {
      TextAreaElement test = input as TextAreaElement;
      test.disabled = false;
    }
  }

  change(value) {
    if (value != null && value is String) {
      if (input is TextInputElement) {
        TextInputElement test = input as TextInputElement;
        test.value = value;
      } else if (input is TextAreaElement) {
        TextAreaElement test = input as TextAreaElement;
        test.value = value;
      }
    }
    updateClasses();
  }
}
