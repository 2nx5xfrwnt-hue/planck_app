import json
import os

lottie_data = {
    "v": "5.5.2",
    "fr": 30,
    "ip": 0,
    "op": 60,
    "w": 300,
    "h": 300,
    "nm": "Placeholder Wave",
    "ddd": 0,
    "assets": [],
    "layers": [
        {
            "ddd": 0,
            "ind": 1,
            "ty": 4,
            "nm": "Wave Path",
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
                    "ty": "sh",
                    "ix": 1,
                    "nm": "Wave",
                    "hd": False,
                    "ks": {
                        "a": 1,
                        "k": [
                            {
                                "i": {"x": 0.833, "y": 0.833},
                                "o": {"x": 0.167, "y": 0.167},
                                "t": 0,
                                "s": [{"i": [[0, 0], [25, -25], [25, 25], [0, 0]], "o": [[0, 0], [-25, 25], [-25, -25], [0, 0]], "v": [[-100, 0], [-50, 0], [50, 0], [100, 0]], "c": False}]
                            },
                            {
                                "t": 30,
                                "s": [{"i": [[0, 0], [25, 25], [25, -25], [0, 0]], "o": [[0, 0], [-25, -25], [-25, 25], [0, 0]], "v": [[-100, 0], [-50, 0], [50, 0], [100, 0]], "c": False}]
                            },
                            {
                                "t": 60,
                                "s": [{"i": [[0, 0], [25, -25], [25, 25], [0, 0]], "o": [[0, 0], [-25, 25], [-25, -25], [0, 0]], "v": [[-100, 0], [-50, 0], [50, 0], [100, 0]], "c": False}]
                            }
                        ],
                        "ix": 2
                    }
                },
                {
                    "ty": "st",
                    "c": {"a": 0, "k": [0, 0.941, 1, 1], "ix": 3},
                    "o": {"a": 0, "k": 100, "ix": 4},
                    "w": {"a": 0, "k": 4, "ix": 5},
                    "lc": 2,
                    "lj": 2,
                    "nm": "Stroke 1",
                    "hd": False
                }
            ],
            "ip": 0,
            "op": 60,
            "st": 0,
            "bm": 0
        }
    ]
}

os.makedirs('/Users/r_chr/planck_app/assets/animations', exist_ok=True)
with open('/Users/r_chr/planck_app/assets/animations/placeholder.json', 'w') as f:
    json.dump(lottie_data, f)

print("Lottie JSON generated successfully.")
