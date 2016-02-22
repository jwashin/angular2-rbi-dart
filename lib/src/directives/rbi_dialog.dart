library dialog_widget;

import 'package:angular2/angular2.dart';
import 'dart:html';
import 'dart:async';
//import 'dart:math';

const int NORMAL_ALIGNMENT = 0;
const int CENTERED_ALIGNMENT = 1;
const int MAGIC_ALIGNMENT = 2;

Element findNearestDialog(Element el) {
//  print('finding nearest dialog');
  while (el != null) {
//    print('$el, ${el.classes}');
    if (el.classes.contains('rbi-dialog')) {
      return el;
    }
    el = el.parent;
  }
  return null;
}

bool inNodeList(List<Element> nodeList, Element node) =>
    nodeList.contains(node);

//  interface HTMLDialogElement : HTMLElement {
//    attribute boolean open;
//    attribute DOMString returnValue;
//    void show(optional (MouseEvent or Element) anchor);
//    void showModal(optional (MouseEvent or Element) anchor);
//    void close(optional DOMString returnValue);
//  };

@Component(selector: '.rbi-dialog', template: '<ng-content></ng-content>',
//    styleUrls: const['rbi_dialog.css'],
    directives: const [CORE_DIRECTIVES])
class DialogWrapper implements OnInit {
  @Input() String returnValue = '';
  @HostBinding('style.z-index') String dialogZ = '0';

//  @HostBinding('style.top') String top = '';
//  @HostBinding('style.bottom') String bottom = '';
//  @HostBinding('style.left') String left = '';

//  @HostBinding('style.display') String display = 'none';

  ElementRef elementRef;

//  Element backdrop;
//  String backdropZ = '0';
  int alignment = NORMAL_ALIGNMENT;
  Element anchorElement;
  Element originalParent;

//  bool replacedStyleTop = false;
  bool openAsModal = false;
  bool isNativeDialog = false;
  DialogManager dialogManager;
  Element oldParent;
  StreamSubscription cancelListener;
  Element get dialog => elementRef.nativeElement;

  DialogWrapper(this.elementRef, this.dialogManager);

  void ngOnInit() {
    if (dialog is DialogElement) {
//      print("Can't upgrade <dialog>: already supported by browser");
      isNativeDialog = true;
    } else {
//      backdrop = new DivElement()..classes.add('backdrop');
      dialog.attributes.remove('tabindex');
      restore();
      dialog.setAttribute('role', 'dialog');
    }
//    print('native dialog is $isNativeDialog');

//    element.parent.insertAdjacentElement('afterEnd',)
  }

  void restore() {
    dialogZ = '10000';
//    top = '0';
//    bottom = '0';
    dialog.classes.remove('rbi-dialog-centered');
    dialog.classes.remove('rbi-dialog-magic');
  }

  void setOpen(bool aValue) {
    if (aValue) {
      dialog.setAttribute('open', '');
      cancelListener = dialog.on['cancel'].listen((event) {
        if (dialog.attributes.containsKey('open')) {
          close();
        }
      });
//      Timer.run(() {
//        print('dialog is at ${dialog.getBoundingClientRect()}');
//      });
    } else {
      dialog.attributes.remove('open');
      cancelListener.cancel();
      maybeHideModal();
    }
  }

  void setReturnValue(String aValue) {
    returnValue = aValue;
    if (isNativeDialog) {
      dialog.setAttribute('returnValue', aValue);
    }
  }

  // anchor currently can only be an Element
  // no anchor: it will be where it is in the document. You may position it
  // some other way, usually css
  void show([dynamic anchor = null]) {
    if (isNativeDialog) {
      DialogElement d = dialog;
      d.show();
      return;
    }

    Element parent = dialog.parent;
    if (parent != null) {
      String zix = parent.style.zIndex;
      if (zix.isNotEmpty) {
        num z = num.parse(parent.style.zIndex) + 1;
        dialogZ = '$z';
      }
    }
    anchorElement = null;
    alignment = NORMAL_ALIGNMENT;
    if (anchor != null) {
      setAlignment(anchor);
    }
    if (alignment != NORMAL_ALIGNMENT) {
      setPosition();
    }
    setOpen(true);
    doAutofocus();
    if (alignment == MAGIC_ALIGNMENT) {
      dialog.scrollIntoView(ScrollAlignment.CENTER);
    }
  }

