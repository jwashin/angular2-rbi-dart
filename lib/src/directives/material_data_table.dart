library material_data_table;

import 'dart:html';
import 'material_checkbox.dart' show CheckboxBehavior;

const String DATA_TABLE = 'mdl-data-table';
const String SELECTABLE = 'mdl-data-table--selectable';
const String IS_SELECTED = 'is-selected';
const String IS_UPGRADED = 'is-upgraded';
const String CHECKBOX = 'mdl-checkbox';

const String JS_CHECKBOX = 'mdl-js-checkbox';
const String RIPPLE_EFFECT = 'mdl-js-ripple-effect';
const String DATA_TABLE_SELECT = 'mdl-data-table__select';
const String CHECKBOX_INPUT = 'mdl-checkbox__input';

class DataTableBehavior {
  Element element;
  Map<CheckboxInputElement, Function> changeListeners = {};

  DataTableBehavior(this.element);
  void init() {
    Element firstHeader = element.querySelector('th');
    List<Element> rows = element.querySelectorAll('tbody tr');
    List<Element> footRows = element.querySelectorAll('tfoot tr');
    rows.addAll(footRows);
    if (element.classes.contains(SELECTABLE)) {
      TableCellElement th = new TableCellElement();
      Element headerCheckbox = createCheckbox(null, rows);
      th.append(headerCheckbox);
      firstHeader.parent.insertBefore(th, firstHeader);

      for (Element row in rows) {
        Element firstCell = row.querySelector('td');
        if (firstCell != null) {
          TableCellElement td = new TableCellElement();
          if (row.parent.nodeName.toUpperCase() == 'TBODY') {
            Element rowCheckbox = createCheckbox(row, null);
            td.append(rowCheckbox);
          }
          row.insertBefore(td, firstCell);
        }
      }
    }
    element.classes.add(IS_UPGRADED);
  }

  void destroy() {
    if (element.classes.contains(SELECTABLE)) {
      List<Element> checkboxLabels =
      element.querySelectorAll('label[$DATA_TABLE_SELECT]');
      for (LabelElement label in checkboxLabels) {
        CheckboxBehavior cb = new CheckboxBehavior(label);
        cb.destroy();
      }
      for (CheckboxInputElement checkbox in changeListeners.keys) {
        checkbox.removeEventListener('change', changeListeners[checkbox]);
      }
      changeListeners.clear();
    }
  }

  Function selectRow(
      CheckboxInputElement checkbox, Element row, List<Element> optRows) {
    if (row != null) {
      return ((Event event) {
        if (checkbox.checked) {
          row.classes.add(IS_SELECTED);
        } else {
          row.classes.remove(IS_SELECTED);
        }
      });
    } else {
      return ((Event event) {
        if (checkbox.checked) {
          for (Element row in optRows) {
            CheckboxInputElement el =
                row.querySelector('td .' + CHECKBOX_INPUT);
            el.checked = true;
            el.dispatchEvent(new Event('change'));
            row.classes.add(IS_SELECTED);
          }
        } else {
          for (Element row in optRows) {
            CheckboxInputElement el =
                row.querySelector('td .' + CHECKBOX_INPUT);
            el.checked = false;
            el.dispatchEvent(new Event('change'));
            row.classes.remove(IS_SELECTED);
          }
        }
      });
    }
  }

  LabelElement createCheckbox(Element row, List<Element> optRows) {
    Function fn;
    LabelElement label = new LabelElement()
      ..classes
          .addAll([CHECKBOX, JS_CHECKBOX, RIPPLE_EFFECT, DATA_TABLE_SELECT]);
    CheckboxInputElement checkbox = new CheckboxInputElement()
      ..classes.add(CHECKBOX_INPUT);
    if (row != null) {
      checkbox.checked = row.classes.contains(IS_SELECTED);
      fn = selectRow(checkbox, row, null);
      changeListeners[checkbox] = fn;
      checkbox.addEventListener('change', fn);

      if (row.dataset.containsKey('mdlDataTableSelectableName')) {
        checkbox.name = row.dataset['mdlDataTableSelectableName'];
      }
      if (row.dataset.containsKey('mdlDataTableSelectableValue')) {
        checkbox.value = row.dataset['mdlDataTableSelectableValue'];
      }
    } else if (optRows != null) {
      fn = selectRow(checkbox, null, optRows);
      changeListeners[checkbox] = fn;
      checkbox.addEventListener('change', fn);
    }
    label.append(checkbox);
    CheckboxBehavior cb = new CheckboxBehavior(label);
    cb.init();
    return label;
  }
}
