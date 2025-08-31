#!/bin/bash
cd /home/kato/work/LLM_Voice_Flow

echo "配置所有CMake模块..."

# 配置zmq-comm-kit
echo "=== 配置 zmq-comm-kit ==="
cd zmq-comm-kit
mkdir -p build && cd build
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
      -DCMAKE_C_COMPILER=/usr/bin/gcc \
      -DCMAKE_CXX_COMPILER=/usr/bin/g++ \
      ..
cd ../..

# 配置TTS
echo "=== 配置 TTS ==="
cd tts
mkdir -p build && cd build  
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
      -DCMAKE_C_COMPILER=/usr/bin/gcc \
      -DCMAKE_CXX_COMPILER=/usr/bin/g++ \
      ..
cd ../..

# 配置sherpa-onnx
echo "=== 配置 sherpa-onnx ==="
cd voice/sherpa-onnx
mkdir -p build && cd build
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
      -DCMAKE_C_COMPILER=/usr/bin/gcc \
      -DCMAKE_CXX_COMPILER=/usr/bin/g++ \
      -DSHERPA_ONNX_ENABLE_PORTAUDIO=ON \
      -DBUILD_SHARED_LIBS=ON \
      ..
cd ../../..

echo "=== 合并compile_commands.json ==="
# 合并所有compile_commands.json
python3 -c "
import json
import os

all_commands = []
files = [
    'zmq-comm-kit/build/compile_commands.json',
    'tts/build/compile_commands.json', 
    'voice/sherpa-onnx/build/compile_commands.json'
]

for file in files:
    if os.path.exists(file):
        print(f'Loading: {file}')
        with open(file) as f:
            all_commands.extend(json.load(f))

with open('compile_commands.json', 'w') as f:
    json.dump(all_commands, f, indent=2)

print(f'Merged {len(all_commands)} compile commands')
"

echo "配置完成！重启VSCode让配置生效。"
