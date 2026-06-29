# Bug Report: Renderer exits and Obsidian window turns black while indexing large Markdown files

## Environment

- Obsidian version: 1.12.7
- Operating system: Windows 10, build 19045
- Installer path observed: `C:\Users\TY_Heyifei\AppData\Local\Programs\Obsidian\Obsidian.exe`

## Summary

Obsidian opens a vault normally, but after indexing starts the UI turns into a black window. The main process remains alive and responsive from Windows' perspective, but the renderer process exits. This appears to be triggered by large Markdown files in the vault.

## Expected Behavior

Obsidian should not lose the renderer process while indexing large Markdown files. If a file is too large or expensive to index, Obsidian should skip it, report a warning, or continue indexing the rest of the vault.

## Actual Behavior

The vault opens briefly, then turns black. The window title remains present, and the main process continues running. Process inspection shows that `Obsidian.exe --type=renderer` disappears after around 15 seconds.

## Local Investigation

The original vault was tested by physically moving folders in and out of the vault and clearing runtime caches between runs:

- Empty test vault: stable for 60 seconds.
- Original vault with only root-level small files: stable for 60 seconds.
- Original vault with most directories restored: stable.
- Restoring the task transcript folder caused the renderer to disappear after about 15 seconds.
- Moving only files larger than 5 MB out of that folder restored stability for at least 90 seconds.

The problematic set contained eight large Markdown files:

| Size | Description |
|---:|---|
| 37.82 MB | Large task transcript Markdown |
| 9.06 MB | Large task transcript Markdown |
| 8.57 MB | Large task transcript Markdown |
| 7.62 MB | Large task transcript Markdown |
| 7.50 MB | Large task transcript Markdown |
| 6.76 MB | Large task transcript Markdown |
| 5.63 MB | Large task transcript Markdown |
| 5.25 MB | Large task transcript Markdown |

Files smaller than 5 MB in the same folder did not trigger the issue during the local tests.

## Reproduction Repository

This repository contains a script that creates a synthetic vault with large Markdown files. The generated files contain repeated non-private text only.

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\generate-repro-vault.ps1
```

Then open `repro-vault` in Obsidian and wait for indexing.

## Notes

This looks related to the indexing pipeline for large Markdown documents. The failure mode is severe because the user sees only a black window and cannot recover from inside the app.
