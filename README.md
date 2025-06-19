## LunaOS

Welcome to **LunaOS** – a simple, 16-bit operating system built from scratch using x86 Assembly language. This project is created and maintained by **Pabodha Wanniarachchi** as a hands-on learning experience in low-level system programming, BIOS interrupt handling, and OS development fundamentals.

## Project Purpose

LunaOS is a lightweight, bootable operating system that runs directly on a virtual machine using QEMU. It provides a minimal shell interface where users can interact with basic commands to view hardware-related information retrieved through BIOS services.

Whether you're an OS development beginner or curious about how real-mode assembly works, LunaOS is a great place to start.

## Features

* Runs in 16-bit real mode using BIOS interrupts
* Shows detailed hardware info (CPU, memory, serial ports, etc.)
* Command-line interface for basic interaction
* Fully bootable using QEMU and a floppy image
* Lightweight and simple codebase for learning

## Supported Commands

1. **info** – Display system hardware information:

   * CPU Vendor and Type
   * Base and Extended Memory
   * Total Usable Memory
   * COM1 Serial Port and I/O Address
   * Mouse Detection Status

2. **help** – Show all supported commands with descriptions

3. **clear** – Clear the screen output and return to a clean prompt

## Screenshots

1. System information display after typing `info`
   

2. Command help output after typing `help`
   

## How to Build and Run

Requirements:

* NASM (Netwide Assembler)
* QEMU (Quick Emulator)
* Linux environment recommended for development

Steps:

1. Clone the repository:
   git clone [https://github.com/Pabodha-Wann/LunaOS.git](https://github.com/Pabodha-Wann/LunaOS.git)
   cd LunaOS

2. Assemble the OS kernel using NASM:
   nasm -f bin kernel.asm -o BOOT.BIN

3. Launch LunaOS in QEMU:
   qemu-system-i386 -fda BOOT.BIN

That’s it! You’ll see the welcome message and command prompt from LunaOS.

## Why LunaOS?

* To explore low-level OS concepts in a real-mode environment
* To learn how operating systems interface with BIOS services
* To gain hands-on experience with Assembly language
* To build something from scratch that actually boots and runs!

## About the Author

LunaOS is developed by **Pabodha Wanniarachchi**, a passionate software engineering undergraduate with an interest in operating systems, low-level programming, and system architecture.

Contact:
GitHub – [https://github.com/Pabodha-Wann](https://github.com/Pabodha-Wann)

## License

This project is licensed under the MIT License. You are free to use, modify, and distribute this code with proper credit.


