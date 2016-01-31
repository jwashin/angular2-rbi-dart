library material_progress;

import 'dart:html';

const String PROGRESS_INDETERMINATE = 'mdl-progress__indeterminate';
const String IS_UPGRADED = 'is-upgraded';
const String PROGRESS_BAR = 'progressbar';
const String BAR = 'bar';
const String BAR1 = 'bar1';
const String BAR2 = 'bar2';
const String BAR3 = 'bar3';
const String BUFFER_BAR = 'bufferbar';
const String AUX_BAR = 'auxbar';

class ProgressBehavior {
  Element element;
  Element progressBar;
  Element bufferBar;
  Element auxBar;
  String progress;
  String buffer;

  ProgressBehavior(this.element){
    if (element != null) {
      progressBar = new DivElement()
        ..classes.addAll([PROGRESS_BAR, BAR, BAR1])
        ..style.width = '0%';
      element.append(progressBar);
      bufferBar = new DivElement()
        ..classes.addAll([BUFFER_BAR, BAR, BAR2])
        ..style.width = '100%';
      element.append(bufferBar);
      auxBar = new DivElement()
        ..classes.addAll([AUX_BAR, BAR, BAR3])
        ..style.width = '0%';
      element.append(auxBar);
      element.classes.add(IS_UPGRADED);
    }
  }
}
