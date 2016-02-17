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
const String ACTIVE = 'mdl-snackbar--active';

const int ANIMATION_LENGTH = 250;

class SnackbarBehavior {
  Element element;
  bool active = false;
  int timeout;
  Queue<Map> queuedNotifications = new Queue();
  Function actionHandler;
  String message;
  String actionText;

  Element get textElement => element.querySelector('.' + MESSAGE);

  Element get actionElement => element.querySelector('.' + ACTION);

  SnackbarBehavior(this.element);

  void init() {
    setActionHidden(true);
  }

  void setActionHidden(bool aValue) {
    Element _actionElement = actionElement;
    if (_actionElement != null) {
      if (aValue) {
        _actionElement.setAttribute('aria-hidden', 'true');
      } else {
        if (_actionElement.attributes.keys.contains('aria-hidden')) {
          _actionElement.attributes.remove('aria-hidden');
        }
      }
    }
  }

  void _displaySnackBar() {
    /// private; called by showSnackbar

    element.setAttribute('aria-hidden', 'true');
    Function _actionHandler = actionHandler;
    Element _actionElement = actionElement;
    if (_actionHandler != null && _actionElement != null) {
      _actionElement.text = actionText;
      _actionElement.addEventListener('click', actionHandler);
      setActionHidden(false);
    }
    textElement.text = message;
    element.classes.add(ACTIVE);
    element.setAttribute('aria-hidden', 'false');
    new Timer(new Duration(milliseconds: timeout), cleanup);
  }

  void showSnackbar(Map data) {
    if (data != null) {
      if (active) {
        queuedNotifications.addLast(data);
        return;
      }
      active = true;
      message = data['message'];
      if (data.containsKey('timeout')) {
        timeout = data['timeout'];
      } else {
        timeout = 2750;
      }
      if (data.containsKey('actionHandler') && data.containsKey('actionText')) {
        actionHandler = data['actionHandler'];
        actionText = data['actionText'];
      }
      _displaySnackBar();
    }
  }

  void checkQueue() {
    if (queuedNotifications.length > 0) {
      showSnackbar(queuedNotifications.removeFirst());
    }
  }

  void cleanup() {
    element.classes.remove(ACTIVE);
    new Timer(new Duration(milliseconds: ANIMATION_LENGTH), () {
      element.setAttribute('aria-hidden', 'true');
      textElement.text = '';
      if (actionElement != null) {
        Element _actionElement = actionElement;
        if (!_actionElement.attributes.keys.contains('aria-hidden')) {
          setActionHidden(true);
          _actionElement.text = '';
          _actionElement.removeEventListener('click', actionHandler);
        }
      }
      actionHandler = null;
      message = null;
      actionText = null;
      active = false;
      checkQueue();
    });
  }
}
