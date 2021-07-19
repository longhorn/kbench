# Benchmark

Various benchmark for storage and Kubernetes.

## FIO

Usage:
```
cd fio
./run.sh <testfile> <output_prefix>
./parse.sh <output_prefix>
```

E.g.
```
cd ./fio
sudo ./run.sh /dev/longhorn/vol ~/fio-results/longhorn-1.2.0-single-local-replica
sudo ./parse.sh ~/fio-results/longhorn-1.2.0-single-local-replica
```

Output example
```
=====================
FIO Benchmark Summary
For: /xxx/fio-results/longhorn-1.2.0-single-local-replica
=====================

Random Read/Write
IOPS:             14,332  / 11,301
Bandwidth:        524,714 KiB/sec   / 356,155 KiB/sec
Average Latency:  463,826 ns  / 474,780 ns

Sequential Read/Write
IOPS:             14,342 / 11,369
Bandwidth:        525,421 KiB/sec   / 356,420 KiB/sec
Average Latency:  440,954 ns  / 473,654 ns

CPU Idleness: 59%
```

The test result will be printed out as well as saved into `~/fio-results/longhorn-1.2.0-single-local-replica.summary`

Note: the benchmark for FIO will take about 6 minutes to finish.
