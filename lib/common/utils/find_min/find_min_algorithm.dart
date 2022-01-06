class FindMinAlgorithm {
  int? a;
  int? b;
  int? c;

  FindMinAlgorithm({this.a, this.b, this.c});

  int? get min {
    if (a != null && b != null && c != null) {
      return findMin3;
    } else if (a == null && b == null) {
      return c!;
    } else if (a == null && c == null) {
      return b!;
    } else if (b == null && c == null) {
      return a!;
    } else if (a == null) {
      return b! < c! ? b : c;
    } else if (b == null) {
      return a! < c! ? a : c;
    } else if (c == null) {
      return a! < b! ? a : b;
    }
  }

  int get findMin3 {
    if (a! <= b! && a! <= c!) {
      return a!;
    } else if (b! <= a! && b! <= c!) {
      return b!;
    } else {
      return c!;
    }
  }
}
