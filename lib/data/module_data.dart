class Module {
  final String id;
  final String title;
  final String description;
  final int requiredPoints;
  final List<CardData> cards;

  const Module({
    required this.id,
    required this.title,
    required this.description,
    required this.requiredPoints,
    required this.cards,
  });
}

class ModuleData {
  static final List<Module> modules = [
    const Module(
      id: "wave_particle",
      title: "Wave-Particle Duality",
      description: "Discover the universe's biggest secret.",
      requiredPoints: 0,
      cards: [
        CardData(
          text: "What are you made of? You feel solid, right? But the universe is hiding a massive secret.",
          isInteractive: false,
          animationPath: "assets/animations/wave_particle.json",
        ),
        CardData(
          text: "At the tiniest level, the stuff that makes up you acts like a solid little object AND a rippling wave. At the exact same time. Physicists call this Wave-Particle Duality.",
          isInteractive: false,
          animationPath: "assets/animations/wave_particle.json",
        ),
        CardData(
          text: "The craziest part? These things only act like solid dots when we look at them. If we look away, they act like waves.",
          isInteractive: false,
          animationPath: "assets/animations/wave_particle.json",
        ),
        CardData(
          text: "Ready to collapse the wave function?",
          isInteractive: true,
        ),
      ]
    ),
    const Module(
      id: "schrodingers_cat",
      title: "Schrödinger's Cat",
      description: "Is the cat alive, dead, or both?",
      requiredPoints: 10,
      cards: [
        CardData(
          text: "You've heard of Schrödinger's Cat, right? The most famous and morbid thought experiment in physics.",
          isInteractive: false,
          animationPath: "assets/animations/schrodingers_cat.json",
        ),
        CardData(
          text: "Imagine a cat in a box with a radioactive atom. If it decays, the cat dies. If not, the cat lives.",
          isInteractive: false,
          animationPath: "assets/animations/schrodingers_cat.json",
        ),
        CardData(
          text: "Common sense says the cat is EITHER alive OR dead. But quantum mechanics says until we look, the cat is BOTH. A state called Superposition.",
          isInteractive: false,
          animationPath: "assets/animations/schrodingers_cat.json",
        ),
        CardData(
          text: "The universe literally hasn't chosen an outcome yet. Your observation forces reality to pick a path.",
          isInteractive: false,
          animationPath: "assets/animations/schrodingers_cat.json",
        ),
        CardData(
          text: "Ready to open the box?",
          isInteractive: true,
        ),
      ]
    ),
    const Module(
      id: "quantum_entanglement",
      title: "Quantum Entanglement",
      description: "Einstein called it 'spooky action at a distance'.",
      requiredPoints: 20,
      cards: [
        CardData(
          text: "Albert Einstein called this 'spooky action at a distance.' And he absolutely hated it.",
          isInteractive: false,
          animationPath: "assets/animations/quantum_entanglement.json",
        ),
        CardData(
          text: "Two particles can become intimately linked. Measure one to be spinning up, the other is instantly spinning down.",
          isInteractive: false,
          animationPath: "assets/animations/quantum_entanglement.json",
        ),
        CardData(
          text: "It doesn't matter if they are an inch apart, or on opposite sides of the universe. The communication is instantaneous, faster than light.",
          isInteractive: false,
          animationPath: "assets/animations/quantum_entanglement.json",
        ),
        CardData(
          text: "They act as a single mathematical object. Space itself seems to not matter to them.",
          isInteractive: false,
          animationPath: "assets/animations/quantum_entanglement.json",
        ),
        CardData(
          text: "Entangle some particles!",
          isInteractive: true,
        ),
      ]
    ),
    const Module(
      id: "heisenberg_uncertainty",
      title: "Heisenberg Uncertainty",
      description: "You can't know everything at once.",
      requiredPoints: 30, // Keeping it progressive
      cards: [
        CardData(
          text: "Imagine trying to take a crystal-clear photo of a race car speeding by.",
          isInteractive: false,
          animationPath: "assets/animations/heisenberg.json",
        ),
        CardData(
          text: "If you use a fast shutter speed, the car is sharp, but you can't tell how fast it's moving.",
          isInteractive: false,
          animationPath: "assets/animations/heisenberg.json",
        ),
        CardData(
          text: "If you use a slow shutter speed, you see the blur of its motion, but you don't know exactly where it is.",
          isInteractive: false,
          animationPath: "assets/animations/heisenberg.json",
        ),
        CardData(
          text: "Werner Heisenberg figured out this isn't just a camera problem. It's a built-in limit of the universe.",
          isInteractive: false,
          animationPath: "assets/animations/heisenberg.json",
        ),
        CardData(
          text: "The more precisely you know a particle's position, the less you know about its momentum. And vice versa.",
          isInteractive: false,
          animationPath: "assets/animations/heisenberg.json",
        ),
        CardData(
          text: "Embrace the uncertainty.",
          isInteractive: true,
        ),
      ]
    ),
    const Module(
      id: "quantum_tunneling",
      title: "Quantum Tunneling",
      description: "Walking through walls is actually possible.",
      requiredPoints: 40,
      cards: [
        CardData(
          text: "Imagine rolling a ball up a hill. If it doesn't have enough energy, it rolls back down. Simple physics.",
          isInteractive: false,
          animationPath: "assets/animations/quantum_tunneling.json",
        ),
        CardData(
          text: "But in the quantum world, particles don't always play by those rules.",
          isInteractive: false,
          animationPath: "assets/animations/quantum_tunneling.json",
        ),
        CardData(
          text: "Sometimes, a particle facing an impenetrable barrier will just... pop out on the other side.",
          isInteractive: false,
          animationPath: "assets/animations/quantum_tunneling.json",
        ),
        CardData(
          text: "It didn't go over. It didn't break the wall. It tunneled through. It essentially borrowed energy from the universe, just for a moment.",
          isInteractive: false,
          animationPath: "assets/animations/quantum_tunneling.json",
        ),
        CardData(
          text: "This isn't just theory. It's why the sun shines. It's how your flash drive works. The impossible happens constantly.",
          isInteractive: false,
          animationPath: "assets/animations/quantum_tunneling.json",
        ),
        CardData(
          text: "Tunnel through the barrier.",
          isInteractive: true,
        ),
      ]
    ),
    const Module(
      id: "double_slit",
      title: "Double Slit Experiment",
      description: "How observation changes reality.",
      requiredPoints: 50,
      cards: [
        CardData(
          text: "Fire tiny particles like marbles through a single slit, and you get a single band on the wall behind it.",
          isInteractive: false,
          animationPath: "assets/animations/double_slit.json",
        ),
        CardData(
          text: "Fire them through two slits, and you expect two bands. But that's not what happens.",
          isInteractive: false,
          animationPath: "assets/animations/double_slit.json",
        ),
        CardData(
          text: "Instead, you get a beautiful interference pattern, like ripples of water crashing and amplifying.",
          isInteractive: false,
          animationPath: "assets/animations/double_slit.json",
        ),
        CardData(
          text: "The particles are somehow acting like waves. But here is the most baffling part.",
          isInteractive: false,
          animationPath: "assets/animations/double_slit.json",
        ),
        CardData(
          text: "If you set up a detector to watch which slit the particle chooses... the wave behavior vanishes.",
          isInteractive: false,
          animationPath: "assets/animations/double_slit.json",
        ),
        CardData(
          text: "Just the act of observing fundamentally changes how the universe behaves. They act like marbles again, leaving just two bands.",
          isInteractive: false,
          animationPath: "assets/animations/double_slit.json",
        ),
        CardData(
          text: "Run the experiment.",
          isInteractive: true,
        ),
      ]
    ),
    const Module(
      id: "quantum_computing",
      title: "Quantum Computing",
      description: "Computers that rethink logic.",
      requiredPoints: 60,
      cards: [
        CardData(
          text: "Normal computers use bits: 1s and 0s. They process information one step at a time.",
          isInteractive: false,
          animationPath: "assets/animations/quantum_computing.json",
        ),
        CardData(
          text: "Quantum computers use qubits. Thanks to superposition, a qubit can be 1, 0, or both simultaneously.",
          isInteractive: false,
          animationPath: "assets/animations/quantum_computing.json",
        ),
        CardData(
          text: "This allows quantum computers to process a massive number of possibilities in parallel, rather than sequentially.",
          isInteractive: false,
          animationPath: "assets/animations/quantum_computing.json",
        ),
        CardData(
          text: "By entangling qubits, they form complex logic gates capable of factoring massive numbers in seconds—a task that would take a normal computer millions of years.",
          isInteractive: false,
          animationPath: "assets/animations/quantum_computing.json",
        ),
        CardData(
          text: "Initialize your Qubits.",
          isInteractive: true,
        ),
      ]
    ),
    const Module(
      id: "string_theory",
      title: "String Theory",
      description: "The universe as a symphony.",
      requiredPoints: 70,
      cards: [
        CardData(
          text: "The Standard Model of particle physics is incredibly accurate, but it's missing something huge: Gravity.",
          isInteractive: false,
          animationPath: "assets/animations/string_theory.json",
        ),
        CardData(
          text: "To bridge the gap between quantum mechanics and relativity, String Theory proposes a radical idea.",
          isInteractive: false,
          animationPath: "assets/animations/string_theory.json",
        ),
        CardData(
          text: "Instead of point-like particles, imagine the fundamental ingredients of the universe are tiny, vibrating, one-dimensional strings.",
          isInteractive: false,
          animationPath: "assets/animations/string_theory.json",
        ),
        CardData(
          text: "Just as different vibrations on a guitar string produce different musical notes, different vibrations of these quantum strings produce different particles.",
          isInteractive: false,
          animationPath: "assets/animations/string_theory.json",
        ),
        CardData(
          text: "The catch? For the math to work, the universe must have at least 11 dimensions, most of them curled up so tightly we can't perceive them.",
          isInteractive: false,
          animationPath: "assets/animations/string_theory.json",
        ),
        CardData(
          text: "Vibrate a string.",
          isInteractive: true,
        ),
      ]
    ),
  ];
}

class CardData {
  final String text;
  final bool isInteractive;
  final String? animationPath;

  const CardData({
    required this.text,
    this.isInteractive = false,
    this.animationPath,
  });
}
