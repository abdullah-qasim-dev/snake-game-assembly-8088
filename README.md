# 🐍 Snake Game - x86 Assembly (8088)

## Overview
A classic Snake Game implemented in x86 Assembly Language for the 8088 platform, running in text mode using direct video memory manipulation (0xB800).

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
- DOSBox / NASM / AFD

## Setup & How to Run

### Prerequisites
Install DOSBox and setup NASM & AFD using the guide below:
👉 [Setup Guide - AFD, NASM & DOSBox](https://wetolearn.blogspot.com/2013/09/setting-up-afd-nasm-and-dosbox-for-8086.html)

### Folder Structure
Make sure all these files are in the **same folder**:

```
📁 Project Folder
├── afd.exe       (provided in repo)
├── nasm.exe      (provided in repo)
├── DOSBox.lnk    (DOSBox shortcut)
└── snake.asm     (game code)
```

### Steps
1. Clone or download this repository
2. Place all files in the same folder
3. Open **DOSBox** shortcut
4. Mount and navigate to project folder in DOSBox:
```
mount c .
c:
```
5. Assemble the code:
```
nasm snake.asm -o snake.com
```
6. Run the game:
```
snake.com
```

## Controls
| Key | Action |
|-----|--------|
| ↑ ↓ ← → | Move Snake |
| S | Start Game |
| R | Restart |
| E | Exit |

## Contributors
- [Abdullah Qasim](https://github.com/abdullah-qasim-dev)
