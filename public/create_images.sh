#!/bin/bash
# Create placeholder images using ImageMagick or base64
for i in {1..5}; do
  # Create a simple colored rectangle as placeholder
  echo "Creating ${i}.jpg..."
  convert -size 640x480 xc:gray -pointsize 60 -fill white -gravity center -annotate +0+0 "检测图片 ${i}" /tmp/cc-agent/58793491/project/public/${i}.jpg 2>/dev/null || \
  cp /tmp/cc-agent/58793491/project/src/assets/检车员作业时未佩戴防护帽.jpg /tmp/cc-agent/58793491/project/public/${i}.jpg 2>/dev/null || \
  touch /tmp/cc-agent/58793491/project/public/${i}.jpg
done