  void setPosition() {
    if (alignment == CENTERED_ALIGNMENT) {
      setCenteredPosition();
    } else if (alignment == MAGIC_ALIGNMENT) {
      dialog.classes.add('rbi-dialog-magic');
      setMagicPosition();
    }
  }

  void setAlignment(dynamic anchor) {
    if (anchor is MouseEvent) {
      throw new UnimplementedError('no dealing with mouse events yet');
//      Element testElement = anchor.target;
//      if (testElement.style.display == 'none') {
//        alignment = CENTERED_ALIGNMENT;
//        return;
//      }
//      anchorElement = newElementAtMousePosition(anchor);
    } else {
      anchorElement = anchor;
    }
    alignment = MAGIC_ALIGNMENT;
  }

  void setMagicPosition() {
    /// since 'anchor-point' is not really implemented anywhere,
    /// we will presume that we just want to drop the dialog into
    /// the target element.
    ///
    oldParent = dialog.parent;
    if (!anchorElement.children.contains(dialog)) {
      anchorElement.children.add(dialog);
    }

//    print('calculating position');
//    Rectangle clientRect = anchorElement.getBoundingClientRect();
//    print('clientRect is $clientRect');
//    num anchorCenterX = clientRect.left + clientRect.width / 2;
//    num anchorCenterY = clientRect.top + clientRect.height / 2;
//    Element d = dialog;
//    String oldDisplay = d.style.display;
//    d.style.display = 'hidden';
//    Timer.run(() {
//      Rectangle dialogRect = d.getBoundingClientRect();
//      print('dialogRect is $dialogRect');
//      num dialogHeight = dialogRect.bottom - dialogRect.top;
//      num dialogWidth = dialogRect.right - dialogRect.left;
//      num newTop = anchorCenterY - dialogHeight / 2 + anchorElement.scrollTop;
//      top = '$newTop px';
//      print('new top should be $newTop');
//      num newLeft = anchorCenterX - dialogWidth / 2;
//      left = '$newLeft px';
//      print('new left should be $newLeft');
//      d.style.display = oldDisplay;
//    });
  }

  void setCenteredPosition() {}

//  Element newElementAtMousePosition(MouseEvent event) {
//    Element element = new DivElement();
//    element.style.top = event.client.y;
//    element.style.left = event.client.x;
//    element.style.width = '0px';
//    element.style.height = '0px';
//    return element;
//  }

  void doAutofocus() {
    Element target = dialog.querySelector('[autofocus]:not([disabled])');
    if (target == null) {
      List<String> newList = [];
      for (String item in ['button', 'input', 'keygen', 'select', 'textarea']) {
        newList.add('$item:not([disabled])');
      }
      target = dialog.querySelector(newList.join(', '));
    }
//    print('target is $target, ${target.text}');
    if (target != null) {
      Timer.run(() {
        document.activeElement.blur();
        target.focus();
//        print("activeElement should be $target, ${target.text}");
//        print("activeElement is ${document.activeElement}, ${document
//            .activeElement.text}");
      });
    }
  }

  void showModal() {
    if (dialog.attributes.containsKey('open')) {
      print('showmodal called; already open');
      return;
    }
//    if (!document.body.children.contains(dialog)){
//      print('showmodal called; dialog not child of body element');
//      return;
//    }
    if (isNativeDialog) {
      DialogElement d = dialog;
      d.showModal();
      return;
    }
//    dialog.classes.remove('rbi-dialog-magic');

    dialog.classes.add('rbi-dialog-centered');

    if (!dialogManager.pushDialog(this)) {
      print('showmodal called; too many open modal dialogs');
      return;
    }
    show();
    openAsModal = true;
//    bool t = needsCentering();
//    print('needsCentering is $t');
//    if (needsCentering()) {
//      reposition();
//      replacedStyleTop = true;
//    } else {
//      replacedStyleTop = false;
//    }
//    backdrop.addEventListener('click', backdropClick);
//    dialog.parent.insertBefore(backdrop, dialog.nextElementSibling);
//    doAutofocus();
  }

