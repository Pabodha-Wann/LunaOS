## LunaOS

Welcome to **LunaOS** – a simple, 16-bit operating system built from scratch using x86 Assembly language. This project is created and maintained by **Pabodha Wanniarachchi** as a hands-on learning experience in low-level system programming, BIOS interrupt handling, and OS development fundamentals.

## Project Purpose

LunaOS is a lightweight, bootable operating system that runs directly on a virtual machine using QEMU. It provides a minimal shell interface where users can interact with basic commands to view hardware-related information retrieved through BIOS services.


## Features

* Runs in 16-bit real mode using BIOS interrupts
* Shows detailed hardware info (CPU, memory, serial ports, etc.)
* Command-line interface for basic interaction
* Fully bootable using QEMU and a floppy image


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
   ![Screenshot 2025-06-19 161559](https://github.com/user-attachments/assets/4dbdd4bb-3a26-4fc3-b17b-75e00fd61952)


2. Command help output after typing `help`
   ![Screenshot 2025-06-19 161655](https://github.com/user-attachments/assets/750ed01d-3b75-437a-9af4-9ae95e423b4c)


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



