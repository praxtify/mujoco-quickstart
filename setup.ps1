# MuJoCo quickstart (Windows) - Praxtify (https://praxtify.com)
# One command: installs Python + VS Code (if missing), the VS Code Python extension,
# a virtual environment with MuJoCo, writes hello_mujoco.py and runs it.
#
#   irm https://raw.githubusercontent.com/praxtify/mujoco-quickstart/main/setup.ps1 | iex
#
# Optional environment variables (set before running):
#   MUJOCO_DIR     project folder            (default: %USERPROFILE%\mujoco-quickstart)
#   MUJOCO_NO_RUN  1 = do not start the simulation at the end
#   MUJOCO_NO_CODE 1 = do not install/open VS Code or its Python extension
#
# MIT License - Copyright (c) 2026 Praxtify

function Install-MujocoQuickstart {
    $ErrorActionPreference = 'Stop'
    $ProgressPreference = 'SilentlyContinue'

    function Write-Step($n, $text) { Write-Host "`n[$n/6] $text" -ForegroundColor Cyan }
    function Write-Ok($text) { Write-Host "      OK  $text" -ForegroundColor Green }
    function Write-Fail($text) { Write-Host "`n  ERROR  $text`n" -ForegroundColor Red }

    function Update-SessionPath {
        $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
        $user = [Environment]::GetEnvironmentVariable('Path', 'User')
        $env:Path = "$machine;$user"
    }

    function Test-Winget { [bool](Get-Command winget -ErrorAction SilentlyContinue) }

    function Install-WithWinget($id) {
        if (-not (Test-Winget)) { return $false }
        winget install --exact --id $id --scope user --silent --accept-package-agreements --accept-source-agreements | Out-Host
        Update-SessionPath
        return $true
    }

    # Returns the path of a working Python >= 3.10 (skips the Microsoft Store stub).
    function Find-Python {
        $candidates = @()
        foreach ($cmd in @('py', 'python')) {
            $c = Get-Command $cmd -ErrorAction SilentlyContinue
            if ($c -and $c.Source -notlike '*WindowsApps*') { $candidates += $c.Source }
        }
        $candidates += Get-ChildItem "$env:LOCALAPPDATA\Programs\Python\Python3*\python.exe" -ErrorAction SilentlyContinue |
            Sort-Object FullName -Descending | ForEach-Object FullName
        foreach ($exe in $candidates) {
            try {
                $args3 = if ((Split-Path $exe -Leaf) -eq 'py.exe') { @('-3') } else { @() }
                $out = & $exe @args3 -c "import sys; print(sys.executable); print(sys.version_info >= (3, 10))" 2>$null
                if ($LASTEXITCODE -eq 0 -and $out[1] -eq 'True') { return $out[0] }
            } catch { }
        }
        return $null
    }

    function Find-Code {
        $c = Get-Command code -ErrorAction SilentlyContinue
        if ($c) { return $c.Source }
        foreach ($p in @("$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd",
                         "$env:ProgramFiles\Microsoft VS Code\bin\code.cmd")) {
            if (Test-Path $p) { return $p }
        }
        return $null
    }

    $RepoRaw = 'https://raw.githubusercontent.com/praxtify/mujoco-quickstart/main'
    $dir = if ($env:MUJOCO_DIR) { $env:MUJOCO_DIR } else { Join-Path $env:USERPROFILE 'mujoco-quickstart' }
    $useCode = $env:MUJOCO_NO_CODE -ne '1'

    Write-Host "`n  MuJoCo quickstart (Windows)  -  praxtify.com" -ForegroundColor White
    Write-Host "  Project folder: $dir"

    # 1 - Python
    Write-Step 1 'Python'
    $python = Find-Python
    if (-not $python) {
        Write-Host '      Python not found - installing Python 3.13 with winget...'
        if (-not (Install-WithWinget 'Python.Python.3.13')) {
            Write-Fail 'winget is not available. Install Python 3.13 from https://www.python.org/downloads/ (tick "Add python.exe to PATH") and run this script again.'
            return
        }
        $python = Find-Python
        if (-not $python) { Write-Fail 'Python was installed but could not be found. Close this terminal, open a new one and run the script again.'; return }
    }
    Write-Ok (& $python --version)

    # 2 - VS Code
    Write-Step 2 'VS Code'
    $code = $null
    if ($useCode) {
        $code = Find-Code
        if (-not $code) {
            Write-Host '      VS Code not found - installing with winget...'
            if (Install-WithWinget 'Microsoft.VisualStudioCode') { $code = Find-Code }
        }
        if ($code) { Write-Ok 'VS Code found' } else { Write-Host '      VS Code not found - skipping (install it from https://code.visualstudio.com).' -ForegroundColor Yellow }
    } else { Write-Host '      skipped (MUJOCO_NO_CODE=1)' }

    # 3 - VS Code Python extension
    Write-Step 3 'VS Code Python extension'
    if ($code) {
        & $code --install-extension ms-python.python --force 2>&1 | Out-Null
        Write-Ok 'ms-python.python'
    } else { Write-Host '      skipped' }

    # 4 - virtual environment + MuJoCo
    Write-Step 4 'Virtual environment + MuJoCo'
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $venvPy = Join-Path $dir '.venv\Scripts\python.exe'
    if (-not (Test-Path $venvPy)) {
        & $python -m venv (Join-Path $dir '.venv')
        if ($LASTEXITCODE -ne 0) { Write-Fail 'Could not create the virtual environment.'; return }
    }
    & $venvPy -m pip install --upgrade --disable-pip-version-check --quiet mujoco
    if ($LASTEXITCODE -ne 0) { Write-Fail 'pip install mujoco failed. Check your internet connection and run the script again.'; return }
    Write-Ok ('mujoco ' + (& $venvPy -c "import mujoco; print(mujoco.__version__)"))

    # 5 - project files
    Write-Step 5 'Project files'
    $hello = Join-Path $dir 'hello_mujoco.py'
    if (-not (Test-Path $hello)) {
        $local = if ($PSScriptRoot) { Join-Path $PSScriptRoot 'hello_mujoco.py' } else { '' }
        if ($local -and (Test-Path $local)) { Copy-Item $local $hello }
        else { Invoke-WebRequest -UseBasicParsing "$RepoRaw/hello_mujoco.py" -OutFile $hello }
    }
    $vscodeDir = Join-Path $dir '.vscode'
    New-Item -ItemType Directory -Force -Path $vscodeDir | Out-Null
    $settings = Join-Path $vscodeDir 'settings.json'
    if (-not (Test-Path $settings)) {
        $json = "{`n    `"python.defaultInterpreterPath`": `"`${workspaceFolder}\\.venv\\Scripts\\python.exe`",`n    `"python.terminal.activateEnvironment`": true`n}`n"
        [IO.File]::WriteAllText($settings, $json, (New-Object Text.UTF8Encoding $false))
    }
    Write-Ok 'hello_mujoco.py  +  .vscode\settings.json'

    # 6 - open in VS Code and run
    Write-Step 6 'Run'
    if ($code) { & $code $dir $hello }
    if ($env:MUJOCO_NO_RUN -eq '1') {
        Write-Host '      skipped (MUJOCO_NO_RUN=1)'
    } else {
        Write-Host '      Starting the simulation - close the MuJoCo window to finish.'
        Push-Location $dir
        try { & $venvPy $hello } finally { Pop-Location }
    }

    Write-Host "`n  Done. Next time: open the folder in VS Code and press Run (F5) on hello_mujoco.py." -ForegroundColor Green
    Write-Host '  More robotics projects: https://github.com/praxtify  -  https://praxtify.com' -ForegroundColor Green
}

Install-MujocoQuickstart
