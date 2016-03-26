library material_component_button;

import 'package:angular2/angular2.dart';

import 'ripple.dart';

/// MDL Button component
/// The transformer looks for class 'mdl-js-ripple-effect' and replaces it with
/// [shouldRipple]="true".

@Component(
    selector: 'button.mdl-js-button',
    template: '<ng-content></ng-content>'
        '<span *ngIf="shouldRipple && !isDisabled" '
        'class="mdl-button__ripple-container">'
        '</span>',
    directives: const [NgIf, Ripple])
class Button {
  ElementRef ref;
  Renderer renderer;

  Button(this.renderer, this.ref);

  @ViewChild(Ripple)
  Ripple ripple;

  // default blurs on mouseup; if true, keeps the focus for key input.
  @Input()
  bool keepFocus = false;

  @Input()
  bool shouldRipple = false;

  @Input()
  dynamic disabled = false;

  @Output()
  EventEmitter<bool> hasFocus = new EventEmitter<bool>();

  bool get isDisabled => disabled == '' ? true : disabled;

  void focus() {
    if (!isDisabled) {
      renderer.invokeElementMethod(ref.nativeElement, 'focus', []);
    }
  }

  void blur() => renderer.invokeElementMethod(ref.nativeElement, 'blur', []);

  @HostListener('mouseup')
  void onMouseUp() {
    if (!keepFocus) {
      blur();
    }
  }

  @HostListener('mousedown',
      const ['\$event.client', '\$event.target.getBoundingClientRect()'])
  void onMouseDown(dynamic client, dynamic target) {
    ripple?.startRipple(target, client);
  }

  @HostListener('touchstart',
      const ['\$event.touches[0]', '\$event.target.getBoundingClientRect()'])
  void onTouchStart(dynamic client, dynamic target) {
    onMouseDown(client, target);
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
