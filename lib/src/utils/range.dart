/// 특정 범위 값을 `Iterable`하게 반환하는 함수입니다.
Iterable<int> range(int low, int high) sync* {
  for (var i = low; i < high; ++i) {
    yield i;
  }
}