  void close([dynamic value = null]) {
//    print('closing dialog');
    if (isNativeDialog) {
      DialogElement d = dialog;
      d.close(value);
      return;
    }
    restore();
    if (!dialog.attributes.containsKey('open')) {
      print('cannot close dialog; no open attribute');
      return;
    }
    setOpen(false);
    alignment = NORMAL_ALIGNMENT;

    anchorElement = null;
    if (value != null) {
      setReturnValue(value);
    }
//    print('Return value is $returnValue');
    CustomEvent closeEvent =
    new CustomEvent('close', canBubble: false, cancelable: false);
    dialog.dispatchEvent(closeEvent);
    if (openAsModal) {
      dialogManager.removeDialog(this);
//      backdrop.removeEventListener('click', backdropClick);
    }
  }

  void maybeHideModal() {
    if (!openAsModal) {
      return;
    }
    if (dialog.attributes.containsKey('open') &&
        document.body.children.contains(dialog)) {
      return;
    }
    openAsModal = false;
//    dialog.style.zIndex = '';
//    if (replacedStyleTop) {
//      top = '';
//      replacedStyleTop = false;
//    }
//    backdrop.removeEventListener('click', backdropClick);

//    if (backdrop.parent != null) {
//      backdrop.parent.children.remove(backdrop);
//    }
    if (!isNativeDialog) {
      dialogManager.removeDialog(this);
    }
  }

  void updateZIndex(dynamic b) {
    dialogZ = '$b';
  }

//  void backdropClick(MouseEvent e) {
//    print('backdrop clicked');
//    MouseEvent redirectedEvent = new MouseEvent('MouseEvents',
//        detail: e.detail,
//        screenX: e.screen.x,
//        screenY: e.screen.y,
//        clientX: e.client.x,
//        clientY: e.client.y,
//        button: e.button,
//        canBubble: e.bubbles,
//        cancelable: e.cancelable,
//        ctrlKey: e.ctrlKey,
//        altKey: e.altKey,
//        shiftKey: e.shiftKey,
//        metaKey: e.metaKey,
//        relatedTarget: e.relatedTarget);
//    dialog.dispatchEvent(redirectedEvent);
//    e.stopPropagation();
//  }

//  void reposition() {
//    num scrollTop = document.body.scrollTop;
//    num topValue = scrollTop + (window.innerHeight - dialog.offsetHeight) / 2;
//    dialog.style.top = '${max(scrollTop,topValue)}px';
//  }

//  bool isInlinePositionSetByStylesheet() {
//    for (CssStyleSheet stylesheet in document.styleSheets) {
//      if (stylesheet.rules != null) {
//        for (CssRule rule in stylesheet.rules) {
//          if (rule.type == CssRule.STYLE_RULE) {
//            CssStyleRule styleRule = rule;
//            List<Element> selectedNodes =
//                document.querySelectorAll(styleRule.selectorText);
//            if (selectedNodes.contains(dialog)) {
//              String cssTop = styleRule.style.getPropertyValue('top');
//              String cssBottom = styleRule.style.getPropertyValue('bottom');
//              if (cssTop != 'auto' || cssBottom != 'auto') {
//                return true;
//              }
//            }
//          }
//        }
//      }
//    }
//    return false;
//  }

//  bool needsCentering() {
//    if (dialog.getComputedStyle().position != 'absolute') {
//      return false;
//    }
//    if (top != 'auto' && top != '' || bottom != 'auto' && bottom != '') {
//      return false;
//    }
//    bool t = isInlinePositionSetByStylesheet();
//    print("inlineStyesheetPosition is $t");
//    return t;
//  }

}

@Injectable()
class DialogManager {
  List<DialogWrapper> pendingDialogStack = [];
  DivElement overlay;
  int zIndexLow = 100000;
  int zIndexHigh = 100000 + 150;
  StreamSubscription dmOverlayClick;
  StreamSubscription dmFocus;
  StreamSubscription dmKeyDown;

//  MutationObserver documentObserver;

