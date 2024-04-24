$ErrorActionPreference = 'Stop'

$installPathStr = "$env:ProgramFiles\lldb-mi"
$installPath = @{Path = $installPathStr}
$installBinPathStr = "$installPathStr\bin"
$installBinPath = @{Path = $installBinPathStr}
$installExePathStr = "$installBinPathStr\lldb-mi.exe" 
$installExePath = @{Path = $installExePathStr}

Remove-Item @installExePath

$directoryInfo = Get-ChildItem @installBinPath | Measure-Object

if ($directoryInfo.count -eq 0)
{
	Remove-Item @installBinPath
	
	$directoryInfo = Get-ChildItem @installPath | Measure-Object
	if ($directoryInfo.count -eq 0) 
	{
		Remove-Item @installPath
	}
}