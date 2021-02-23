/// list 的扩展
extension ListX on List {
  forEachIndex(void f(element, int index)) {
    for (int i = 0; i < this.length; i++) {
      f(this[i], i);
    }
  }
}
