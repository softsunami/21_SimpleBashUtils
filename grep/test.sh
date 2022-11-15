#!/bin/bash

SUCCESS=0
FAIL=0
VERDICT=""

for flag1 in -e -i -v -c -l -n -h -s -o
do
  ./s21_grep $flag1 "print" test.txt test.txt > s21_grep.txt
  grep $flag1 "print" test.txt test.txt > grep.txt
  VERDICT="$(diff -s s21_grep.txt grep.txt)"
  if [ "$VERDICT" == "Files s21_grep.txt and grep.txt are identical" ]
          then
            (( SUCCESS++ ))
          else
            echo "[-] flags -$flag1 not passed"
            (( FAIL++ ))
        fi
  rm s21_grep.txt grep.txt
done

for flag1 in -i -v -c -l -n -h -s -o
do
  for flag2 in -i -v -c -l -n -h -s -o
  do
    for flag3 in -i -v -c -l -n -h -s -o
      do
      if [ $flag1 != $flag2 ] && [ $flag1 != $flag3 ] && [ $flag2 != $flag3 ]
      then
      ./s21_grep $flag1 $flag2 $flag3 "print" test.txt > s21_grep.txt
      grep $flag1 $flag2 $flag3 "print" test.txt > grep.txt
      VERDICT="$(diff -s s21_grep.txt grep.txt)"
      if [ "$VERDICT" == "Files s21_grep.txt and grep.txt are identical" ]
              then
                (( SUCCESS++ ))
              else
                echo "[-] flags $flag1 $flag2 $flag3 not passed"
                (( FAIL++ ))
      fi
      rm s21_grep.txt grep.txt
      fi
    done
  done
done


echo "passed $SUCCESS tests"
echo "failed $FAIL tests"