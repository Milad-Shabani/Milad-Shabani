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
git commit -m "Update profile README and banner"
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
echo Next step (manual, 1 minute):
echo   Profile page -^> Customize your pins -^> pin these 6 repos in this order:
echo     1. Pharmapulse-supply-chain-intelligence
echo     2. Food-manufacturing-sop-planning-engine
echo     3. Resource-planning-capacity-forecasting
echo     4. User-analytics-data-pipeline
echo     5. Malard-vaccination-analytics-forecasting
echo     6. Powerbi-analytics-online-market
pause
