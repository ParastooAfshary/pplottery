unsigned int seed = 1;

int
random(int max) {
  seed = seed * 1664525 + 1013904223;
  return seed % max;
}
