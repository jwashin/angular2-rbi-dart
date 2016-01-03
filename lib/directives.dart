/// directives for the standard directives

library angular2_rbi_directives;

import 'package:angular2/angular2.dart';
import 'src/directives/material_button.dart' show ButtonBehavior;
import 'src/directives/material_checkbox.dart' show CheckboxBehavior;
import 'src/directives/material_data_table.dart'
    show DataTableBehavior;
import 'src/directives/material_icon_toggle.dart'
    show IconToggleBehavior;
import 'src/directives/material_layout.dart' show LayoutBehavior;
import 'src/directives/material_menu.dart' show MenuBehavior;
import 'src/directives/material_progress.dart' show ProgressBehavior;
import 'src/directives/material_radio.dart' show RadioBehavior;
import 'src/directives/material_tabs.dart' show TabsBehavior;
import 'src/directives/material_ripple.dart' show RippleBehavior;
import 'src/directives/material_slider.dart' show SliderBehavior;
import 'src/directives/material_spinner.dart' show SpinnerBehavior;
import 'src/directives/material_switch.dart' show SwitchBehavior;
import 'src/directives/material_textfield.dart'
    show TextfieldBehavior;
import 'src/directives/material_tooltip.dart' show TooltipBehavior;
import 'src/directives/material_snackbar.dart' show SnackbarBehavior;

@Directive(selector: '.mdl-js-button')
class MaterialButton extends ButtonBehavior {
  MaterialButton(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-checkbox')
class MaterialCheckbox extends CheckboxBehavior {
  MaterialCheckbox(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-data-table')
class MaterialDataTable extends DataTableBehavior {
  MaterialDataTable(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-icon-toggle')
class MaterialIconToggle extends IconToggleBehavior {
  MaterialIconToggle(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-layout')
class MaterialLayout extends LayoutBehavior {
  MaterialLayout(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-menu')
class MaterialMenu extends MenuBehavior {
  MaterialMenu(ElementRef ref) : super(ref.nativeElement);
}

@Directive(
    selector: '.mdl-js-progress', inputs: const ['progress', 'buffer'])
class MaterialProgress extends ProgressBehavior {
  MaterialProgress(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-radio')
class MaterialRadio extends RadioBehavior {
  MaterialRadio(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: 'mdl-js-ripple-effect')
class MaterialRipple extends RippleBehavior {
  MaterialRipple(ElementRef ref) : super(ref.nativeElement);
}

@Directive(
    selector: '.mdl-js-slider',
    inputs: const ['min', 'max', 'value', 'step'])
class MaterialSlider extends SliderBehavior {
  MaterialSlider(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-spinner')
class MaterialSpinner extends SpinnerBehavior {
  MaterialSpinner(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-switch')
class MaterialSwitch extends SwitchBehavior {
  MaterialSwitch(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-tabs')
class MaterialTabs extends TabsBehavior {
  MaterialTabs(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-textfield')
class MaterialTextfield extends TextfieldBehavior {
  MaterialTextfield(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-tooltip')
class MaterialTooltip extends TooltipBehavior {
  MaterialTooltip(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-snackbar')
class MaterialSnackbar extends SnackbarBehavior {
  MaterialSnackbar(ElementRef ref) : super(ref.nativeElement);
}
