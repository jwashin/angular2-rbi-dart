//
// @license
// Copyright 2015 James Washington All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

library material_snackbar;

import 'dart:html';
import 'dart:async';
import 'dart:collection';

const String SNACKBAR = 'mdl-snackbar';
const String MESSAGE = 'mdl-snackbar__text';
const String ACTION = 'mdl-snackbar__action';
const String ACTIVE = 'is-active';

class SnackbarBehavior {
  Element element;
  Element actionElement;
  Element textElement;
  Element snackbarElement;
  bool active = false;
  int timeout;
  Queue<Map> queuedNotifications = new Queue();
  Function actionHandler;
  String message;
  String actionText;


  SnackbarBehavior(this.element);
  init(){
    setDefaults();
  }

  showSnackbar(Map data) {
    if (active) {
      queuedNotifications.addLast(data);
    } else {
      active = true;
      message = data['message'];
      if (data['timeout'] != null) {
        timeout = data['timeout'];
      } else {
        timeout = 8000;
      }
      if (data['actionHandler'] != null) {
        actionHandler = data['actionHandler'];
      }
      if (data['actionText'] != null) {
        actionText = data['actionText'];
      }
      createSnackbar();
    }
  }

  removeSnackbar() {
    if (actionElement != null && actionElement.parent != null) {
      actionElement.parent.children.remove(actionElement);
    }
    textElement.parent.children.remove(textElement);
    snackbarElement.parent.children.remove(snackbarElement);
  }

  createSnackbar() {
    textElement = new DivElement()..classes.add(MESSAGE);
    snackbarElement = new DivElement()
      ..classes.add(SNACKBAR)
      ..append(textElement)
      ..setAttribute('aria-hidden', 'true');
    if (actionHandler != null) {
      actionElement = new ButtonElement()
        ..type = 'button'
        ..classes.add(ACTION)
        ..text = actionText
        ..addEventListener('click', actionHandler);
      snackbarElement.append(actionElement);
    }
    element.append(snackbarElement);
    textElement.text = message;
    snackbarElement.classes.add(ACTIVE);
    snackbarElement.setAttribute('aria-hidden', 'false');
    new Timer(new Duration(milliseconds: timeout), cleanup);
  }

  cleanup() {
    snackbarElement.classes.remove(ACTIVE);
    snackbarElement.setAttribute('aria-hidden', 'true');
    if (actionElement != null) {
      actionElement.removeEventListener('click', actionHandler);
    }
    setDefaults();
    active = false;
    removeSnackbar();
    checkQueue();
  }

  checkQueue() {
    if (queuedNotifications.length > 0) {
      Map item = queuedNotifications.removeFirst();
      showSnackbar(item);
    }
  }

  setDefaults() {
    actionHandler = null;
    message = null;
    actionText = null;
  }
}
