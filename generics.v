struct Things<T> {
    a T
    b T
    c int
}

small := Things<int>{1, 1, 2}
big := Things<i64>{1, 1, 2}