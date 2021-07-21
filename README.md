# Benchmark

Various benchmark for storage and Kubernetes.

## FIO

### Example Result
```
=====================
FIO Benchmark Summary
For: ./fio-results/Samsung_850_PRO_512GB/raw-block
SIZE: 10g
QUICK MODE: DISABLED
=====================

IOPS (Read/Write):
Random:         89,777  / 83,867
Sequential:     105,151 / 107,256
CPU Idleness:   68%

Bandwidth (Read/Write):
Random:         512,205 KiB/sec / 478,912 KiB/sec
Sequential:     519,303 KiB/sec / 522,566 KiB/sec
CPU Idleness:   98%

Latency (Read/Write):
Random:         114,095 ns / 44,515 ns
Sequential:     40,634 ns / 45,024 ns
CPU Idleness:   74%
```

Note: the benchmark for FIO will take about 6 minutes to finish.

#### Understanding the result

* **CPU Idleness** indicates how busy is the CPU on the node that's running the test. And it doesn't reflect the load on the whole cluster for distributed storage systems.
* For **latency test**, the CPU Idleness should be at least 40% to guarantee the test won't be impacted by CPU starving.

### Deploy in Kubernetes cluster

By default, the benchmark will use the default storage class with filesystem mode to create a PVC for FIO testing.

Start:
```
kubectl apply -f https://raw.githubusercontent.com/longhorn/benchmark/main/deploy/fio.yaml
```

Get Result:
```
kubectl logs -l benchmark=fio
```

Cleanup:
```
kubectl delete -f https://raw.githubusercontent.com/longhorn/benchmark/main/deploy/fio.yaml
```

See [./deploy/fio.yaml](https://github.com/longhorn/benchmark/blob/main/deploy/fio.yaml) for available options.

### Run as container locally

```
docker run -v /volume longhornio/benchmark:latest /volume/test.img
```
e.g.
```
docker run -e "SIZE=100M" -v /volume longhornio/benchmark:latest /volume/test.img
```

### Run as a binary locally

Notice in this case, `fio` is required locally.

```
./fio/run.sh <test_file> <output_prefix>
```
e.g.
```
./fio/run.sh /dev/sdaxxx ~/fio-results/Samsung_850_PRO_512GB/raw-bloc
```

Intermediate result will be saved into `<output_prefix>-iops.json`, `<output_prefix>-bandwidth.json` and `<output_prefix>-latency.json`.
The output will be printed out as well as saved into `<output_prefix>.summary`.

## License

Copyright (c) 2014-2021 The Longhorn Authors

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
