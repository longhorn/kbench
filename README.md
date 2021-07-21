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

### Tweak the options

For official benchmarking:
1. `SIZE` environmental variable: the size should be **at least 25 times the read/write bandwidth** to avoid the caching impacting the result.
1. If you're testing a distributed storage solution like Longhorn, always **test against the local storage first** to know what's the baseline.
    * You can install a storage provider for local storage like [Local Path Provisioner](https://github.com/rancher/local-path-provisioner) for this test if you're testing with Kubernetes.

### Understanding the result
* **IOPS**: IO operations per second.
    * It's a measurement of how many IO operations can the device handle in a second, mainly concerning the smaller IO chunks, e.g. 4k.
* **Bandwidth**: Also called **throughput**.
    * It's a measurement of how many data can the device read/write in a second. It's mainly concering the bigger IO chunks, e.g. 128k.
* **CPU Idleness**: How idle is the CPU on the node that's running the test.
    * It's a measurement of the CPU load/overhead that the storage device has generated.
    * Notice this is idleness, so if the value is higher, it means the CPUs on that node have more free cycles.
    * Unforunately at this moment, this measurement cannot reflect the load on the whole cluster for distributed storage systems. But it's still a worthy reference regarding the storage client's CPU load when benchmarking (depends on how distributed storage was architected).

### Understanding the result of a distributed storage system

For a distributed storage system, you always need to test the local storage first as a baseline.

Something is *wrong* when:
1. You're getting **lower read latency** than local storage.
	* You might get higher read IOPS/bandwidth than local storage due to the storage engines can aggregate performance from different nodes/disks. But you shouldn't be able to get lower latency on reading compare to the local storage.
	* If that happens, it's most likely due to there is a cache. Increase the `SIZE` to avoid that.
1. You're getting **better write IOPS/bandwidth/latency** than local storage.
	* It's almost impossible to get better write performance compare to the local storage for a distributed storage solution, unless you have a persistent caching device in front of the local storage.
	* If you are getting this result, it's likely the storage solution is not crash-consistent, so it doesn't commit the data into the disk before respond, which means in the case of an incident, you might lose data.
1. You're getting low **CPU Idleness** for **latency benchmark** , e.g. <40%.
	* For **latency benchmark**, the CPU Idleness should be at least 40% to guarantee the test won't be impacted by CPU starving.
	* If this happens, adding more CPUs to the node, or move to a beefer machine.

### Deploy in Kubernetes cluster

By default:
1. The benchmark will use the **default storage class**.
    * You can specify the storage class with the YAML locally.
2. **Filesystem mode** will be used.
    * You can switch to the block mode with the YAML locally.
3. The test requires a **3G** PVC temporarily.
    * You can change the test size with the YAML locally.

One line to start benchmarking your default storage class:
```
kubectl apply -f https://raw.githubusercontent.com/longhorn/benchmark/main/deploy/fio.yaml
```

Get Result:
```
kubectl logs -l benchmark=fio -f
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
