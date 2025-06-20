# FizzBuzz in Assembly

The pinnacle of software engineering. FizzBuzz, written three times for three operating systems and two different CPU architectures. All versions loop from 1 to 777.

## What you'll need

* **Docker Desktop**
* **VS Code** + the **Dev Containers extension**
* **Xcode Command Line Tools** (for the native `arm64` macOS build)

## Build instructions

### 1. The Linux version (x86_64)

1.  Open the `linux/` folder in VS Code.
2.  Reopen in Container.
3.  In the new terminal that appears, run this:

    ```bash
    nasm -f elf64 fizzbuzz-linux.asm -o fizzbuzz.o
    ld fizzbuzz.o -o fizzbuzz
    ./fizzbuzz
    ```

### 2. The Windows version (x86_64)

1.  Open the `windows/` folder in VS Code.
2.  Reopen in Container.
3.  Run this in the terminal:

    ```bash
    nasm -f win64 fizzbuzz-windows.asm -o fizzbuzz-windows.o
    x86_64-w64-mingw32-gcc -o fizzbuzz.exe fizzbuzz-windows.o -lkernel32
    ```
    > You can't run the `.exe` here. You have to take the file and find a Windows machine to run it on. Good luck.

### 3. The macOS version (native arm64)

1.  Open your normal Mac terminal.
2.  `cd` into the `macos/` folder.
3.  Run these commands:

    ```bash
    as -o fizzbuzz-macos.o fizzbuzz-macos.asm
    gcc -o fizzbuzz-macos fizzbuzz-macos.o
    ./fizzbuzz-macos
    ```