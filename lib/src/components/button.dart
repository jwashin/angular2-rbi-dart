library material_component_button;

import 'package:angular2/angular2.dart';

import 'ripple.dart';

@Component(
    selector: 'button.mdl-js-button',
    template: '<ng-content></ng-content>'
        '<span *ngIf="shouldRipple" class="mdl-button__ripple-container">'
        '</span>',
    directives: const [NgIf, Ripple])
class Button {
  ElementRef ref;
  Renderer renderer;

  // added instance variable to help menus
  bool keepFocus = false;

  Button(this.renderer, this.ref);

  @Input()
  bool shouldRipple = false;

  @Output()
  EventEmitter<bool> hasFocus = new EventEmitter<bool>();

  void focus() => renderer.invokeElementMethod(ref.nativeElement, 'focus', []);

  void blur() => renderer.invokeElementMethod(ref.nativeElement, 'blur', []);

  @HostListener('mouseup')
  void onMouseUp() {
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
