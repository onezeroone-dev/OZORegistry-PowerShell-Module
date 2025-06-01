# CLASSES
Class OZORegistryKey {
    # PROPERTIES: Booleans, Strings
    [Boolean] $Display      = $false
    [Boolean] $keyExists    = $true
    [Boolean] $keyPathValid = $true
    [Boolean] $namesRead    = $true
    [String]  $keyPath      = $null
    # PROPERTIES: PSCustomObjects
    Hidden [PSCustomObject] $Key    = $null
    Hidden [PSCustomObject] $Logger = $null
    # PROPERTIES: PSCustomObject Lists
    Hidden [System.Collections.Generic.List[PSCustomObject]] $Names = @()
    # METHODS: Constructor method
    OZORegistryKey([String]$KeyPath,[Boolean]$Display) {
        # Set properties
        $this.Display = $Display
        # Create a logger
        $this.Logger = (New-OZOLogger)
        # Determine if Display is false and if so disable Logger display
        If ($this.Display -eq $false) { $this.Logger.SetConsoleOutput("off") }
        # Call ValidateKeyPath to determine if KeyPath format is valid [and populate this.KeyPath]
        If ($this.ValidateKeyPath($KeyPath) -eq $true) {
            # Key is valid
            $this.Logger.Write(("Using key path " + $this.keyPath + "."),"Information")
            # Call ReadKey to set keyExists [and populate registryKey]
            If ($this.ReadKey() -eq $true) {
                # Retrieved key; call ReadKeyNames [and populate Names]
                If ($this.ReadKeyNames() -eq $true) {
                    # Able to read all key names
                    $this.Logger.Write(($this.keyPath + " exists and all names read."),"Information")
                    # Display key for user-interactive sessions
                    $this.DisplayKey()                    
                } Else {
                    # No names found or unable to read all names; log
                    $this.Logger.Write(($this.keyPath + " contains no names or some namues could not be read."),"Warning")
                    $this.namesRead = $false
                }
            } Else {
                # Unable to retrieve key; log
                $this.Logger.Write(("Key `"" + $KeyPath + "`" could not be read."),"Error")
                $this.keyExists = $false
                $this.namesRead = $false
            }
        } Else {
            # Key format is not valid; log
            $this.Logger.Write(("Key `"" + $KeyPath + "`" is not a valid path."),"Error")
            $this.keyExists = $false
            $this.keyPathValid  = $false
            $this.namesRead = $false
        }
    }
    # METHODS: Validate key path method
    Hidden [Boolean] ValidateKeyPath([String]$KeyPath) {
        # Control variable
        [Boolean] $Return = $true
        # Local variables
        [Array]  $validShortStrings = @("HKCR:","HKCU:","HKLM:","HKU:","HKCC:")
        [Array]  $validLongStrings  = @("HKEY_CLASSES_ROOT","HKEY_CURRENT_USER","HKEY_LOCAL_MACHINE","HKEY_USERS","HKEY_CURRENT_CONFIG")
        [String] $keyPathStart      = $null
        # Determine if KeyPath contains a \ character
        If ($KeyPath -Like "*\*") {
            # KeyPath contains a \ character; split the string on \ and store the first string as keyPathStart
            $keyPathStart = ($KeyPath -Split "\\" )[0]
            # Determine if the first string is found in valid*Strings
            If (($validShortStrings + $validLongStrings) -Contains $keyPathStart) {
                # First string appears in valid*Strings lists; determine if key is in validShortStrings
                If ($validShortStrings -Contains $keyPathStart) {
                    # Key is in the short format; convert to long format and set this.keyPath
                    $this.keyPath = ("Registry::" + (Convert-OZORegistryPath -RegistryPath $KeyPath))
                } Else {
                    # Key is in the long format; set this.keyPath
                    $this.keyPath = ("Registry::" + $KeyPath)
                }
            } Else {
                # First string does not appear in valid*Strings
                $Return = $false
            }
        } Else {
            # Path does not contain a \ character
            $Return = $false
        }
        # return
        return $Return
    }
    # METHODS: Read key method
    Hidden [Boolean] ReadKey() {
        # Control variable
        [Boolean] $Return = $true
         # Determine that Key is valid and set
        If ($this.keyPathValid -eq $true -And $null -ne $this.keyPath) {
            # Key is valid and set; try to get the key
            Try {
                $this.Key = (Get-Item -Path $this.keyPath -ErrorAction Stop)
                # Success
            } Catch {
                # Failure
                $Return = $false
            }
        } Else {
            $Return = $false
        }
        # Return
        return $Return
    }
    # METHODS: Read key names method
    Hidden [Boolean] ReadKeyNames() {
        # Control variable
        [Boolean] $Return = $true
        # Determine that registryKey is populated
        If ($null -ne $this.Key) {
            # Registry key is populated; determine if it has no properties
            If ($this.Key.Property.Count -eq 0) {
                # There are no properties; nothing to do
                $Return = $false
            # Otherwise determine if the Property count is 1 and it's Name is "(default)"
            } ElseIf ($this.Key.ValueCount -eq 1 -And $this.Key.Property -Contains "(default)") {
                # Key contains only one property and it is the (default) property; nothing to do
                $Return = $false
            } Else {
                # Key contains one or more names that are not "(default)"; iterate through the names
                ForEach ($keyProperty in $this.Key.Property) {
                    $this.Names.Add(([OZORegistryKeyName]::new($keyProperty,$this.Key.GetValue($keyProperty,$null,"DoNotExpandEnvironmentNames"))))
                }
                # Determine if the count of registry values does not match the number of objects in the Names list
                If ($this.Key.ValueCount -ne $this.Names.Count) {
                    # The counts do not match (some name could not be represented with a RegistryKeyName object); clear Names
                    $this.Names = @()
                    $Return = $false
                }
            }
        }
        # Return
        return $Return
    }
    # METHODS: Set display method
    [Void] SetDisplay([Boolean]$DisplayBool) {
        # Determine if SetValue is true
        If ($DisplayBool -eq $true) {
            # SetValue is true
            $this.Display = $true
        } Else {
            # SetValue is false
            $this.Display = $false
        }
    }
    # METHODS: Display key method
    [Void] DisplayKey() {
        # Determine if session is user-interactive
        If ((Get-OZOUserInteractive) -eq $true -And $this.Display -eq $true) {
            # Session is user-interactive and Display is True
            $this.Names | Select-Object -Property Name,Type,Value | Format-Table | Out-Host
        }
    }
    # METHODS: Return registry key name value method
    [Object] ReturnKeyNameValue($Name) {
        # Local variables
        [PSCustomObject] $keyName = $null
        # Determine if the key path is valid
        If ($this.keyPathValid -eq $true) {
            # Key path is valid; determine if the key exists
            If ($this.keyExists -eq $true) {
                # Key exists; determine if the names were read
                If ($this.namesRead -eq $true) {
                    # Names were read; determine if Names contains Name
                    If ($this.Names.Name -Contains $Name) {
                        # Get the specific Name as keyName
                        $keyName = ($this.Names | Where-Object {$_.Name -eq $Name})
                        # Switch on Type and return the value as the corresponding type
                        Switch ($keyName.Type.ToLower()) {
                            "binary"       { return [Byte[]]   $keyName.Value   }
                            "dword"        { return [Int32]    $keyName.Value   }
                            "expandstring" { return [String]   $keyName.Value   }
                            "multstring"   { return [String[]] $keyName.Value   }
                            "qword"        { return [Int64]    $keyName.Value   }
                            "string"       { return [String]   $keyName.Value   }
                            default        { return [String]   "Unhandled type" }
                        }
                    } Else {
                        # Name not found in Names.Name
                        return "Name not found in Key"
                    }
                } Else {
                    # Could not read names
                    return "Could not read key names"
                }
            } Else {
                # Key path does not exist
                return "Key not found"
            }
        } Else {
            # Key Path is not valid
            return "Key path is not valid"
        }
        #Return
        return "Unsupported"
    }
    # METHODS: Return registry key name type method
    [String] ReturnKeyNameType($Name) {
        # Determine if key is valid
        If ($this.keyPathValid -eq $true) {
            # Key path is valid; determine if the key exists
            If ($this.keyExists -eq $true) {
                # Key exists; determine if the names were read
                If ($this.namesRead -eq $true) {
                    # Names were read; determine if Name exists in Names list
                    If ($this.Names.Name -Contains $Name) {
                        # Name exists in Names list; return the value as string
                        return ($this.Names | Where-Object {$_.Name -eq $Name}).Type
                    }
                } Else {
                    # Could not read names
                    return "Could not read key names"
                }
            } Else {
                # Key path does not exist
                return "Key not found"
            }
        } Else {
            # Key Path is not valid
            return "Key path is not valid"
        }
        # Return
        return "Unsupported"
    }
    # METHODS: Add key name method
    [Boolean] AddKeyName([String]$Name,$Value) {
        # Control variable
        [Boolean] $Return = $true
        # Determine if Name already exists in Names
        If ($this.Names.Name -Contains $Name) {
            # Names already contains Name
            $this.Logger.Write(("Key already contains a " + $Name + " name; skipping."),"Warning")
            $Return = $false
        } Else {
            # Names does not already contain this Name; add to list
            $this.Names.Add(([OZORegistryKeyName]::new($Name,$Value)))
        }
        # Display key values for user-interactive sessions
        $this.DisplayKey()
        # Return
        return $Return
    }
    # METHODS: Add key name method
    [Boolean] RemoveKeyName([String]$Name) {
        # Control variable
        [Boolean] $Return = $true
        # Determine if Name exists in Names
        If ($this.Names.Name -Contains $Name) {
            # Names contains Name; remove it
            $this.Names.Remove(($this.Names | Where-Object {$_.Name -eq $Name}))
        } Else {
            # Names does not contain Name; nothing to do
            $this.Logger.Write(("Key does not contain a " + $Name + " name; skipping."),"Warning")
            $Return = $false
        }
        # Display key values for user-interactive sessions
        $this.DisplayKey()
        # Return
        return $Return
    }
    # METHODS: Update key name method
    [Boolean] UpdateKeyName([String]$Name,$Value) {
        # Control variable
        [Boolean] $Return = $true
        # Determine if this Name exists in Names
        If ($this.Names.Name -Contains $Name) {
            # Namee exists; determine if types match
            If (($this.Names | Where-Object {$_.Name -eq $Name}).Value.GetType() -eq $Value.GetType()) {
                # Types match; update with new Value
                ($this.Names | Where-Object {$_.Name -eq $Name}).Value = $Value
            } Else {
                $this.Logger.Write("Types do not match; name will not be updated.","Warning")
                $Return = $false
            }
        } Else {
            # Value does not exist; add it
            $Return = ($this.AddKeyName([String]$Name,$Value))
        }
        # Display key values for user-interactive sessions
        $this.DisplayKey()
        # Return
        return $Return
    }
    # METHODS: Process changes method
    [Boolean] ProcessChanges() {
        # Control variable
        [Boolean] $Return = $true
        # Determine that operator is local Administrator
        If ((Test-OZOLocalAdministrator) -eq $true) {
            # Operator is local Administrator; determine if key does not exist
            If ([Boolean](Test-Path -Path $this.keyPath -ErrorAction SilentlyContinue) -eq $false) {
                # Key does not exist; try to create it
                Try {
                    New-Item -Path $this.keyPath -ErrorAction Stop
                    # Success; iterate through Values
                    ForEach ($Name in $this.Names) {
                        # Try to create each value
                        Try {
                            New-ItemProperty -Path $this.keyPath -Name $Name.Name -Value $Name.Value -PropertyType $Name.Type -ErrorAction Stop
                            # Success
                        } Catch {
                            # Failure
                            $this.Logger.Write(("Error creating " + $Name.Name + " in " + $this.keyPath + "."),"Error")
                            $Return = $false
                        }
                    }
                } Catch {
                    # Failure
                    $this.Logger.Write(("Failed to create registry key" + $this.keyPath + "."),"Error")
                    $Return = $false
                }
            } Else {
                # The key already exists; perform the remove operation - iterate through the properties in Key
                ForEach ($Property in $this.Key.Property) {
                    # Determine if the property is not found in Values.Name
                    If ($this.Names.Name -NotContains $Property) {
                        # Property is not found in Values.Name; try to delete it
                        Try {
                            Remove-ItemProperty -Path $this.keyPath -Name $Property -ErrorAction Stop
                            # Success
                        } Catch {
                            # Failure
                            $this.Logger.Write(("Failed to remove " + $Property + " from " + $this.keyPath + "."),"Error")
                            $Return = $false
                        }
                    }
                }
                # Perform the update operation - iterate through the Names
                ForEach ($Name in $this.Names) {
                    # Determine that Key.Property contains Name.Name
                    If ($this.Key.Property -Contains $Name.Name) {
                        # Key.Property contains Name.Name; determine that Name.Value is different from the Key.Property value
                        If ($Name.Value -ne $this.Key.GetValue($Name.Name)) {
                            # Name.Value and the Key.Property value do not match; determine if the types match
                            If ($Name.Type -eq $this.Key.GetValueKind($Name.Name)) {
                                # Types match; try to update
                                Try {
                                    Set-ItemProperty -Path $this.keyPath -Name $Name.Name -Value $Name.Value
                                    # Success
                                } Catch {
                                    # Failure
                                    $this.Logger.Write(("Unable to update " + $Name.Name + " in " + $this.keyPath + "."),"Error")
                                    $Return = $false
                                }
                            } Else {
                                # Types do not match
                                $this.Logger.Write(("Type mismatch when attempting to update " + $Name.Name + " in " + $this.keyPath + "."),"Error")
                                $Return = $false
                            }
                        }
                    }
                }
                # Perform the add operation - iterate through the Names in Value
                ForEach ($Name in $this.Names) {
                    # Determine if the properties in Key do not contain Value
                    If ($this.Key.Property -NotContains $Name.Name) {
                        # Key does not contain Value; try to add it
                        Try {
                            New-ItemProperty -Path $this.keyPath -Name $Name.Name -Value $Name.Value -PropertyType $Name.Type -ErrorAction Stop
                            # Success
                        } Catch {
                            # Failure
                            $this.Logger.Write(("Failed to add " + $Name.Name + " to " + $this.keyPath),"Error")
                            $Return = $false
                        }
                    }
                    
                }
            }
            # Perform the remove operation
            # Perform the add operation
            # Perform the update operation
            # Reread the key
            $this.ReadKey()
        } Else {
            # Operator is not local Administrator
            $this.Logger.Write("Writing registry keys requires Administrator privileges.","Error")
            $Return = $false
        }
        # Return
        return $Return
    }
}

Class OZORegistryKeyName {
    # PROPERTIES
    [String] $Name = $null
    [String] $Type = $null
    # METHODS: Constructor method [Binary]
    OZORegistryKeyName([String]$Name,[Byte[]]$Value) {
        # Set properties
        $this.Name = $Name
        $this.Type = "Binary"
        # Add and set Data property
        Add-Member -InputObject $this -MemberType NoteProperty -Name "Value" -TypeName "Byte[]" -Value $Value -Force
    }
    # METHODS: Constructor method [Dword]
    OZORegistryKeyName([String]$Name,[Int32]$Value) {
        # Set properties
        $this.Name = $Name
        $this.Type = "Dword"
        # Add and set Data property
        Add-Member -InputObject $this -MemberType NoteProperty -Name "Value" -TypeName "Int32" -Value $Value -Force
    }
    # METHODS: Constructor method [ExpandString|String]
    OZORegistryKeyName([String]$Name,[String]$Value) {
        # Set properties
        $this.Name = $Name
        # Determine if string contains a % character
        If ($Value -Like "*%*") {
            # Data contains a %
            $this.Type = "ExpandString"
        } Else {
            # Data does not contain a % character
            $this.Type = "String"
        }
        # Add the Data property with the correct type
        Add-Member -InputObject $this -MemberType NoteProperty -Name "Value" -TypeName "String" -Value $Value -Force
    }
    # METHODS: Constructor method [MultString]
    OZORegistryKeyName([String]$Name,[String[]]$Value) {
        # Set properties
        $this.Name = $Name
        $this.Type = "MultString"
        # Add and set Data property
        Add-Member -InputObject $this -MemberType NoteProperty -Name "Value" -TypeName "String[]" -Value $Value -Force
    }
    # METHODS: Constructor method [Qword]
    OZORegistryKeyName([String]$Name,[Int64]$Value) {
        # Set properties
        $this.Name = $Name
        $this.Type = "Qword"
        # Add and set Data property
        Add-Member -InputObject $this -MemberType NoteProperty -Name "Value" -TypeName "Int64" -Value $Value -Force
    }
}

# FUNCTIONS
Function Convert-OZORegistryPath {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Converts a registry string from one format to another, e.g., "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion" to "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion". If the input string is invalid, it is returned unmodified.
        .PARAMETER RegistryPath
        The registry string to convert. Accepts pipeline input.
        .EXAMPLE
        Convert-OZORegistryPath -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion"
        HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion
        .EXAMPLE
        Convert-OZORegistryPath -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion"
        HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion
        .EXAMPLE
        "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion" | Convert-OZORegistryPath
        HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion
        .LINK
        https://github.com/onezeroone-dev/OZORegistry-PowerShell-Module/blob/main/Documentation/Convert-OZORegistryPath.md
    #>
    # Parameters
    [CmdletBinding()] Param (
        [Parameter(Mandatory=$true,HelpMessage="The registry path to convert")][String]$RegistryPath
    )
    # Switch on RegistryPath
    Switch($RegistryPath) {
        {$_ -Like "HKCR:\*"              } { return $RegistryPath.Replace("HKCR:","HKEY_CLASSES_ROOT")   }
        {$_ -Like "HKCU:\*"              } { return $RegistryPath.Replace("HKCU:","HKEY_CURRENT_USER")   }
        {$_ -Like "HKLM:\*"              } { return $RegistryPath.Replace("HKLM:","HKEY_LOCAL_MACHINE")  }
        {$_ -Like "HKU:\*"               } { return $RegistryPath.Replace("HKU:" ,"HKEY_USERS")          }
        {$_ -Like "HKCC:\*"              } { return $RegistryPath.Replace("HKCC:","HKEY_CURRENT_CONFIG") }
        {$_ -Like "HKEY_CLASSES_ROOT\*"  } { return $RegistryPath.Replace("HKEY_CLASSES_ROOT","HKCR:")   }
        {$_ -Like "HKEY_CURRENT_USER\*"  } { return $RegistryPath.Replace("HKEY_CURRENT_USER","HKCU:")   }
        {$_ -Like "HKEY_LOCAL_MACHINE\*" } { return $RegistryPath.Replace("HKEY_LOCAL_MACHINE","HKLM:")  }
        {$_ -Like "HKEY_USERS\*"         } { return $RegistryPath.Replace("HKEY_USERS","HKU:")           }
        {$_ -Like "HKEY_CURRENT_CONFIG\*"} { return $RegistryPath.Replace("HKEY_CURRENT_CONFIG","HKCC:") }
        default                            { return $RegistryPath                                        }
    }
}

Function Get-OZORegistryKey {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns an OZORegistryKey object that represents a registry key (whether existing or not). The object contains methods for reading, adding, updating, and removing key values; and a method for processing (writing) the changes to the registry. This function (and resulting object) is the most robust and flexible use of this module.
        .PARAMETER Key
        The registry key in the short ("HKLM:\...") or long ("HKEY_LOCAL_MACHINE\...") format. Key may be an existing key or a new (non-existing) key.
        .PARAMETER Display
        Display console messages (effective only for user-interactive sessions).
        .EXAMPLE
        $ozoRegistryKey = (Get-OZORegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion" -Display)
        Using key path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion.
        Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion exists and all values read.

        Name                     Type         Value
        ----                     ----         ----
        ProgramFilesDir          String       C:\Program Files
        CommonFilesDir           String       C:\Program Files\Common Files
        ProgramFilesDir (x86)    String       C:\Program Files (x86)
        CommonFilesDir (x86)     String       C:\Program Files (x86)\Common Files
        CommonW6432Dir           String       C:\Program Files\Common Files
        DevicePath               ExpandString %SystemRoot%\inf
        MediaPathUnexpanded      ExpandString %SystemRoot%\Media
        ProgramFilesPath         ExpandString %ProgramFiles%
        ProgramW6432Dir          String       C:\Program Files
        .EXAMPLE
        $ozoRegistryKey = (Get-OZORegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion")
        .EXAMPLE
        $ozoRegistryKey = (Get-OZORegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion")
        $ozoRegistryKey.DisplayKeyValues()
        $ozoRegistryKey.SetDisplay($true)
        $ozoRegistryKey.DisplayKeyValues()

        Name                     Type         Value
        ----                     ----         ----
        ProgramFilesDir          String       C:\Program Files
        CommonFilesDir           String       C:\Program Files\Common Files
        ProgramFilesDir (x86)    String       C:\Program Files (x86)
        CommonFilesDir (x86)     String       C:\Program Files (x86)\Common Files
        CommonW6432Dir           String       C:\Program Files\Common Files
        DevicePath               ExpandString %SystemRoot%\inf
        MediaPathUnexpanded      ExpandString %SystemRoot%\Media
        ProgramFilesPath         ExpandString %ProgramFiles%
        ProgramW6432Dir          String       C:\Program Files
        ```
        .EXAMPLE
        $ozoRegistryKey = (Get-OZORegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion")
        $ozoRegistryKey.ReturnKeyNameValue("ProgramFilesDir")
        C:\Program Files
        $ozoRegistryKey.ReturnKeyNameType("ProgramFilesDIr")
        String
        .EXAMPLE
        $ozoRegistryKey = (Get-OZORegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\One Zero One")
        If (($ozoRegistryKey.AddKeyName("Version","1.0.0")) -eq $true) {
            $ozoRegistryKey.ProcessChanges()
        }
        .EXAMPLE
        $ozoRegistryKey = (Get-OZORegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\One Zero One")
        If (($ozoRegistryKey.UpdateKeyName("Version","2.0.0")) -eq $true) {
            $ozoRegistryKey.ProcessChanges()
        }
        .EXAMPLE
        $ozoRegistryKey = (Get-OZORegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\One Zero One")
        If (($ozoRegistryKey.UpdateName("Version")) -eq $true) {
            $ozoRegistryKey.ProcessChanges()
        }
        .LINK
        https://github.com/onezeroone-dev/OZORegistry-PowerShell-Module/blob/main/Documentation/Get-OZORegistryKey.md
        .NOTES
        Messages as written to the Windows Event Viewer One Zero One provider when available. Otherwise, messages are written to the Microsoft-Windows-PowerShell provider under event ID 4100.
    #>
    [CmdLetBinding()] Param (
        [Parameter(Mandatory=$true,HelpMessage="The registry key")][String]$Key,
        [Parameter(Mandatory=$false,HelpMessage="Display console messages")][Switch]$Display
    )
    # Return an OZORegistryKey object
    If ($Display -eq $true ) {
        $PSCmdlet.WriteObject(([OZORegistryKey]::new($Key,$true)))
    } Else {
        $PSCmdlet.WriteObject(([OZORegistryKey]::new($Key,$false)))
    }
}

Function Read-OZORegistryKeyNameValue {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        A simple function for returning the value for a single registry key name. Returns "Key path is not valid" if the path is not valid, "Key not found" if the path does not exist, "Could not read key names" if the key names could not be read, and "Unhandled data type" if the data cannot be returned.
        .PARAMETER Key
        The registry key.
        .PARAMETER Name
        The key name.
        .EXAMPLE
        Read-OZORegistryKeyNameValue -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion" -Name "ProgramFilesDir"
        C:\Program Files
        .EXAMPLE
        Read-OZORegistryKeyNameValue -Key "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion" -Name "ProgramFilesDir"
        C:\Program Files
        .LINK
        https://github.com/onezeroone-dev/OZORegistry-PowerShell-Module/blob/main/Documentation/Read-OZORegistryKeyNameValue.md
        .NOTES
        Messages as written to the Windows Event Viewer One Zero One provider when available. Otherwise, messages are written to the Microsoft-Windows-PowerShell provider under event ID 4100.
    #>
    # Parameters
    [CmdletBinding()] Param (
        [Parameter(Mandatory=$true,HelpMessage="The registry key")][String]$Key,
        [Parameter(Mandatory=$true,HelpMessage="The key name")][String]$Name
    )
    # Instantiate an OZORegistryKey object and return the value data
    return ([OZORegistryKey]::new($Key,$false)).ReturnKeyNameValue($Name)
}

Function Read-OZORegistryKeyNameType {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        A simple function for returning the _type_ of a single registry key name. Returns "Key path is not valid" if the path is not valid, "Key not found" if the path does not exist, "Could not read key names" if the key names could not be read, and "Unhandled data type" if the data cannot be returned.
        .PARAMETER Key
        The registry key.
        .PARAMETER Name
        The key name.
        .EXAMPLE
        Read-OZORegistryKeyNameType -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion" -Name "ProgramFilesDir"
        String
        .EXAMPLE
        Read-OZORegistryKeyNameType -Key "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion" -Name "ProgramFilesDir"
        String
        .LINK
        https://github.com/onezeroone-dev/OZORegistry-PowerShell-Module/blob/main/Documentation/Read-OZORegistryKeyNameType.md
        .NOTES
        Messages as written to the Windows Event Viewer One Zero One provider when available. Otherwise, messages are written to the Microsoft-Windows-PowerShell provider under event ID 4100.
    #>
    # Parameters
    [CmdletBinding()] Param (
        [Parameter(Mandatory=$true,HelpMessage="The registry key")][String]$Key,
        [Parameter(Mandatory=$true,HelpMessage="The key name")][String]$Name
    )
    # Instantiate an OZORegistryKey object and return the value type
    return ([OZORegistryKey]::new($Key,$false)).ReturnKeyNameType($Name)
}

Function Write-OZORegistryKeyNameValue {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        A simple function for adding or updating a single registry key name. If the key + name does not exist, it will be created. If it does exist, it will be updated. Returns True on success and False on failure. Failures are typically due to inadequate permissions or type mismatches.
        .PARAMETER Key
        The registry key.
        .PARAMETER Name
        The key name.
        .PARAMETER Value
        The name value.
        .PARAMETER Type
        The type. Valid types are "Binary", "Dword", "ExpandString", "MultString", "Qword", and "String". Defaults to "String".
        .EXAMPLE
        Write-OZORegistryKeyValueData -Key "HKEY_LOCAL_MACHINE\SOFTWARE\One Zero One" -Value "Acronym" -Data "OZO" -Type "String"
        .LINK
        https://github.com/onezeroone-dev/OZORegistry-PowerShell-Module/blob/main/Documentation/Write-OZORegistryKeyNameValue.md
        .NOTES
        Requires Administrator privileges. Messages as written to the Windows Event Viewer One Zero One provider when available. Otherwise, messages are written to the Microsoft-Windows-PowerShell provider under event ID 4100.
    #>
    # Parameters
    [CmdletBinding()] Param (
        [Parameter(Mandatory=$true,HelpMessage="The registry key")][String]$Key,
        [Parameter(Mandatory=$true,HelpMessage="The key name")][String]$Name,
        [Parameter(Mandatory=$true,HelpMessage="The name value")]$Value,
        [Parameter(Mandatory=$false,HelpMessage="The type")][ValidateSet("Binary","Dword","ExpandString","MultString","Qword","String")][String]$Type = "String"
    )
    # Instantiate an OZORegistryKey object and return the result of UpdateKeyValue
    [PSCustomObject] $ozoRegistryKey = ([OZORegistryKey]::new($Key,$false))
    # Determine if the name + value can be updated or added
    If ($ozoRegistryKey.UpdateKeyName($Name,$Value) -eq $true) {
        # Name + value added; return the result of ProcessChanges
        return ($ozoRegistryKey.ProcessChanges())
    }
}

Export-ModuleMember -Function Convert-OZORegistryString,Get-OZORegistryKey,Read-OZORegistryKeyNameValue,Read-OZORegistryKeyNameType,Write-OZORegistryKeyNameValue
