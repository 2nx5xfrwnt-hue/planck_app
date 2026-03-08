import json
import os
import math

# A slightly more complex wave and particle effect
lottie_data = {
    "v": "5.7.4",
    "fr": 30,
    "ip": 0,
    "op": 120,
    "w": 300,
    "h": 300,
    "nm": "Wave Particle Duality",
    "ddd": 0,
    "assets": [],
    "layers": [
        # The Particle Layer (A pulsing dot)
        {
            "ddd": 0,
            "ind": 1,
            "ty": 4,
            "nm": "Particle",
            "sr": 1,
            "ks": {
                "o": {"a": 1, "k": [{"i": {"x": [0.833], "y": [0.833]}, "o": {"x": [0.167], "y": [0.167]}, "t": 0, "s": [0]}, {"i": {"x": [0.833], "y": [0.833]}, "o": {"x": [0.167], "y": [0.167]}, "t": 60, "s": [100]}, {"t": 120, "s": [0]}]},
                "r": {"a": 0, "k": 0, "ix": 10},
                "p": {"a": 0, "k": [150, 150, 0], "ix": 2},
                "a": {"a": 0, "k": [0, 0, 0], "ix": 1},
                "s": {"a": 0, "k": [100, 100, 100], "ix": 6}
            },
            "ao": 0,
            "shapes": [
                {
                    "ty": "el",
                    "d": 1,
                    "p": {"a": 0, "k": [0, 0]},
                    "s": {"a": 1, "k": [{"i": {"x": [0.833, 0.833], "y": [0.833, 0.833]}, "o": {"x": [0.167, 0.167], "y": [0.167, 0.167]}, "t": 0, "s": [0, 0]}, {"i": {"x": [0.833, 0.833], "y": [0.833, 0.833]}, "o": {"x": [0.167, 0.167], "y": [0.167, 0.167]}, "t": 60, "s": [60, 60]}, {"t": 120, "s": [0, 0]}]},
                    "nm": "Ellipse Path 1",
                    "hd": False
                },
                {
                    "ty": "fl",
                    "c": {"a": 0, "k": [1, 0.2, 0.6, 1], "ix": 4},
                    "o": {"a": 0, "k": 100, "ix": 5},
                    "r": 1,
                    "bm": 0,
                    "nm": "Fill 1",
                    "hd": False
                }
            ],
            "ip": 0,
            "op": 120,
            "st": 0,
            "bm": 0
        },
        # The Wave Layer (Expanding ripples)
        {
            "ddd": 0,
            "ind": 2,
            "ty": 4,
            "nm": "Wave Ripples",
            "sr": 1,
            "ks": {
                "o": {"a": 1, "k": [{"i": {"x": [0.833], "y": [0.833]}, "o": {"x": [0.167], "y": [0.167]}, "t": 0, "s": [100]}, {"i": {"x": [0.833], "y": [0.833]}, "o": {"x": [0.167], "y": [0.167]}, "t": 60, "s": [0]}, {"t": 120, "s": [100]}]},
                "r": {"a": 0, "k": 0, "ix": 10},
                "p": {"a": 0, "k": [150, 150, 0], "ix": 2},
                "a": {"a": 0, "k": [0, 0, 0], "ix": 1},
                "s": {"a": 0, "k": [100, 100, 100], "ix": 6}
            },
            "ao": 0,
            "shapes": [
                {
                    "ty": "el",
                    "d": 1,
                    "p": {"a": 0, "k": [0, 0]},
                    "s": {"a": 1, "k": [{"i": {"x": [0.833, 0.833], "y": [0.833, 0.833]}, "o": {"x": [0.167, 0.167], "y": [0.167, 0.167]}, "t": 0, "s": [60, 60]}, {"i": {"x": [0.833, 0.833], "y": [0.833, 0.833]}, "o": {"x": [0.167, 0.167], "y": [0.167, 0.167]}, "t": 60, "s": [280, 280]}, {"t": 120, "s": [60, 60]}]},
                    "nm": "Ellipse Path 1",
                    "hd": False
                },
                {
                    "ty": "st",
                    "c": {"a": 0, "k": [0, 0.941, 1, 1], "ix": 3},
                    "o": {"a": 0, "k": 100, "ix": 4},
                    "w": {"a": 0, "k": 6, "ix": 5},
                    "lc": 1,
                    "lj": 1,
                    "ml": 4,
                    "bm": 0,
                    "nm": "Stroke 1",
                    "hd": False
                }
            ],
            "ip": 0,
            "op": 120,
            "st": 0,
            "bm": 0
        }
    ]
}

os.makedirs('/Users/r_chr/plank_app/assets/animations', exist_ok=True)
with open('/Users/r_chr/plank_app/assets/animations/wave_particle.json', 'w') as f:
    json.dump(lottie_data, f)

print("Wave Particle json created.")
