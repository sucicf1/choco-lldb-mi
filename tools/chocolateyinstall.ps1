$ErrorActionPreference = 'Stop' # stop on all errors
$osArchitecture = (Get-CimInstance win32_operatingsystem | select osarchitecture).osarchitecture
switch ($osArchitecture) 
{
	"ARM 64-bit Processor"
	{
		$architecture = "arm64" 
		break 
	}
	"64-bit" 
	{ 
		$architecture = "x64" 
		break 
	}
	Default 
	{ 
		$architecture = "unknown" 
	}
}

if (($architecture -eq "arm64") -or ($architecture -eq "x64"))
{
	$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
	$zipArchive = Join-Path $toolsDir -ChildPath "lldb-mi_$architecture.7z"
	$installPath = "$env:ProgramFiles\lldb-mi\bin"
	$miDebuggerPath = Join-Path $installPath.replace("\","\\") '\\lldb-mi.exe' 
	
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