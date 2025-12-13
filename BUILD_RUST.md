# Building the Rust OS

The operating system has been converted to a Rust workspace structure.

## Structure
- `rust_src/mac_types`: Common Macintosh types (OSErr, Rect, etc.) rewritten in Rust.
- `rust_src/os`: Core OS subsystems (MemoryMgr, StartMgr, etc.).
- `rust_src/kernel`: The kernel entry point and main loop (MiniFinder equivalent).

## Prerequisites
- **Rust Nightly** is **REQUIRED** to build for the `m68k-unknown-none-elf` target because the standard library (`core`) is not pre-compiled for this target.
- `rust-src` component.

## Building for Macintosh SE/30 (m68k)

1.  Install the nightly toolchain and the rust-src component:
    ```bash
    rustup toolchain install nightly
    rustup component add rust-src --toolchain nightly
    ```

2.  Build using cargo with the nightly toolchain and `build-std`:
    ```bash
    cargo +nightly build --release -Z build-std=core,alloc
    ```

    *Note: The `.cargo/config.toml` sets the default target to `m68k-unknown-none-elf`. You can uncomment the `[unstable]` section in that file if you are always using nightly.*

## Verifying on x86_64 Host (Syntax Check)

If you do not have the nightly toolchain or just want to check the syntax:

```bash
cargo check --target x86_64-unknown-linux-gnu
```
