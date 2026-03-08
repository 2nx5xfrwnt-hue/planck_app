#!/bin/bash

# Configuration
DIR="/Users/r_chr/plank_app/assets/audio"
mkdir -p "$DIR"

# Quantum Computing Voiceovers
say -v "Daniel" -o "${DIR}/tmp_qc1.aiff" "Normal computers use bits: 1s and 0s. They process information one step at a time."
afconvert -f m4af -d aac "${DIR}/tmp_qc1.aiff" "${DIR}/voiceover_qc_1.m4a"

say -v "Daniel" -o "${DIR}/tmp_qc2.aiff" "Quantum computers use qubits. Thanks to superposition, a qubit can be 1, 0, or both simultaneously."
afconvert -f m4af -d aac "${DIR}/tmp_qc2.aiff" "${DIR}/voiceover_qc_2.m4a"

say -v "Daniel" -o "${DIR}/tmp_qc3.aiff" "This allows quantum computers to process a massive number of possibilities in parallel, rather than sequentially."
afconvert -f m4af -d aac "${DIR}/tmp_qc3.aiff" "${DIR}/voiceover_qc_3.m4a"

say -v "Daniel" -o "${DIR}/tmp_qc4.aiff" "By entangling qubits, they form complex logic gates capable of factoring massive numbers in seconds—a task that would take a normal computer millions of years."
afconvert -f m4af -d aac "${DIR}/tmp_qc4.aiff" "${DIR}/voiceover_qc_4.m4a"

# String Theory Voiceovers
say -v "Daniel" -o "${DIR}/tmp_st1.aiff" "The Standard Model of particle physics is incredibly accurate, but it's missing something huge: Gravity."
afconvert -f m4af -d aac "${DIR}/tmp_st1.aiff" "${DIR}/voiceover_st_1.m4a"

say -v "Daniel" -o "${DIR}/tmp_st2.aiff" "To bridge the gap between quantum mechanics and relativity, String Theory proposes a radical idea."
afconvert -f m4af -d aac "${DIR}/tmp_st2.aiff" "${DIR}/voiceover_st_2.m4a"

say -v "Daniel" -o "${DIR}/tmp_st3.aiff" "Instead of point-like particles, imagine the fundamental ingredients of the universe are tiny, vibrating, one-dimensional strings."
afconvert -f m4af -d aac "${DIR}/tmp_st3.aiff" "${DIR}/voiceover_st_3.m4a"

say -v "Daniel" -o "${DIR}/tmp_st4.aiff" "Just as different vibrations on a guitar string produce different musical notes, different vibrations of these quantum strings produce different particles."
afconvert -f m4af -d aac "${DIR}/tmp_st4.aiff" "${DIR}/voiceover_st_4.m4a"

say -v "Daniel" -o "${DIR}/tmp_st5.aiff" "The catch? For the math to work, the universe must have at least 11 dimensions, most of them curled up so tightly we can't perceive them."
afconvert -f m4af -d aac "${DIR}/tmp_st5.aiff" "${DIR}/voiceover_st_5.m4a"

rm "${DIR}"/*.aiff
echo "done"
