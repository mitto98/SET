#!/bin/bash

# declare -r var=value
# var is a readonly variable
declare -r tcp_throughput="../data/tcp_throughput.dat"
declare -r udp_throughput="../data/udp_throughput.dat"

# declare -a var
# var is an array
declare -a first_line
declare -a last_line

# declare -i var
# var is an integer
declare -i n1
declare -i n2

declare -a tn1
declare -a tn2

declare -a dn1
declare -a dn2

declare -a L0
declare -a B

first_line="$(head -n 1 ${tcp_throughput})"
last_line="$(tail -n 1 ${tcp_throughput})"

n1=`echo "$first_line" | awk -F" " '{print $1}'`
n2=`echo "$last_line" | awk -F" " '{print $1}'`

tn1=`echo "$first_line" | awk -F" " '{print $3}'`
tn2=`echo "$last_line" | awk -F" " '{print $3}'`

#dn = n / tn
dn1=`echo "$n1/$tn1" | bc -l`
dn2=`echo "$n2/$tn2" | bc -l`

# B = (N2-N1) / (DN2-DN1)
B=`echo "($n2-$n1)/($dn2-$dn1)" | bc -l`
#L0 = (DN1*N2 - DN2*N1) / N2-N1
L0=`echo "($dn1*$n2-$dn2*$n1)/($n2-$n1)" | bc -l`

gnuplot <<-eNDtCPgNUPLOTcOMMAND
    set term png size 1024, 700
    set output "../data/latencyBandwidth-tcp.png"
    set logscale x 2
    set logscale y 10
    set xlabel "msg size (B)"
    set ylabel "throughput (KB/s)"
    lbf(x) = x / ( $L0 + x / $B )
    plot "$tcp_throughput" using 1:3 title "tcp ping-pong Throughput" with linespoints, \
        lbf(x) title "Latency-Bandwidth model with L=$L0 and B=$B" with linespoints
eNDtCPgNUPLOTcOMMAND

first_line="$(head -n 1 ${udp_throughput})"
last_line="$(tail -n 1 ${udp_throughput})"

n1=`echo "$first_line" | awk -F" " '{print $1}'`
n2=`echo "$last_line" | awk -F" " '{print $1}'`

tn1=`echo "$first_line" | awk -F" " '{print $3}'`
tn2=`echo "$last_line" | awk -F" " '{print $3}'`

dn1=`echo "$n1/$tn1" | bc -l`
dn2=`echo "$n2/$tn2" | bc -l`

B=`echo "($n2-$n1)/($dn2-$dn1)" | bc -l`
L0=`echo "($dn1*$n2-$dn2*$n1)/($n2-$n1)" | bc -l`

gnuplot <<-eNDuDPgNUPLOTcOMMAND
    set term png size 1024, 700
    set output "../data/latencyBandwidth-udp.png"
    set logscale x 2
    set logscale y 10
    set xlabel "msg size (B)"
    set ylabel "throughput (KB/s)"
    lbf(x) = x / ( $L0 + x / $B )
    plot "$udp_throughput" using 1:3 title "udp ping-pong Throughput" with linespoints, \
        lbf(x) title "Latency-Bandwidth model with L=$L0 and B=$B with linespoints"
eNDuDPgNUPLOTcOMMAND