forEachIndex<T>(Iterable<T> list,void f(T e,int index)){
  for(int i=0;i<list.length;i++){
    f(list.elementAt(i),i);
  }
}