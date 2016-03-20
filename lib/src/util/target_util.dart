dynamic niceTarget(dynamic target, String tag) {
  print('initial target: ${target.localName}');
  while (target.localName.toLowerCase() != tag) {
    target = target.parent;
  }
  print('new target: ${target.localName}');
  return target;
}
