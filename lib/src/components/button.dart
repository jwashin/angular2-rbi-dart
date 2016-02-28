library material_component_button;

import 'dart:html';
import 'dart:async';

import 'package:angular2/angular2.dart';

import 'ripple.dart';

const String rippleEffect = 'mdl-js-ripple-effect';
const String rippleIgnoreEvents = 'mdl-js-ripple-effect--ignore-events';

@Component(
    selector: '.mdl-js-button',
    template: '''<ng-content></ng-content>
    <span *ngIf="shouldRipple"
    class="mdl-button__ripple-container">
    <span (mouseup)="onMouseUp(\$event.target)" class="mdl-ripple"></span>
    </span>''',
    directives: const [CORE_DIRECTIVES, Ripple])
class Button implements OnInit, OnChanges {
  bool shouldRipple;
  @Input('class') String classes;
  @Input() bool disabled = false;
  @ViewChild(Ripple) Ripple rippleElement;
  @HostBinding('class.is-disabled') bool isDisabled = false;

  @HostListener('mouseup', const ['\$event.target'])
  void onMouseUp(Element target) {
    // the below used to be enclosed in if (event.detail != 2)
    // dunno if click count is needed here

    while (!target.classes.contains('mdl-js-button')) {
      // find our <button> element to blur
      target = target.parent;
    }
    Timer.run(() => target.blur());
    if (rippleElement == null) return;
    rippleElement.visible = false;
    rippleElement.animating = false;
  }

  @HostListener('mouseleave', const ['\$event.target'])
  void onMouseLeave(Element element) => onMouseUp(element);

  @HostListener('touchend', const ['\$event.target'])
  void onTouchEnd(Element element) => onMouseUp(element);

  @HostListener('blur', const ['\$event.target'])
  void rippleBlur(Element element) => onMouseUp(element);

  @HostListener('mousedown', const ['\$event'])
  void onMouseDown(MouseEvent event) {
    if (disabled) {
      event.preventDefault();
      return;
    }
    if (rippleElement == null) return;
    rippleElement.doRipple(
        event.client.x, event.client.y, event.currentTarget, false);
  }

  @HostListener('touchstart', const ['\$event'])
  void onTouchStart(TouchEvent event) {
    if (rippleElement != null) {
      rippleElement.doRipple(event.touches[0].client.x,
          event.touches[0].client.y, event.currentTarget, false);
    }
  }

  void ngOnInit() {
    shouldRipple =
        classes.contains(rippleEffect) && !classes.contains(rippleIgnoreEvents);
  }

  void ngOnChanges(Map<String, SimpleChange> changeRecord) {
    if (changeRecord.containsKey('disabled')) {
      dynamic t = changeRecord['disabled'].currentValue;
      // if t is a string, it is from a 'disabled' tag attribute, so true
      disabled = t is String ? true : t;
      isDisabled = disabled;
    }
  }
}
