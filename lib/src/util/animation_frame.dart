library angular2_rb1.util.animation_frame;

import 'dart:html';
import 'dart:async';

Future<num> getAnimationFrame() {
  Completer<num> completer = new Completer<num>.sync();
  window.requestAnimationFrame((dynamic time) {
    completer.complete(time);
  });
  return completer.future;
}
