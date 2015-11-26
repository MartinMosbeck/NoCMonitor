#!/bin/bash
echo "analysis start!"
echo "-------------------------"
iverilog *.v
RET=$?

echo "returned: "$RET

echo "analysis done!"
echo "-------------------------"

zero=0

if [ "$RET" -eq "$zero" ]
then
        ./a.out
fi
