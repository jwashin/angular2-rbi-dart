library component_ripple;

import 'dart:html';
import 'dart:math' show sqrt;
import 'dart:async';
import 'package:angular2_rbi/src/util/animation_frame.dart'
    show getAnimationFrame;
import 'package:angular2/angular2.dart';

const String initialScale = 'scale(0.0001, 0.0001)';
const String finalScale = '';

@Directive(selector: '.mdl-ripple')
class Ripple {
  @HostBinding('class.is-visible') bool visible = false;
  @HostBinding('class.is-animating') bool animating = false;
  @HostBinding('style.webkitTransform') String transformStringWK;
  @HostBinding('style.msTransform') String transformStringMS;
  @HostBinding('style.transform') String transformString;

  @HostBinding('style.width') String width = '';
  @HostBinding('style.height') String height = '';

  @Input() bool centered = false;

  int frameCount = 0;
  int boundWidth;
  int boundHeight;
  int x;
  int y;

  Future doRipple(int clientX, int clientY, Element target) async {
//    centered = center;
    if (width.isEmpty || height.isEmpty) {
      Rectangle rect = target.getBoundingClientRect();
      boundHeight = rect.height.toInt();
      boundWidth = rect.width.toInt();
      int rippleSize =
      (sqrt(boundWidth * boundWidth + boundHeight * boundHeight) * 2 + 2)
          .toInt();
      width = '${rippleSize}px';
      height = '${rippleSize}px';
    }
    visible = true;
    if (frameCount > 0) return;
    frameCount = 1;
    Rectangle bound = target.getBoundingClientRect();
    x = clientX == null ? bound.right : (clientX - bound.left).round();
    y = clientY == null ? bound.bottom : (clientY - bound.top).round();
//    y = (clientY - bound.top).round();
    setTransformString(true);
    await getAnimationFrame();
    animationFrameHandler();
  }

  Future animationFrameHandler() async {
    if (frameCount-- > 0) {
      await getAnimationFrame();
      animationFrameHandler();
    } else {
      setTransformString(false);
    }
  }

//'translate(-50%, -50%) $offset $scale'
  void setTransformString(bool start) {
    String scale = start ? initialScale : finalScale;
    String offset = centered && start
        ? 'translate(${boundWidth / 2}px, ${boundHeight / 2}px)'
        : 'translate(${x}px, ${y}px)';
    transformString = 'translate(-50%, -50%) $offset $scale';
    transformStringMS = transformString;
    transformStringWK = transformString;
    animating = !start;
  }
}

@Component(
    selector: '.mdl-switch__ripple-container,'
        '.mdl-checkbox__ripple-container,'
        '.mdl-radio__ripple-container,'
        '.mdl-icon-toggle__ripple-container',
    template: '<span class="mdl-ripple" [centered]="true"></span>',
    directives: const [Ripple])
class CenteredRippleContainer {
  @ViewChild(Ripple) Ripple ripple;

  @HostListener('mousedown', const ['\$event.client', '\$event.target'])
  void onMouseDown(Point client, Element target) {
    ripple.doRipple(client.x, client.y, target);
  }

  @HostListener('mouseup')
  void onMouseUp() {
    ripple.visible = false;
    ripple.animating = false;
  }
}

@Component(
    selector: '.mdl-button__ripple-container',
    template: '<span class="mdl-ripple" [centered]="false"></span>',
    directives: const [Ripple])
class RippleContainer {
  @ViewChild(Ripple) Ripple ripple;

  @HostListener('mousedown', const ['\$event.client', '\$event.target'])
  void onMouseDown(Point client, Element target) {
    ripple.doRipple(client.x, client.y, target);
  }

  @HostListener('mouseup')
  void onMouseUp() {
    ripple.visible = false;
    ripple.animating = false;
  }

  @HostListener('touchstart', const ['\$event.touches[0]', '\$event.target'])
  void onTouchStart(Point client, Element target) {
    ripple.doRipple(client.x, client.y, target);
  }
}
