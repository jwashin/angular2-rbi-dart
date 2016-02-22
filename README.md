# angular2_rbi

This is a small library to use the excellent Material Design Lite (MDL) CSS system with Angular2 and Dart.

I translated the dynamic JavaScript parts of MDL into Dart and made corresponding Angular2 directives. These key on the same selectors as the JavaScript implementation. E.g, If you want a dynamic Material Button, include the 'mdl-js-button' class,
just like in the instructions for Material Design Lite. Then, in your component metadata, use the MaterialButton directive provided in package:angular2_rbi/directives.dart to add the dynamic effects.

RBI now stands for 'Realistically Better Implementation.' This is low-fuss way to use MDL in Angular2 for Dart. 
It is not an improvement on MDL. In use, it will have the same issues as MDL, which is a large and complex CSS system.
Much of its work is direct DOM access, so if you are not using webworkers, this could be useful. 

## Usage

Follow the directions at <http://www.getmdl.io> to include the styles and fonts in your loading page. But don't include the MDL JavaScript link; this package substitutes for that functionality.

Use the MDL classes in component templates, and assure that the directives for the '*mdl-js-x...*' classes are included in the component metadata. The directive names and selectors are in angular2_rbi/lib/directives.dart.

Clues for difficulties might be found in the source of the MDL stylesheet.

Here's some example code:

    import 'package:angular2/angular2.dart';
    import 'package:angular2_rbi/directives.dart';

    @Component(selector: 'button-textchanger')
    @View(
        template: '''
          <div class="mdl-card mdl-shadow--2dp">
          <div class="mdl-card__title">
          <h2 class="mdl-card__title-text">{{myText}}</h2>
          </div>
          <div class="mdl-card__actions mdl-card--border">
          <button (click)="changeText()" class="mdl-button
          mdl-js-button mdl-button--raised mdl-js-ripple-effect
          mdl-button--colored">Change the text!</button>
          </div>
          </div>
          ''',
        directives: const [MaterialButton])
    class ButtonTextChanger {
      String myText = 'I have never been changed!';
      int count = 0;
      changeText() {
        count += 1;
        if (count == 1) {
          myText = 'I have been changed!';
        } else {
          myText = 'I have been changed $count times!';
        }
      }
    }

## Demo

There is a demo app using this at <https://github.com/jwashin/angular2-rbi-demo>.

This page at <http://www.getmdl.io> demonstrates the available [MDL components](http://www.getmdl.io/components/index.html).


## Features and bugs

This currently (22 February, 2016) seems to work with MDL 1.1.1. I have not figured out testing yet, so a contributed test harness would be graciously accepted.

Please file issues with MDL at [Github: Material Design Lite] (https://github.com/google/material-design-lite). And be nice. They have a system to decide what needs to happen when.

You may file feature requests and bugs on this Dart code at [my Github](https://github.com/jwashin/angular2-rbi-dart).
