#!/usr/bin/env bash
set -e

STRATEGIES=(
  "no-eager"
  "just-post"
  "light"
  "full"
  "profile-full"
  "profile-light"
  "profile-image-full"
  "profile-image-light"
)

RESULTS=()

echo "Running isolated benchmarks…"
echo "----------------------------------------------"
echo

for STRATEGY in "${STRATEGIES[@]}"; do
  echo "→ Strategy: $STRATEGY"

  # Run isolated Rails process
  OUTPUT=$(rails runner ./script/isolated_request.rb "$STRATEGY")

  # Print raw output to the terminal
  echo "$OUTPUT"
  echo

  # Extract numbers for the summary table
  TIME=$(echo "$OUTPUT" | grep "Time:" | awk '{print $2}')
  OBJECTS=$(echo "$OUTPUT" | grep "Objects:" | awk '{print $2}')
  STATUS=$(echo "$OUTPUT" | grep "Status:" | awk '{print $2}')

  RESULTS+=("$STRATEGY|$TIME|$OBJECTS|$STATUS")
done

echo
echo "============== Benchmark Summary =============="
printf "%-22s %-12s %-12s %-8s\n" "Strategy" "Time(s)" "Objects" "Status"
echo "---------------------------------------------------------------"

for LINE in "${RESULTS[@]}"; do
  IFS="|" read -r STRATEGY TIME OBJECTS STATUS <<< "$LINE"
  printf "%-22s %-12s %-12s %-8s\n" "$STRATEGY" "$TIME" "$OBJECTS" "$STATUS"
done

echo "---------------------------------------------------------------"
echo "Done."
