# Forum Post Draft

## Title

Renderer exits and window turns black while indexing large Markdown files

## Body

### Description

Obsidian opens the vault normally, but shortly after indexing starts the UI turns into a black window. The main Obsidian process remains alive and Windows still considers the window responsive, but the renderer process exits.

This appears to be triggered by large Markdown files in the vault.

### Environment

- Obsidian version: 1.12.7
- OS: Windows 10, build 19045
- Installer path: `C:\Users\TY_Heyifei\AppData\Local\Programs\Obsidian\Obsidian.exe`
- Community plugins: disabled during the final reproduction

### Steps to reproduce

I prepared a sanitized reproduction repository:

https://github.com/heyifei97/obsidian-large-md-index-crash-repro

1. Clone the repository.
2. Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\generate-repro-vault.ps1
```

3. Open `repro-vault` in Obsidian.
4. Wait for indexing.
5. Optional process monitor:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\observe-obsidian-renderer.ps1
```

### Expected result

Obsidian should index large Markdown files without the renderer process exiting.

If a file is too large or expensive to index safely, Obsidian should skip it, warn the user, or degrade gracefully while keeping the UI usable.

### Actual result

The vault opens briefly, then the window turns black.

Process inspection showed that the main process, GPU process, and utility process remained alive, while `Obsidian.exe --type=renderer` disappeared after about 15 seconds.

### Local investigation

I tested by physically moving folders in and out of the vault and clearing Obsidian runtime caches between runs:

- Empty test vault: stable for 60 seconds.
- Original vault with only root-level small files: stable for 60 seconds.
- Original vault with most directories restored: stable.
- Restoring a task transcript folder caused the renderer to disappear after about 15 seconds.
- Moving only Markdown files larger than 5 MB out of that folder restored stability for at least 90 seconds.

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

Files smaller than 5 MB in the same folder did not trigger the issue during local testing.

### Workaround

Move very large Markdown files outside the vault, split them into smaller notes, or exclude them before opening Obsidian.

### Notes

This looks related to the indexing pipeline for large Markdown documents. The failure mode is severe because the user sees only a black window and cannot recover from inside the app.

