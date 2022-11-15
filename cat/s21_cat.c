#include <getopt.h>
#include <stdio.h>

typedef struct opt {
  int b, e, n, s, t, v;
} opt;

int parse(int argc, char *argv[], opt *options);
void output(char *argv[], opt options);

void s21_cat(int b, int e, int n, int s, int t, int v, FILE *fp);

int main(int argc, char *argv[]) {
  int flag = 0;
  opt options = {0};
  flag = parse(argc, argv, &options);
  if (flag == 0) {
    output(argv, options);
  }
  return 0;
}

int parse(int argc, char *argv[], opt *options) {
  int option_index;
  int option;
  static struct option long_options[] = {{"number-nonblank)", 0, 0, 'b'},
                                         {"number", 0, 0, 'n'},
                                         {"squeeze-blank", 0, 0, 's'},
                                         {0, 0, 0, 0}};
  while ((option = getopt_long(argc, argv, "+benstvTE", long_options,
                               &option_index)) != -1) {
    if (option == 'b')
      options->b = 1;
    else if (option == 'e') {
      options->e = 1;
      options->v = 1;
    } else if (option == 'n')
      options->n = 1;
    else if (option == 's')
      options->s = 1;
    else if (option == 't') {
      options->t = 1;
      options->v = 1;
    } else if (option == 'v')
      options->v = 1;
    else if (option == 'T')
      options->t = 1;
    else if (option == 'E')
      options->e = 1;
    else {
      fprintf(stderr, "Usage: b, e, n, s, t, v, T, E flags");
      return -1;
    }
  }
  return 0;
}

void output(char *argv[], opt options) {
  FILE *fp = fopen(argv[optind], "r");
  if (fp) {
    s21_cat(options.b, options.e, options.n, options.s, options.t, options.v,
            fp);
  } else {
    printf("No such file");
  }

  fclose(fp);
}

void s21_cat(int b, int e, int n, int s, int t, int v, FILE *fp) {
  int current, prev = 1, count = 1, first = 1, temp = 0;
  int skip;
  if (n == 1 && b == 1) n = 0;
  while ((current = fgetc(fp)) != EOF) {
    skip = 0;
    if (s) {
      if (current == '\n') {
        skip = 1;
        temp++;
      } else {
        temp = 0;
      }
      if (temp == 1 || temp == 2) {
        skip = 0;
        current = '\n';
      }
    }
    if (b) {
      if ((prev == '\n' && current != prev) || first) {
        printf("     %d\t", count);
        first = 0;
        count++;
      }
    }
    if (n) {
      if ((prev == '\n' || first) && skip == 0) {
        printf("%6d\t", count);
        first = 0;
        count++;
      }
    }
    if (e && skip == 0) {
      if (current == '\n') printf("$");
    }
    if (t) {
      if (current == '\t') {
        printf("^I");
        skip = 1;
      }
    }
    if (v) {
      if (current < 32 && current != 9 && current != 10)
        printf("^%c", current + 64);
      else if (current > 127 && current < 160)
        printf("M-^%c", current - 64);
      else if (current == 127)
        printf("^%c", current - 64);
    }
    prev = current;

    if (skip != 1) {
      printf("%c", current);
    }
  }
}
