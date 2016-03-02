library material_component_button;

import 'dart:html';

import 'package:angular2/angular2.dart';

import 'ripple.dart';

@Component(
    selector: 'button.mdl-button.mdl-js-ripple-effect',
    template: '<ng-content></ng-content>'
        '<span class="mdl-button__ripple-container"></span>',
    directives: const [RippleContainer])
class Button {
  @HostListener('mouseup', const ['\$event.target'])
  void onMouseUp(Element target) {
    // the below used to be enclosed in if (event.detail != 2)
    // dunno if click count is needed here

    // find our <button> element to blur
    while (!target.classes.contains('mdl-js-button')) {
      target = target.parent;
    }
    target.blur();
  }

  @HostListener('mouseleave', const ['\$event.target'])
  void onMouseLeave(Element element) => onMouseUp(element);

  @HostListener('touchend', const ['\$event.target'])
  void onTouchEnd(Element element) => onMouseUp(element);
}

@Component(
    selector: 'button.mdl-button:not(.mdl-js-ripple-effect)',
    template: '<ng-content></ng-content>')
class ButtonNoRipple {
  @HostListener('mouseup', const ['\$event.target'])
  void onMouseUp(Element target) {
    // the below used to be enclosed in if (event.detail != 2)
    // dunno if click count is needed here

    // find our <button> element to blur
    while (!target.classes.contains('mdl-button')) {
      target = target.parent;
    }
    target.blur();
  }

  @HostListener('mouseleave', const ['\$event.target'])
  void onMouseLeave(Element element) => onMouseUp(element);

  @HostListener('touchend', const ['\$event.target'])
  void onTouchEnd(Element element) => onMouseUp(element);
}
