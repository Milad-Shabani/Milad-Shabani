@echo off
REM ============================================================
REM Publish the GitHub PROFILE repo: github.com/Milad-Shabani/Milad-Shabani
REM This is the special repo whose README shows on your profile page.
REM Requires: git, and GitHub CLI (gh) installed + logged in (gh auth login)
REM
REM Folder must contain:
REM   README.md
REM   banner.png   (same folder, NOT inside a subfolder)
REM ============================================================

set REPO_NAME=Milad-Shabani
set "REPO_DESC=Profile README - Milad Shabani, Business Intelligence Engineer"

REM --- adjust this to wherever you put README.md and banner.png
cd /d "C:\Users\MILAD\Desktop\Milad-Shabani"

REM --- safety check: don't publish an empty/wrong folder
if not exist "README.md" (
    echo [ERROR] README.md not found in this folder.
    echo Put README.md and banner.png here first.
    pause
    exit /b 1
)
if not exist "banner.png" (
    echo [WARNING] banner.png not found in this folder - the header image will be broken.
    echo Press Ctrl+C to abort, or
    pause
)

REM --- create the snake animation workflow (only once)
if not exist ".github\workflows" mkdir ".github\workflows"
if not exist ".github\workflows\snake.yml" (
  echo name: Contribution snake> ".github\workflows\snake.yml"
  echo on:>> ".github\workflows\snake.yml"
  echo   schedule:>> ".github\workflows\snake.yml"
  echo     - cron: "0 2 * * *">> ".github\workflows\snake.yml"
  echo   workflow_dispatch:>> ".github\workflows\snake.yml"
  echo   push:>> ".github\workflows\snake.yml"
  echo     branches:>> ".github\workflows\snake.yml"
  echo       - main>> ".github\workflows\snake.yml"
  echo permissions:>> ".github\workflows\snake.yml"
  echo   contents: write>> ".github\workflows\snake.yml"
  echo jobs:>> ".github\workflows\snake.yml"
  echo   build:>> ".github\workflows\snake.yml"
  echo     runs-on: ubuntu-latest>> ".github\workflows\snake.yml"
  echo     steps:>> ".github\workflows\snake.yml"
  echo       - name: Generate snake>> ".github\workflows\snake.yml"
  echo         uses: Platane/snk@v3>> ".github\workflows\snake.yml"
  echo         with:>> ".github\workflows\snake.yml"
  echo           github_user_name: Milad-Shabani>> ".github\workflows\snake.yml"
  echo           outputs: dist/snake.svg>> ".github\workflows\snake.yml"
  echo       - name: Publish to output branch>> ".github\workflows\snake.yml"
  echo         uses: crazy-max/ghaction-github-pages@v4>> ".github\workflows\snake.yml"
  echo         with:>> ".github\workflows\snake.yml"
  echo           target_branch: output>> ".github\workflows\snake.yml"
  echo           build_dir: dist>> ".github\workflows\snake.yml"
  echo         env:>> ".github\workflows\snake.yml"
  echo           GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}>> ".github\workflows\snake.yml"
  echo Created .github\workflows\snake.yml
)

REM --- set your git identity (safe to run every time)
git config --global user.name "Milad Shabani"
git config --global user.email "MILAD.SHABANI6515@GMAIL.COM"

REM --- init only if not already a repo
if not exist ".git" (
    git init
    git branch -M main
)

REM --- remove any leftover remote from a previous attempt
git remote remove origin 2>nul

git add .
git commit -m "Update profile README, banner and snake workflow"
git branch -M main

REM --- create the repo if it does not exist yet, otherwise just push to it
gh repo view Milad-Shabani/%REPO_NAME% >nul 2>&1
if errorlevel 1 (
    echo Creating new repo %REPO_NAME% ...
    gh repo create %REPO_NAME% --public --source=. --remote=origin --push --description "%REPO_DESC%"
) else (
    echo Repo %REPO_NAME% already exists - pushing to it ...
    git remote add origin https://github.com/Milad-Shabani/%REPO_NAME%.git
    git push -u origin main --force
)

REM --- profile-level settings (bio, company, location, website)
REM     (needs the "user" scope once: gh auth refresh -h github.com -s user)
gh api -X PATCH /user ^
  -f name="Milad Shabani" ^
  -f company="Freelance" ^
  -f location="Karaj, Iran" ^
  -f blog="https://miladshabani.ir" ^
  -f bio="Business Intelligence Engineer | warehouses, Power BI, forecasting & optimization | open to remote and relocation" >nul

echo.
echo Done. Your profile should now show the README at:
echo https://github.com/Milad-Shabani
echo.
echo Notes:
echo   - If the snake image still shows broken, open the Actions tab and check the run,
echo     then hard-refresh the profile page (Ctrl+Shift+R) - GitHub caches images.
echo   - The snake animation appears about a minute after the Actions run finishes.
echo   - If the workflow fails: repo Settings -^> Actions -^> General -^> Workflow permissions
echo     -^> set "Read and write permissions".
echo   - Profile bio needs one extra scope once:  gh auth refresh -h github.com -s user
echo.
echo Next step (manual, 1 minute):
echo   Profile page -^> Customize your pins -^> pin these 6 repos in this order:
echo     1. Pharmapulse-supply-chain-intelligence
echo     2. Food-manufacturing-sop-planning-engine
echo     3. Resource-planning-capacity-forecasting
echo     4. User-analytics-data-pipeline
echo     5. Malard-vaccination-analytics-forecasting
echo     6. Powerbi-analytics-online-market
pause