  DialogManager() {
    overlay = new DivElement()
      ..classes.add('_dialog_overlay');
    dmOverlayClick = overlay.onClick.listen((event) {
//      print('dm overlay clicked');
      event.stopPropagation();
      topDialog.doAutofocus();
    });
    document.addEventListener('submit', (Event event) {
      Element target = event.target;
      if (target == null ||
          !target.attributes.containsKey('method') ||
          target.getAttribute('method').toLowerCase() != 'dialog') {
        return;
      }
      event.preventDefault();
      Element dialog = findNearestDialog(event.target);
      if (dialog == null) {
        return;
      }
      String returnValue;
      List<InputElement> candidates = [document.activeElement, event.target];
      List elementTypes = ['BUTTON', 'INPUT'];
      Iterable<InputElement> els = candidates.where((InputElement candidate) =>
      candidate != null &&
          candidate.form == event.target &&
          elementTypes.contains(candidate.nodeName.toUpperCase()));
      for (InputElement item in els) {
        returnValue = item.value;
      }
      wrapperFromElement(dialog).close(returnValue);
    }, true);
  }

  DialogWrapper get topDialog => wrapperFromElement(topDialogElement());

  Element get modalAttachment {
    Element mdlLayoutContainer = querySelector('.mdl-layout__container');
    if (mdlLayoutContainer != null) {
      return mdlLayoutContainer;
    }
    return document.body;
  }

  DialogWrapper wrapperFromElement(Element el) =>
      pendingDialogStack.firstWhere((DialogWrapper item) => item.dialog == el,
          orElse: () => null);

  Element topDialogElement() {
    if (pendingDialogStack.isNotEmpty) {
      return pendingDialogStack.last.dialog;
    }
    return null;
  }

  void blockDocument() {
    modalAttachment.append(overlay);
    dmFocus = document.body.onFocus.listen((event) => handleFocus(event));
    dmKeyDown = document.onKeyDown.listen((event) => handleKey(event));
//    document.addEventListener('keydown', handleKey);
//    print('document blocked');
  }

  void unblockDocument() {
    modalAttachment..children.remove(overlay);
    dmFocus.cancel();
    dmKeyDown.cancel();
//    print('document unblocked');
  }

  void updateStacking() {
    int zIndex = zIndexLow;
    for (DialogWrapper item in pendingDialogStack) {
      if (item == pendingDialogStack.last) {
        overlay.style.zIndex = '${zIndex++}';
      }
      item.updateZIndex(zIndex++);
    }
  }

  void handleKey(KeyboardEvent event) {
    if (event.keyCode == KeyCode.ESC) {
      event
        ..preventDefault()
        ..stopPropagation();
      CustomEvent cancelEvent =
      new CustomEvent('cancel', canBubble: false, cancelable: true);
      topDialog.dialog.dispatchEvent(cancelEvent);
    }
  }

  bool handleFocus(FocusEvent event) {
//    print('using dm focus event');
    Element target = event.target;
    Element candidate = findNearestDialog(target);
//    print("candidate is $candidate");
//    print("topDialog is ${topDialogElement()}");
    if (candidate != topDialogElement() && topDialogElement() != null) {
//      print('not in top dialog');
      topDialog.doAutofocus();
      event
        ..preventDefault()
        ..stopPropagation();
      target.blur();
      return false;
    }
    return true;
  }

  bool pushDialog(DialogWrapper dialog) {
    num allowed = (zIndexHigh - zIndexLow) / 2 - 1;
    if (pendingDialogStack.length >= allowed) {
      return false;
    }
    dialog.originalParent = dialog.dialog.parent;
    modalAttachment.append(dialog.dialog);
    pendingDialogStack.add(dialog);
    if (pendingDialogStack.length == 1) {
      blockDocument();
    }
    updateStacking();
    return true;
  }

  void removeDialog(DialogWrapper dialog) {
    if (pendingDialogStack.contains(dialog)) {
      pendingDialogStack.remove(dialog);
      dialog.originalParent.append(dialog.dialog);
      if (pendingDialogStack.isEmpty) {
        unblockDocument();
      } else {
        updateStacking();
      }
    } else {
      return;
    }
  }
}
