# Obsidian Large Markdown Index Crash Repro

This repository contains a sanitized reproduction case for an Obsidian renderer crash / black window that appears while indexing a vault containing several very large Markdown files.

The reproduction content is synthetic. It does not include private notes.

Generated large Markdown files are ignored by Git. This keeps the repository small while still providing a repeatable local repro.

## What Was Observed

- Obsidian version: 1.12.7
- OS observed: Windows 10, build 19045
- Symptom: the vault opens briefly, then the UI turns black.
- Process behavior: the main Obsidian process, GPU process, and utility process remain alive, but the renderer process exits.
- The issue reproduced when a vault contained multiple large `.md` files in one folder.
- The same vault became stable after moving the `>5 MB` Markdown files outside the vault.

## Reproduction

1. Run the generator script:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\generate-repro-vault.ps1
   ```

2. Open `repro-vault` in Obsidian.

3. Wait for Obsidian to index the vault.

4. Optional: monitor the renderer process:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\observe-obsidian-renderer.ps1
   ```

## Expected Behavior

Obsidian should index large Markdown files without the renderer process exiting. If a file is too large to index safely, Obsidian should skip it, show a warning, or degrade gracefully.

## Actual Behavior

In the original local vault, the Obsidian UI turned black after a short delay during indexing. The renderer process disappeared while the main window remained open.

## Workaround

Move very large Markdown files outside the vault, split them into smaller notes, or exclude them before opening Obsidian.
