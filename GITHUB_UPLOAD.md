# GitHub Upload Notes

This machine did not have `git` or `gh` available when the repro package was prepared, so the repository was not uploaded automatically.

After installing Git for Windows and GitHub CLI, run these commands from this folder:

```powershell
git init
git add README.md BUG_REPORT.md GITHUB_UPLOAD.md .gitignore scripts repro-vault/.obsidian repro-vault/Welcome.md
git commit -m "Add Obsidian large markdown indexing crash repro"
gh auth login
gh repo create obsidian-large-md-index-crash-repro --public --source . --remote origin --push
```

The generated large Markdown files are intentionally ignored by `.gitignore`. Reviewers can generate them locally with:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\generate-repro-vault.ps1
```

Then open `repro-vault` in Obsidian.

