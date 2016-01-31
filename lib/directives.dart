/// directives for the standard directives

library angular2_rbi_directives;

import 'package:angular2/angular2.dart';
import 'src/directives/material_button.dart' show ButtonBehavior;
import 'src/directives/material_checkbox.dart' show CheckboxBehavior;
import 'src/directives/material_data_table.dart' show DataTableBehavior;
import 'src/directives/material_icon_toggle.dart' show IconToggleBehavior;
import 'src/directives/material_layout.dart' show LayoutBehavior;
import 'src/directives/material_menu.dart' show MenuBehavior;
import 'src/directives/material_progress.dart' show ProgressBehavior;
import 'src/directives/material_radio.dart' show RadioBehavior;
import 'src/directives/material_tabs.dart' show TabsBehavior;
import 'src/directives/material_ripple.dart' show RippleBehavior;
import 'src/directives/material_slider.dart' show SliderBehavior;
import 'src/directives/material_spinner.dart' show SpinnerBehavior;
import 'src/directives/material_switch.dart' show SwitchBehavior;
import 'src/directives/material_textfield.dart' show TextfieldBehavior;
import 'src/directives/material_tooltip.dart' show TooltipBehavior;
import 'src/directives/material_snackbar.dart' show SnackbarBehavior;

@Directive(selector: '.mdl-js-button')
class MaterialButton extends ButtonBehavior implements OnInit {
  MaterialButton(ElementRef ref) : super(ref.nativeElement);
  void ngOnInit() {
    init();
  }
}

@Directive(selector: '.mdl-js-checkbox')
class MaterialCheckbox extends CheckboxBehavior implements OnInit {
  MaterialCheckbox(ElementRef ref) : super(ref.nativeElement);
  void ngOnInit() {
    init();
  }
}

@Directive(selector: '.mdl-js-data-table')
class MaterialDataTable extends DataTableBehavior implements OnInit {
  MaterialDataTable(ElementRef ref) : super(ref.nativeElement);
  void ngOnInit() {
    init();
  }
}

@Directive(selector: '.mdl-js-icon-toggle')
class MaterialIconToggle extends IconToggleBehavior implements OnInit {
  MaterialIconToggle(ElementRef ref) : super(ref.nativeElement);
  void ngOnInit() {
    init();
  }
}

@Directive(selector: '.mdl-js-layout')
class MaterialLayout extends LayoutBehavior implements OnInit {
  MaterialLayout(ElementRef ref) : super(ref.nativeElement);
  void ngOnInit() {
    init();
  }
}

@Directive(selector: '.mdl-js-menu')
class MaterialMenu extends MenuBehavior implements OnInit {
  MaterialMenu(ElementRef ref) : super(ref.nativeElement);
  void ngOnInit() {
    init();
  }
}

// progress and buffer are ints from 0 to 100
@Directive(selector: '.mdl-js-progress', inputs: const ['progress', 'buffer'])
class MaterialProgress extends ProgressBehavior implements OnInit {
  MaterialProgress(ElementRef ref) : super(ref.nativeElement);
  void ngOnInit() {
    init();
  }
}

@Directive(selector: '.mdl-js-radio')
class MaterialRadio extends RadioBehavior implements OnInit {
  MaterialRadio(ElementRef ref) : super(ref.nativeElement);
  void ngOnInit() {
    init();
  }
}

@Directive(selector: 'mdl-js-ripple-effect')
class MaterialRipple extends RippleBehavior implements OnInit {
  MaterialRipple(ElementRef ref) : super(ref.nativeElement);
  void ngOnInit() {
    init();
  }
}

@Directive(
    selector: '.mdl-js-slider', inputs: const ['min', 'max', 'value', 'step'])
class MaterialSlider extends SliderBehavior implements OnInit {
  MaterialSlider(ElementRef ref) : super(ref.nativeElement);
  void ngOnInit() {
    init();
  }
}

@Directive(selector: '.mdl-js-spinner')
class MaterialSpinner extends SpinnerBehavior implements OnInit {
  MaterialSpinner(ElementRef ref) : super(ref.nativeElement);
  void ngOnInit() {
    init();
  }
}

@Directive(selector: '.mdl-js-switch')
class MaterialSwitch extends SwitchBehavior implements OnInit {
  MaterialSwitch(ElementRef ref) : super(ref.nativeElement);
  void ngOnInit() {
    init();
  }
}

@Directive(selector: '.mdl-js-tabs')
class MaterialTabs extends TabsBehavior implements OnInit {
  MaterialTabs(ElementRef ref) : super(ref.nativeElement);
  void ngOnInit() {
    init();
  }
}

@Directive(selector: '.mdl-js-textfield')
class MaterialTextfield extends TextfieldBehavior implements OnInit {
  MaterialTextfield(ElementRef ref) : super(ref.nativeElement);
  void ngOnInit() {
    init();
  }
}

@Directive(selector: '.mdl-tooltip')
class MaterialTooltip extends TooltipBehavior implements OnInit {
  MaterialTooltip(ElementRef ref) : super(ref.nativeElement);
  void ngOnInit() {
    init();
  }
}

@Directive(selector: '.mdl-js-snackbar')
class MaterialSnackbar extends SnackbarBehavior implements OnInit {
  MaterialSnackbar(ElementRef ref) : super(ref.nativeElement);
  void ngOnInit() {
    init();
  }
}

@Directive(selector: '.mdl-badge')
class MaterialBadge implements OnChanges {
  @Input('data-badge') String badge;
  ElementRef ref;
  MaterialBadge(this.ref);
  void ngOnChanges(Map<String,SimpleChange> changeRecord) {
    ref.nativeElement.setAttribute('data-badge', '$badge');
  }
}
