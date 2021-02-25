# VARIABLES and ARRAYS
# Path for Registry Settings
$PSParentPath = "HKLM:\SOFTWARE\Wow6432Node"
$PSChildName = "OneZeroOne"
$PSPath = $PSParentPath + "\"+ $PSChildName
# Array containing comma-separated lists of key values: ("Name1", "Value1", "Type1"),("Name2", "Value2", "Type2"),("Name3"...)
# For value types, please see https://docs.microsoft.com/en-us/windows/win32/sysinfo/registry-value-types
$RegVals = @(
  ("InstallationDirectory","C:\Program Files\One Zero One\","SZ"),
  ("Version","1.0.1","SZ"),
  ("LastUpdateCheck","60240c70","DWORD")
)

# MAIN
# Test for the existence of $PSpath
If ( -not (Test-Path "$PSPath") ) {
  # $PSPath does not exist, create it
  New-Item -Path "$PSParentPath" -Name "$PSChildName"
}

# Loop through array of ("Name", "Value", "Type") lists
ForEach ($List in $RegVals) {
  $Name = $List[0]
  $Value = $List[1]
  $Type = $List[2]
  # Test for existence of Name. Will return null if it doesn't exist
  If ($null -eq (Get-ItemProperty -Path $PSPath).($Name)) {
    # Name doesn't exist and we should create it
    New-ItemProperty -Path "$PSPath" -Name "$Name" -Value "$Value" -PropertyType "$Type"
  }
  else {
    # Name exists and we should set it
    Set-ItemProperty -Path "$PSPath" -Name "$Name" -Value "$Value" -ErrorAction Stop
  }
}
