#!/bin/bash

# Configuration
DIR="/Users/r_chr/plank_app/assets/audio"
mkdir -p "$DIR"

# Heisenberg Voiceovers
say -v "Daniel" -o "${DIR}/tmp1.aiff" "Imagine trying to take a crystal-clear photo of a race car speeding by."
afconvert -f m4af -d aac "${DIR}/tmp1.aiff" "${DIR}/voiceover_hu_1.m4a"

say -v "Daniel" -o "${DIR}/tmp2.aiff" "If you use a fast shutter speed, the car is sharp, but you can't tell how fast it's moving."
afconvert -f m4af -d aac "${DIR}/tmp2.aiff" "${DIR}/voiceover_hu_2.m4a"

say -v "Daniel" -o "${DIR}/tmp3.aiff" "If you use a slow shutter speed, you see the blur of its motion, but you don't know exactly where it is."
afconvert -f m4af -d aac "${DIR}/tmp3.aiff" "${DIR}/voiceover_hu_3.m4a"

say -v "Daniel" -o "${DIR}/tmp4.aiff" "Werner Heisenberg figured out this isn't just a camera problem. It's a built-in limit of the universe."
afconvert -f m4af -d aac "${DIR}/tmp4.aiff" "${DIR}/voiceover_hu_4.m4a"

say -v "Daniel" -o "${DIR}/tmp5.aiff" "The more precisely you know a particle's position, the less you know about its momentum. And vice versa."
afconvert -f m4af -d aac "${DIR}/tmp5.aiff" "${DIR}/voiceover_hu_5.m4a"

# Quantum Tunneling Voiceovers
say -v "Daniel" -o "${DIR}/tmp_qt1.aiff" "Imagine rolling a ball up a hill. If it doesn't have enough energy, it rolls back down. Simple physics."
afconvert -f m4af -d aac "${DIR}/tmp_qt1.aiff" "${DIR}/voiceover_qt_1.m4a"

say -v "Daniel" -o "${DIR}/tmp_qt2.aiff" "But in the quantum world, particles don't always play by those rules."
afconvert -f m4af -d aac "${DIR}/tmp_qt2.aiff" "${DIR}/voiceover_qt_2.m4a"

say -v "Daniel" -o "${DIR}/tmp_qt3.aiff" "Sometimes, a particle facing an impenetrable barrier will just... pop out on the other side."
afconvert -f m4af -d aac "${DIR}/tmp_qt3.aiff" "${DIR}/voiceover_qt_3.m4a"

say -v "Daniel" -o "${DIR}/tmp_qt4.aiff" "It didn't go over. It didn't break the wall. It tunneled through. It essentially borrowed energy from the universe, just for a moment."
afconvert -f m4af -d aac "${DIR}/tmp_qt4.aiff" "${DIR}/voiceover_qt_4.m4a"

say -v "Daniel" -o "${DIR}/tmp_qt5.aiff" "This isn't just theory. It's why the sun shines. It's how your flash drive works. The impossible happens constantly."
afconvert -f m4af -d aac "${DIR}/tmp_qt5.aiff" "${DIR}/voiceover_qt_5.m4a"

rm "${DIR}"/*.aiff
echo "done"
