#!/bin/bash
echo "analysis start!"
echo "-------------------------"
iverilog *.v
RET=$?
echo "returned: "$RET

echo "analysis done!"
echo "-------------------------"
./a.out
