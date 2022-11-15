SUCCESS=0
FAIL=0
VERDICT=""

for flag in -b -n -e -s -t -v
do
	./s21_cat $flag test.txt > s21_cat.txt
	cat $flag test.txt > cat.txt
	VERDICT="$(diff -s s21_cat.txt cat.txt)"
	if [ "$VERDICT" == "Files s21_cat.txt and cat.txt are identical" ]
	  then
	    (( SUCCESS++ ))
	  else
	    echo "flag $flag not passed"
	    (( FAIL++))
	fi
	rm s21_cat.txt cat.txt
done

for flag in -b -n -e -s -t -v
do
	for flag2 in -b -n -e -s -t -v
	do
		if [ $flag != $flag2 ]
		then
		  ./s21_cat $flag $flag2 test.txt > s21_cat.txt
		  cat $flag $flag2 test.txt > cat.txt
		  VERDICT="$(diff -s s21_cat.txt cat.txt)"
		  if [ "$VERDICT" == "Files s21_cat.txt and cat.txt are identical" ]
		    then
		      (( SUCCESS++ ))
		    else
		      echo "flags $flag and $flag2 not passed"
		      (( FAIL++ ))
		  fi
		rm s21_cat.txt cat.txt
	        fi
	done
done

for flag in -b -n -e -s -t -v
do
  for flag2 in -b -n -e -s -t -v
  do
    for flag3 in -b -n -e -s -t -v
    do
      if [ $flag != $flag2 ] && [ $flag != $flag3 ] && [ $flag2 != $flag3 ]
      then
        ./s21_cat $flag $flag2 $flag3 test.txt > s21_cat.txt
        cat $flag $flag2 $flag3 test.txt > cat.txt
        VERDICT="$(diff -s s21_cat.txt cat.txt)"
	if [ "$VERDICT" == "Files s21_cat.txt and cat.txt are identical" ]
          then
            (( SUCCESS++ ))
          else
            echo "flags $flag, $flag2 and $flag3 not passed"
            (( FAIL++ ))
        fi
        rm s21_cat.txt cat.txt
      fi
    done
  done
done

for flag in -b -n -e -s -t -v
do
  for flag2 in -b -n -e -s -t -v
  do
    for flag3 in -b -n -e -s -t -v
    do
      for flag4 in -b -n -e -s -t -v
      do
        if [ $flag != $flag2 ] && [ $flag != $flag3 ] && [ $flag != $flag4 ] && [ $flag2 != $flag3 ] && [ $flag2 != $flag4 ] && [ $flag3 != $flag4 ]
        then
          ./s21_cat $flag $flag2 $flag3 $flag4 test.txt > s21_cat.txt
          cat $flag $flag2 $flag3 $flag4 test.txt > cat.txt
          VERDICT="$(diff -s s21_cat.txt cat.txt)"
          if [ "$VERDICT" == "Files s21_cat.txt and cat.txt are identical" ]
            then
	      (( SUCCESS++ ))
            else
              (( FAIL ++ ))
              echo "flags $flag, $flag2, $flag3 and $flag4 not passed"
          fi
          rm cat.txt s21_cat.txt
        fi
      done
    done
  done
done

echo "passed $SUCCESS tests"
echo "failed $FAIL tests"