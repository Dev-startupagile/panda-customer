import 'dart:math';

int random() {
    int min = 1;
    int max = 100000;
    return min + Random().nextInt(max - min);
}
