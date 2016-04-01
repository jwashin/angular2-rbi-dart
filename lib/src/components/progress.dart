library progress.dart;

import 'package:angular2/angular2.dart';
import 'slider.dart' show asNumber;

@Component(
    selector: '.mdl-js-progress',
    template: ''
        '<div class="progressbar bar bar1" '
        '    [style.width]="progressPercent | percent">'
        '</div>'
        '<div class="bufferbar bar bar2" '
        '    [style.width]="bufferPercent | percent">'
        '</div>'
        '<div class="auxbar bar bar3" [style.width]="auxPercent | percent">'
        '</div>'
        '',
    pipes: const [COMMON_PIPES])
class Progress implements OnChanges {
  num progressFraction = 0;
  num auxFraction = 0;
  num bufferFraction = 1;

  @HostBinding('class.is-upgraded')
  final bool isUpgraded = true;

  @Input()
  dynamic progress;

  @Input()
  dynamic buffer;

  void ngOnChanges(Map<String, SimpleChange> changes) {
    if (changes.containsKey('progress')) {
      progressFraction = asNumber(changes['progress'].currentValue) / 100;
    }
    if (changes.containsKey('buffer')) {
      bufferFraction = asNumber(changes['buffer'].currentValue) / 100;
      auxFraction = 1 - bufferFraction;
    }
  }
}
