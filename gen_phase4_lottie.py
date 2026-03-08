import json
import os

def create_lottie(filename, name, text):
    lottie_data = {
        "v": "5.7.4",
        "fr": 30,
        "ip": 0,
        "op": 90,
        "w": 300,
        "h": 300,
        "nm": name,
        "ddd": 0,
        "assets": [],
        "layers": [
            {
                "ddd": 0,
                "ind": 1,
                "ty": 4,
                "nm": text,
                "sr": 1,
                "ks": {
                    "o": {"a": 0, "k": 100},
                    "r": {"a": 0, "k": 0},
                    "p": {"a": 0, "k": [150, 150, 0]},
                    "a": {"a": 0, "k": [0, 0, 0]},
                    "s": {"a": 1, "k": [
                        {"t": 0, "s": [50, 50, 100]},
                        {"t": 45, "s": [120, 120, 100]},
                        {"t": 90, "s": [50, 50, 100]}
                    ]}
                },
                "ao": 0,
                "shapes": [
                    {
                        "ty": "el",
                        "d": 1,
                        "s": {"a": 0, "k": [100, 100]},
                        "p": {"a": 0, "k": [0, 0]},
                        "nm": "Ellipse Path 1",
                        "hd": False
                    },
                    {
                        "ty": "fl",
                        "c": {"a": 0, "k": [0.2, 0.8, 0.5, 1]},
                        "o": {"a": 0, "k": 100},
                        "r": 1,
                        "bm": 0,
                        "nm": "Fill 1",
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
    path = f'/Users/r_chr/planck_app/assets/animations/{filename}'
    with open(path, 'w') as f:
        json.dump(lottie_data, f)
    print(f"Created {path}")

os.makedirs('/Users/r_chr/planck_app/assets/animations', exist_ok=True)
create_lottie('heisenberg.json', 'Heisenberg Uncertainty', 'Particle')
create_lottie('quantum_tunneling.json', 'Quantum Tunneling', 'Tunneling')
