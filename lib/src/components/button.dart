library material_component_button;

import 'package:angular2/angular2.dart';

import 'ripple.dart';
import 'package:angular2_rbi/src/util/target_util.dart';

@Component(
    selector: 'button.mdl-js-button',
    template: '<ng-content></ng-content>'
        '<span *ngIf="shouldRipple" class="mdl-button__ripple-container">'
        '</span>',
    directives: const [NgIf, Ripple])
class Button {
  ElementRef ref;
  Renderer renderer;

  Button(this.renderer, this.ref);

  // use relative positioning so mouse clicks are positioned with respect to the
  // button for ripple
//  @HostBinding('style.position') String position = 'relative';

  @ViewChild(Ripple)
  Ripple ripple;

  // default blurs on mouseup; if true, keeps the focus for key input.
  @Input()
  bool keepFocus = false;

  @Input()
  bool shouldRipple = false;

  @Input()
  dynamic disabled = false;

  @HostBinding('style.position') String position = 'relative';

  @Output()
  EventEmitter<bool> hasFocus = new EventEmitter<bool>();

  bool get isDisabled => disabled == '' ? true : disabled;

  void focus() {
    if (!isDisabled) {
      renderer.invokeElementMethod(ref.nativeElement, 'focus', []);
    }
  }

  void blur() => renderer.invokeElementMethod(ref.nativeElement, 'blur', []);

  @HostListener('mousedown', const ['\$event.client', '\$event.target'])
  void onMouseDown(dynamic client, dynamic target) {
    if (!isDisabled) {
      if (shouldRipple) {
        //ripple the button, not its contents
        target = niceTarget(target, 'button');
        ripple.onMouseDown(client, target);
      }
    }
  }

  @HostListener('touchstart', const ['\$event.touches[0]', '\$event.target'])
  void onTouchStart(dynamic client, dynamic target) =>
      onMouseDown(client, target);

  @HostListener('mouseup')
  void onMouseUp() {
    ripple?.onMouseUp();
    if (!keepFocus) {
      blur();
    }
  }

  @HostListener('mouseleave')
  void onMouseLeave() => onMouseUp();

  @HostListener('touchend')
  void onTouchEnd() => onMouseUp();

  @HostListener('focus')
  void onFocus() {
    hasFocus.add(true);
  }

  @HostListener('blur')
  void onBlur() {
    hasFocus.add(false);
  }
}
