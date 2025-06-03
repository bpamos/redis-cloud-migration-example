#!/bin/bash
ENDPOINT="$1"

memtier_benchmark \
  -s "$ENDPOINT" \
  -p 6379 \
  --protocol redis \
  --clients=50 \
  --threads=2 \
  --test-time=60
