import src/zippy
import std/random, std/strutils

proc test(name: string, data: string) =
  echo "Testing ", name, " (", data.len, " bytes)"
  try:
    # Test different compression levels
    for level in [-2, -1, 1, 2, 6, 9]:
      let 
        compressed = compress(data, level = level, dataFormat = dfDeflate64)
        decompressed = uncompress(compressed, dfDeflate64)
      
      if decompressed != data:
        echo "  FAILED at level ", level, ": data mismatch"
        return
      else:
        echo "  Level ", level, ": OK (", compressed.len, " bytes compressed)"
    
    # Test vs standard deflate for comparison
    let 
      deflate64 = compress(data, level = 6, dataFormat = dfDeflate64)
      deflateStd = compress(data, level = 6, dataFormat = dfDeflate)
    echo "  Deflate64 vs Deflate: ", deflate64.len, " vs ", deflateStd.len, " bytes"
    
  except Exception as e:
    echo "  FAILED: ", e.msg
    return
  
  echo "  SUCCESS: All levels passed"

# Test various data types
echo "=== Comprehensive Deflate64 Tests ==="
echo ""

# Simple text
test("Simple text", "Hello, World! This is a test string for deflate64 compression.")

# Highly repetitive data (good for compression)
test("Repetitive data", "A".repeat(1000))

# Mixed repetitive pattern  
test("Mixed pattern", ("Hello World! " & "X".repeat(50) & "\n").repeat(20))

# Random data (hard to compress)
randomize(123)
var randomData = ""
for i in 0..2000:
  randomData.add(char(rand(255)))
test("Random data", randomData)

# Empty string
test("Empty string", "")

# Single character
test("Single char", "A")

# Long uniform data
test("Long zeros", "\x00".repeat(5000))

# Text with patterns
let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ".repeat(100)
test("Lorem ipsum", loremIpsum)

# Binary-like data with some patterns
var binaryData = ""
for i in 0..1000:
  binaryData.add(char(i mod 256))
  if i mod 100 == 0:
    binaryData.add("PATTERN".repeat(10))
test("Binary with patterns", binaryData)

echo ""
echo "=== All Deflate64 Tests Complete ==="