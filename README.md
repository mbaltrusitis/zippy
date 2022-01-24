# Zippy

![Github Actions](https://github.com/guzba/zippy/workflows/Github%20Actions/badge.svg)

`nimble install zippy`

Zippy is an implementation of [DEFLATE](https://tools.ietf.org/html/rfc1951), [ZLIB](https://tools.ietf.org/html/rfc1950) and [GZIP](https://tools.ietf.org/html/rfc1952) data compression formats. Zippy can also create and open [Tarballs](https://en.wikipedia.org/wiki/Tar_(computing)) (.tar, .tar.gz, .tgz, .taz) and [ZIP archives](https://en.wikipedia.org/wiki/Zip_(file_format)).

The goal of this library is to be a pure Nim implementation that is small, performant and dependency-free.

To ensure Zippy is compatible with other implementations, `tests/validate.nim` can be run. This script verifies that data compressed by Zippy can be uncompressed by other implementations (and that other implementations can uncompress data compressed by Zippy).

This library works well using Nim's relatively new `--gc:arc` and `--gc:orc` as well as the default garbage collector. This library also works using both `nim c` and `nim cpp`, in addition to `--cc:vcc` on Windows.

## Documentation

https://nimdocs.com/guzba/zippy/zippy.html

## Examples

Simple examples using Zippy can be found in the [examples/](https://github.com/guzba/zippy/blob/master/examples) folder.

* [HTTP client gzip](https://github.com/guzba/zippy/blob/master/examples/http_client.nim)
* [HTTP server gzip](https://github.com/guzba/zippy/blob/master/examples/http_server.nim)
* Compress a dir into a [tarball](https://github.com/guzba/zippy/blob/master/examples/tarball_create.nim) or [zip archive](https://github.com/guzba/zippy/blob/master/examples/ziparchive_create.nim)
* Extract from a [tarball](https://github.com/guzba/zippy/blob/master/examples/tarball_extract.nim) or [zip archive](https://github.com/guzba/zippy/blob/master/examples/ziparchive_extract.nim)
* Compose a [tarball](https://github.com/guzba/zippy/blob/master/examples/tarball_compose.nim) or [zip archive](https://github.com/guzba/zippy/blob/master/examples/ziparchive_compose.nim) in code

## Performance

Benchmarks can be run comparing different deflate implementations. My benchmarking shows this library performs very well, a bit faster than zlib in some cases and a bit slower in others. Check the performance yourself by running [tests/benchmark.nim](https://github.com/guzba/zippy/blob/master/tests/benchmark.nim).

`nim c --gc:arc -d:release -r .\tests\benchmark.nim`

The times below are measured on a Ryzen 5 5600X.

### Compress

Each file is compressed 10 times per run.

```
https://github.com/guzba/zippy compress [default]
name ............................... min time      avg time    std dv   runs
alice29.txt ....................... 26.484 ms     26.800 ms    ±0.308   x187
urls.10K ......................... 151.703 ms    153.162 ms    ±1.260    x33
rfctest3.gold ...................... 3.860 ms      3.923 ms    ±0.061  x1000
randtest3.gold ..................... 0.612 ms      0.626 ms    ±0.013  x1000
paper-100k.pdf .................... 10.562 ms     10.724 ms    ±0.198   x464
geo.protodata ...................... 6.395 ms      6.459 ms    ±0.074   x770
gzipfiletest.txt ................... 0.116 ms      0.118 ms    ±0.003  x1000
https://github.com/nim-lang/zip compress [default]
alice29.txt ....................... 58.134 ms     58.659 ms    ±0.632    x86
urls.10K ......................... 133.600 ms    135.877 ms    ±1.583    x37
rfctest3.gold ...................... 6.603 ms      6.694 ms    ±0.100   x743
randtest3.gold ..................... 0.891 ms      0.908 ms    ±0.016  x1000
paper-100k.pdf .................... 15.185 ms     15.308 ms    ±0.147   x326
geo.protodata ...................... 9.071 ms      9.206 ms    ±0.152   x541
gzipfiletest.txt ................... 0.120 ms      0.127 ms    ±0.009  x1000

https://github.com/guzba/zippy compress [best speed]
alice29.txt ........................ 7.776 ms      7.864 ms    ±0.119   x633
urls.10K .......................... 26.690 ms     26.945 ms    ±0.290   x186
rfctest3.gold ...................... 1.554 ms      1.652 ms    ±0.039  x1000
randtest3.gold ..................... 0.178 ms      0.180 ms    ±0.002  x1000
paper-100k.pdf ..................... 4.079 ms      4.175 ms    ±0.109  x1000
geo.protodata ...................... 2.690 ms      2.766 ms    ±0.067  x1000
gzipfiletest.txt ................... 0.055 ms      0.057 ms    ±0.004  x1000
https://github.com/nim-lang/zip compress [best speed]
alice29.txt ....................... 12.858 ms     13.128 ms    ±0.249   x380
urls.10K .......................... 53.738 ms     54.057 ms    ±0.348    x93
rfctest3.gold ...................... 2.196 ms      2.239 ms    ±0.030  x1000
randtest3.gold ..................... 0.816 ms      0.834 ms    ±0.018  x1000
paper-100k.pdf .................... 12.945 ms     13.054 ms    ±0.117   x382
geo.protodata ...................... 3.516 ms      3.576 ms    ±0.051  x1000
gzipfiletest.txt ................... 0.094 ms      0.098 ms    ±0.007  x1000

https://github.com/guzba/zippy compress [best compression]
alice29.txt ....................... 33.339 ms     33.615 ms    ±0.294   x149
urls.10K ......................... 229.325 ms    230.594 ms    ±1.206    x22
rfctest3.gold ...................... 9.100 ms      9.397 ms    ±0.230   x530
randtest3.gold ..................... 0.616 ms      0.628 ms    ±0.015  x1000
paper-100k.pdf .................... 10.989 ms     11.145 ms    ±0.137   x447
geo.protodata ...................... 7.128 ms      7.213 ms    ±0.111   x690
gzipfiletest.txt ................... 0.116 ms      0.118 ms    ±0.005  x1000
https://github.com/nim-lang/zip compress [best compression]
alice29.txt ....................... 86.257 ms     87.055 ms    ±0.809    x58
urls.10K ......................... 254.322 ms    256.679 ms    ±1.692    x20
rfctest3.gold ..................... 21.859 ms     22.216 ms    ±0.365   x225
randtest3.gold ..................... 0.890 ms      0.915 ms    ±0.028  x1000
paper-100k.pdf .................... 16.940 ms     17.165 ms    ±0.254   x291
geo.protodata ..................... 12.360 ms     12.529 ms    ±0.208   x398
gzipfiletest.txt ................... 0.120 ms      0.129 ms    ±0.011  x1000
```

### Uncompress

Each file is uncompressed 10 times per run.

```
https://github.com/guzba/zippy uncompress
alice29.txt.z ...................... 3.405 ms      3.475 ms    ±0.077  x1000
urls.10K.z ........................ 15.832 ms     16.154 ms    ±0.343   x308
rfctest3.z ......................... 0.737 ms      0.762 ms    ±0.017  x1000
randtest3.z ........................ 0.068 ms      0.069 ms    ±0.001  x1000
paper-100k.pdf.z ................... 2.678 ms      2.703 ms    ±0.037  x1000
geo.protodata.z .................... 1.191 ms      1.222 ms    ±0.013  x1000
https://github.com/nim-lang/zip uncompress
alice29.txt.z ...................... 3.531 ms      3.602 ms    ±0.064  x1000
urls.10K.z ........................ 15.045 ms     15.333 ms    ±0.328   x325
rfctest3.z ......................... 0.452 ms      0.486 ms    ±0.034  x1000
randtest3.z ........................ 0.065 ms      0.069 ms    ±0.006  x1000
paper-100k.pdf.z ................... 2.208 ms      2.246 ms    ±0.048  x1000
geo.protodata.z .................... 0.897 ms      0.926 ms    ±0.035  x1000
```

## Testing

`nimble test`

To prevent Zippy from causing a crash or otherwise misbehaving on bad input data, a fuzzer has been run against it. You can do run the fuzzer any time by running `nim c -r tests/fuzz.nim` and `nim c -r tests/stress.nim`
