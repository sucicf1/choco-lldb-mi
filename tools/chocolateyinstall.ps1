$ErrorActionPreference = 'Stop' # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$zipArchive = Join-Path $toolsDir -ChildPath 'lldb-mi.zip'
$installPath = "$env:ProgramFiles\lldb-mi\bin"
$miDebuggerPath = Join-Path $installPath.replace("\","\\") '\\lldb-mi.exe' 

if ((Get-WmiObject win32_operatingsystem | select osarchitecture).osarchitecture -eq "64-bit")
{
    $unzipArgs = @{
		FileFullPath = $zipArchive
		Destination = $installPath
	}

	If(!(test-path -PathType container $installPath))
	{
		New-Item -ItemType Directory -Path $installPath
	}
	
	Get-ChocolateyUnzip @unzipArgs
	
	Write-Host @"
	
	Thank you for installing!

	To use with vs-code do following:
		1. Install Clang/LLVM toolschain
		2. Set the environment variable LLVMInstallDir
		   to toolchain path.
		3. In launch.json add:
		   "MIMode": "lldb",
		   "miDebuggerPath": "$miDebuggerPath"

	Happy debugging!
"@
}
else
{
    throw 'Error: This package requires an 64-bit os!'
}