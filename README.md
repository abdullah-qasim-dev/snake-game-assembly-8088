# Snake Game - x86 Assembly (8088)

## Overview
A classic Snake Game implemented in x86 Assembly Language 
for the 8088 platform, running in text mode using direct 
video memory manipulation (0xB800).

## Features
- Snake movement using arrow keys (↑ ↓ ← →)
- Random food generation
- Score tracking system
- Boundary & self-collision detection
- Restart or exit after game over

## Technologies Used
- x86 Assembly Language (8088)
- DOS Interrupts (INT 16h, INT 1Ah, INT 21h)
- Direct Video Memory Manipulation
- emu8086 / DOSBox

## How to Run
1. Open `snake.asm` in **emu8086** or **DOSBox**
2. Assemble and run
3. Press **S** to Start, **E** to Exit
4. Use **Arrow Keys** to control snake
5. Press **R** to Restart after Game Over

## Controls
| Key | Action |
|-----|--------|
| ↑ ↓ ← → | Move Snake |
| S | Start Game |
| R | Restart |
| E | Exit |

## Contributors
- [Abdullah Qasim](https://github.com/abdullah-qasim-dev)
