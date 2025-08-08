## Shared compression utilities for deflate and deflate64
## Reduces code duplication between standard deflate and deflate64 implementations

import common

# Shared buffer management utilities
template ensureCapacity*(buffer: var seq[uint16], requiredSize: int) =
  ## Ensures the buffer has at least requiredSize capacity
  if buffer.len < requiredSize:
    buffer.setLen(max(buffer.len * 2, requiredSize))

template addToBuffer*(buffer: var seq[uint16], pos: var int, value: uint16) =
  ## Safely adds a value to the buffer at the given position
  if pos >= buffer.len:
    buffer.setLen(max(buffer.len * 2, pos + 1))
  buffer[pos] = value
  inc pos

# Common hash and window calculations
proc rollingHash*(data: ptr UncheckedArray[uint8], pos: int): uint32 {.inline.} =
  ## Compute rolling hash for LZ77 match finding
  # Simple hash function used by both deflate variants
  result = (data[pos].uint32 shl 8) xor (data[pos + 1].uint32 shl 4) xor data[pos + 2].uint32
  result = result and 0x7FFF # Keep it within reasonable bounds

proc distanceCodeIndex*(distance: uint16): uint16 =
  ## Shared distance code calculation for both deflate and deflate64
  ## Returns the code index for a given distance
  if distance <= 4:
    distance - 1
  else:
    var 
      code = 2.uint16
      bits = 1.uint16
      value = 5.uint16
    
    while value <= distance:
      if distance < value + (1.uint16 shl bits):
        return code
      code += (1.uint16 shl bits)
      value += (1.uint16 shl bits)
      if bits < 13:
        inc bits
    
    min(code, 29) # Clamp to valid range

# Memory copy optimization helpers  
template copy64*(dst, src: ptr UncheckedArray[uint8], dstPos, srcPos: int) =
  ## Optimized 8-byte memory copy used in inflation
  when defined(amd64):
    cast[ptr uint64](dst[dstPos].addr)[] = cast[ptr uint64](src[srcPos].addr)[]
  else:
    # Fallback for other architectures
    copyMem(dst[dstPos].addr, src[srcPos].addr, 8)

# Validation helpers
proc validateCompressionLevel*(level: int) =
  ## Validates compression level is within acceptable range
  if level < -2 or level > 9:
    raise newException(ZippyError, "Invalid compression level " & $level)

proc validateBufferBounds*(pos, len: int, context: string = "buffer operation") =
  ## Validates buffer position is within bounds
  if pos < 0 or pos >= len:
    raise newException(ZippyError, "Buffer bounds error in " & context & ": " & $pos & " >= " & $len)

# Performance measurement helpers for debugging
when defined(release):
  template measureTime*(name: string, code: untyped) =
    ## No-op in release builds
    code
else:
  import std/times
  template measureTime*(name: string, code: untyped) =
    ## Measure execution time in debug builds
    let start = cpuTime()
    code
    let elapsed = cpuTime() - start
    when defined(verbose):
      echo name, ": ", int(elapsed * 1000000), "μs"