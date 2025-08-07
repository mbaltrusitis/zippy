import src/zippy

# Simple test for deflate64 compression/decompression
let testData = "Hello, World! This is a test string for deflate64 compression."

try:
  # Test basic deflate64 compression
  echo "Testing deflate64 compression..."
  let compressed = compress(testData, level = 6, dataFormat = dfDeflate64)
  echo "Compressed size: ", compressed.len
  
  # Test deflate64 decompression
  echo "Testing deflate64 decompression..."
  let decompressed = uncompress(compressed, dfDeflate64)
  echo "Decompressed: ", decompressed
  
  if decompressed == testData:
    echo "SUCCESS: Deflate64 roundtrip test passed!"
  else:
    echo "FAILURE: Data mismatch"
    
except Exception as e:
  echo "ERROR: ", e.msg