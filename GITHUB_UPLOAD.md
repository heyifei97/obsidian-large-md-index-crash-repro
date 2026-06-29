# GitHub Publication Notes

This repro package has been published to GitHub:

<https://github.com/heyifei97/obsidian-large-md-index-crash-repro>

The generated large Markdown files are intentionally ignored by `.gitignore`. Reviewers can generate them locally with:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\generate-repro-vault.ps1
```

Then open `repro-vault` in Obsidian.

For maintainers reproducing from a fresh clone:

```powershell
git clone https://github.com/heyifei97/obsidian-large-md-index-crash-repro.git
cd obsidian-large-md-index-crash-repro
powershell -ExecutionPolicy Bypass -File .\scripts\generate-repro-vault.ps1
```
