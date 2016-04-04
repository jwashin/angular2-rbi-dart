library rbi_components_spinner;

import 'package:angular2/angular2.dart';

@Component(
    selector: '.mdl-js-spinner',
    template: ''
        '<div class="mdl-spinner__layer mdl-spinner__layer-1">'
        '<div class="mdl-spinner__circle-clipper mdl-spinner__left">'
        '<div class="mdl-spinner__circle">'
        '</div>'
        '</div>'
        '<div class="mdl-spinner__gap-patch">'
        '<div class="mdl-spinner__circle">'
        '</div>'
        '</div>'
        '<div class="mdl-spinner__circle-clipper mdl-spinner__right">'
        '<div class="mdl-spinner__circle">'
        '</div>'
        '</div>'
        '</div>'
        '<div class="mdl-spinner__layer mdl-spinner__layer-2">'
        '<div class="mdl-spinner__circle-clipper mdl-spinner__left">'
        '<div class="mdl-spinner__circle">'
        '</div>'
        '</div>'
        '<div class="mdl-spinner__gap-patch">'
        '<div class="mdl-spinner__circle">'
        '</div>'
        '</div>'
        '<div class="mdl-spinner__circle-clipper mdl-spinner__right">'
        '<div class="mdl-spinner__circle">'
        '</div>'
        '</div>'
        '</div>'
        '<div class="mdl-spinner__layer mdl-spinner__layer-3">'
        '<div class="mdl-spinner__circle-clipper mdl-spinner__left">'
        '<div class="mdl-spinner__circle">'
        '</div>'
        '</div>'
        '<div class="mdl-spinner__gap-patch">'
        '<div class="mdl-spinner__circle">'
        '</div>'
        '</div>'
        '<div class="mdl-spinner__circle-clipper mdl-spinner__right">'
        '<div class="mdl-spinner__circle">'
        '</div>'
        '</div>'
        '</div>'
        '<div class="mdl-spinner__layer mdl-spinner__layer-4">'
        '<div class="mdl-spinner__circle-clipper mdl-spinner__left">'
        '<div class="mdl-spinner__circle">'
        '</div>'
        '</div>'
        '<div class="mdl-spinner__gap-patch">'
        '<div class="mdl-spinner__circle">'
        '</div>'
        '</div>'
        '<div class="mdl-spinner__circle-clipper mdl-spinner__right">'
        '<div class="mdl-spinner__circle">'
        '</div>'
        '</div>'
        '</div>')
class Spinner {
  @HostBinding('class.is-active')
  final bool active = true;
  @HostBinding('class.is-upgraded')
  final bool upgraded = true;
  @HostBinding('class.mdl-spinner')
  final bool spinner = true;
}
