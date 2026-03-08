import json
import os

lottie_data = {
    "v": "5.7.4",
    "fr": 30,
    "ip": 0,
    "op": 90,
    "w": 300,
    "h": 300,
    "nm": "Schrodingers Cat",
    "ddd": 0,
    "assets": [],
    "layers": [
        # Box Outline
        {
            "ddd": 0,
            "ind": 1,
            "ty": 4,
            "nm": "Box",
            "sr": 1,
            "ks": {
                "o": {"a": 0, "k": 100, "ix": 11},
                "r": {"a": 0, "k": 0, "ix": 10},
                "p": {"a": 0, "k": [150, 150, 0], "ix": 2},
                "a": {"a": 0, "k": [0, 0, 0], "ix": 1},
                "s": {"a": 0, "k": [100, 100, 100], "ix": 6}
            },
            "ao": 0,
            "shapes": [
                {
                    "ty": "rc",
                    "d": 1,
                    "s": {"a": 0, "k": [150, 150]},
                    "p": {"a": 0, "k": [0, 0]},
                    "r": {"a": 0, "k": 10},
                    "nm": "Rectangle Path 1",
                    "hd": False
                },
                {
                    "ty": "st",
                    "c": {"a": 0, "k": [0.8, 0.8, 0.8, 1], "ix": 3},
                    "o": {"a": 0, "k": 100, "ix": 4},
                    "w": {"a": 0, "k": 4, "ix": 5},
                    "lc": 1,
                    "lj": 1,
                    "ml": 4,
                    "bm": 0,
                    "nm": "Stroke 1",
                    "hd": False
                }
            ],
            "ip": 0,
            "op": 90,
            "st": 0,
            "bm": 0
        },
        # Question Mark (Superposition)
        {
            "ddd": 0,
            "ind": 2,
            "ty": 4,
            "nm": "Question Mark",
            "sr": 1,
            "ks": {
                "o": {"a": 1, "k": [{"i": {"x": [0.833], "y": [0.833]}, "o": {"x": [0.167], "y": [0.167]}, "t": 0, "s": [20]}, {"i": {"x": [0.833], "y": [0.833]}, "o": {"x": [0.167], "y": [0.167]}, "t": 45, "s": [100]}, {"t": 90, "s": [20]}]},
                "r": {"a": 0, "k": 0, "ix": 10},
                "p": {"a": 0, "k": [150, 150, 0], "ix": 2},
                "a": {"a": 0, "k": [0, 0, 0], "ix": 1},
                "s": {"a": 0, "k": [100, 100, 100], "ix": 6}
            },
            "ao": 0,
            "shapes": [
                {
                    "ty": "sh",
                    "ix": 1,
                    "nm": "Unknown",
                    "hd": False,
                    "ks": {
                        "a": 0,
                        "k": {
                            "i": [[0, 0], [0, -20], [20, 0], [0, 20], [-10, 0]],
                            "o": [[0, 0], [0, 20], [-20, 0], [0, -20], [10, 0]],
                            "v": [[0, 30], [20, -10], [0, -30], [-20, -10], [0, 10]],
                            "c": False
                        },
                        "ix": 2
                    }
                },
                {
                    "ty": "st",
                    "c": {"a": 1, "k": [{"i": {"x": [0.833], "y": [0.833]}, "o": {"x": [0.167], "y": [0.167]}, "t": 0, "s": [1, 0.2, 0.6, 1]}, {"i": {"x": [0.833], "y": [0.833]}, "o": {"x": [0.167], "y": [0.167]}, "t": 45, "s": [0, 0.94, 1, 1]}, {"t": 90, "s": [1, 0.2, 0.6, 1]}]},
                    "o": {"a": 0, "k": 100, "ix": 4},
                    "w": {"a": 0, "k": 8, "ix": 5},
                    "lc": 2,
                    "lj": 2,
                    "nm": "Stroke 1",
                    "hd": False
                }
            ],
            "ip": 0,
            "op": 90,
            "st": 0,
            "bm": 0
        }
    ]
}

os.makedirs('/Users/r_chr/planck_app/assets/animations', exist_ok=True)
with open('/Users/r_chr/planck_app/assets/animations/schrodingers_cat.json', 'w') as f:
    json.dump(lottie_data, f)
print("Cat json created.")
