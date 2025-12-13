# Troubleshooting

Common issues and solutions when building or running the system.

## Build Failures

### `empw: command not found`
**Cause:** The `empw` binary is not in your `$PATH`.
**Fix:** Install `empw` and add its location to your PATH.
```bash
export PATH=$PATH:/path/to/empw
```

### `File not found` errors during build
**Cause:** MPW is case-insensitive, but Linux is case-sensitive. `empw` handles some of this, but file naming mismatches can occur.
**Fix:** Ensure files in the repo match the casing expected by the `.make` files.

### `MainCode.Make` parsing errors
**Cause:** The makefile has special character encoding (Mac Roman) that might be corrupted by text editors.
**Fix:** Avoid editing `Make/MainCode.Make` with editors that auto-convert line endings or encodings. Use hex editors or script-based appending (like `patch_makefile.sh`).

### Missing `MiniFinder.c.o`
**Cause:** The stubs were not compiled or the makefile patch didn't apply.
**Fix:** Run `patch_makefile.sh` again and check `Make/MainCode.Make` for the appended lines.

## Runtime Issues

### Emulator hangs at boot
**Cause:** Incomplete OS initialization, missing drivers, or memory corruption.
**Fix:**
1.  Check if `MiniFinder` is being reached (add an infinite loop with a visual indicator if possible).
2.  Ensure you are using a compatible ROM file in your emulator (e.g., Mac IIci or SE/30 ROM).

### "Sad Mac" Icon
**Cause:** Hardware test failure or severe kernel panic.
**Fix:** Decode the hex code under the Sad Mac (consult "Sad Mac Error Codes" documentation online).

## Logs
The build process logs to stdout. Redirect to a file to analyze:
```bash
./build_system7.sh > build.log 2>&1
```
