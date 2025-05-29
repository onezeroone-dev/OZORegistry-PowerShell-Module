# CLASSES
Class OZORegistryKey {
    # PROPERTIES: Booleans, Strings
    [Boolean] $Display    = $false
    [Boolean] $keyExists  = $true
    [Boolean] $keyValid   = $true
    [Boolean] $valuesRead = $true
    [String]  $keyPath    = $null
    # PROPERTIES: PSCustomObjects
    [PSCustomObject] $Key    = $null
    [PSCustomObject] $Logger = $null
    # PROPERTIES: PSCustomObject Lists
    [System.Collections.Generic.List[PSCustomObject]] $Values = @()
    # METHODS: Constructor method
    OZORegistryKey([String]$KeyPath,[Boolean]$Display) {
        # Set properties
        $this.Display = $Display
        # Create a logger
        $this.Logger = (New-OZOLogger)
        # Determine if Display is false and if so disable Logger display
        If ($this.Display -eq $false) { $this.Logger.SetConsoleOutput("off") }
        # Call ValidateKey to determine if KeyPath format is valid [and populate this.KeyPath]
        If ($this.ValidateKeyPath($KeyPath) -eq $true) {
            # Key is valid
            $this.Logger.Write(("Using key path " + $this.keyPath + "."),"Information")
            # Call ReadKey to set keyExists [and populate registryKey]
            If ($this.ReadKey() -eq $true) {
                # Retrieved key; call ReadKeyValues to populate registryKeyValues
                If ($this.ReadKeyValues() -eq $true) {
                    # Able to read all key values; display for user-interactive sessions
                    $this.Logger.Write(($this.keyPath + " exists and all values read."),"Information")
                    # Display values for user-interactive sessions
                    $this.DisplayKeyValues()                    
                } Else {
                    # No values found or unable to read all key values; log
                    $this.Logger.Write(($this.keyPath + " contains no values or some values could not be read."),"Warning")
                    $this.valuesRead = $false
                }
            } Else {
                # Unable to retrieve key; log
                $this.Logger.Write(("Key `"" + $KeyPath + "`" did could not be read."),"Error")
                $this.keyExists  = $false
                $this.valuesRead = $false
            }
        } Else {
            # Key format is not valid; log
            $this.Logger.Write(("Key `"" + $KeyPath + "`" is not a valid path."),"Error")
            $this.keyExists  = $false
            $this.keyValid   = $false
            $this.valuesRead = $false
        }
    }
    # METHODS: Validate key method
    Hidden [Boolean] ValidateKeyPath([String]$KeyPath) {
        # Control variable
        [Boolean] $Return = $true
        # Local variables
        [String] $keyPathStart = $null
        [Array]  $validShortStrings = @("HKCR:","HKCU:","HKLM:","HKU:","HKCC:")
        [Array]  $validLongStrings  = @("HKEY_CLASSES_ROOT","HKEY_CURRENT_USER","HKEY_LOCAL_MACHINE","HKEY_USERS","HKEY_CURRENT_CONFIG")
        # Determine if KeyPath contains a \ character
        If ($KeyPath -Like "*\*") {
            # KeyPath contains a \ character; split the string on \ and store the first string as keyPathStart
            $keyPathStart = ($KeyPath -Split "\\" )[0]
            # Determine if the first string is found in validPaths
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
        If ($this.keyValid -eq $true -And $null -ne $this.keyPath) {
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
    # METHODS: Read key values method
    Hidden [Boolean] ReadKeyValues() {
        # Control variable
        [Boolean] $Return = $true
        # Determine that registryKey is populated
        If ($null -ne $this.Key) {
            # Registry key is populated; determine if it has no properties
            If ($this.Key.Property.Count -eq 0) {
                # There are no properties; nothing to do
                $Return = $false
            # Otherwise determine if the Property count is 1 and it's Value is (default) 
            } ElseIf ($this.Key.ValueCount -eq 1 -And $this.Key.Property -Contains "(default)") {
                # Key contains only one property and it is the (default) property; nothing to do
                $Return = $false
            } Else {
                # Key contains one or more values that are not (default); iterate through the values
                ForEach ($keyProperty in $this.Key.Property) {
                    $this.Values.Add(([OZORegistryKeyValue]::new($keyProperty,$this.Key.GetValue($keyProperty,$null,"DoNotExpandEnvironmentNames"))))
                }
                # Determine if the count of registry does not match the number of objects in the Values list
                If ($this.Key.ValueCount -ne $this.Values.Count) {
                    # The counts do not match (some value could not be represented with a RegistryKeyValue object); clear Values
                    $this.Values = @()
                    $Return = $false
                }
            }
        }
        # Return
        return $Return
    }
    # METHODS: Display key values
    [Void] DisplayKeyValues() {
        # Determine if session is user-interactive
        If ((Get-OZOUserInteractive) -eq $true -And $this.Display -eq $true) {
            # Session is user-interactive and Display is True
            $this.Values | Select-Object -Property Name,Type,Data | Format-Table | Out-Host
        }
    }
    # METHODS: Get registry key value data
    [Object] ReturnKeyValueData($Name) {
        If ($this.keyValid -eq $true) {
            # Key path is valid; determine if the key exists
            # determine if the value exists in the key
            If ($this.keyExists -eq $true) {
                # Key exists; determine if the values were read
                If ($this.valuesRead -eq $true) {
                    #Value exists in Values list
                    If ($this.Values.Name -Contains $Name) {
                        # Get the specific Value as a local PSCustomObject
                        [PSCustomObject]$keyValue = ($this.Values | Where-Object {$_.Name -eq $Name})
                        # Switch on Type
                        Switch ($keyValue.Type.ToLower()) {
                            "binary"       { return [Byte[]]   $keyValue.Data }
                            "dword"        { return [Int32]    $keyValue.Data }
                            "expandstring" { return [String]   $keyValue.Data }
                            "multstring"   { return [String[]] $keyValue.Data }
                            "qword"        { return [Int64]    $keyValue.Data }
                            "string"       { return [String]   $keyValue.Data }
                            default        { return [String]   "Unhandled data type" }
                        }
                    } Else {
                        # Name not found in Values.Name
                        return "Value not found in Key"
                    }
                } Else {
                    # Could not read values
                    return "Could not read key values"
                }
            } Else {
                # Key path does not exist
                return "Not found"
            }
        } Else {
            # Key Path is not valid
            return "Invalid path"
        }
        #Return
        return "Unsupported"
    }
    # METHODS: Get registry key value type
    [String] ReturnKeyValueType($Name) {
        # Determine if key is valid
        If ($this.keyValid -eq $true) {
            # Key path is valid; determine if the key exists
            # determine if the value exists in the key
            If ($this.keyExists -eq $true) {
                # Key exists; determine if the values were read
                If ($this.valuesRead -eq $true) {
                    #Value exists in Values list
                    If ($this.Values.Name -Contains $Name) {
                        # Get the specific Value as a local PSCustomObject
                        return ($this.Values | Where-Object {$_.Name -eq $Name}).Type
                    }
                } Else {
                    # Could not read values
                    return "Could not read key values"
                }
            } Else {
                # Key path does not exist
                return "Not found"
            }
        } Else {
            # Key Path is not valid
            return "Invalid path"
        }
        # Return
        return "Unsupported"
    }
    # METHODS: Add key value method
    [Void] AddKeyValue([String]$Name,$Data) {
        # Determine if value already exists in key
        If ($this.Values.Name -Contains $Name) {
            # Values already contains Value
            $this.Logger.Write(("Key already contains a " + $Name + " value; skipping."),"Warning")
        } Else {
            # Values does not already contain this Value; add to list
            $this.Values.Add(([OZORegistryKeyValue]::new($Name,$Data)))
        }
        # Display key values for user-interactive sessions
        $this.DisplayKeyValues()
    }
    # METHODS: Add key value method
    [Void] RemoveKeyValue([String]$Name) {
        # Determine if value exists in key
        If ($this.Values.Name -Contains $Name) {
            # Values contains Value; remove it
            $this.Values.Remove(($this.Values | Where-Object {$_.Name -eq $Name}))
        } Else {
            # Values does not contain Value; nothing to do
            $this.Logger.Write(("Key does not contain a " + $Name + " value; skipping."),"Warning")
        }
        # Display key values for user-interactive sessions
        $this.DisplayKeyValues()
    }
    # METHODS: Add key value method
    [Void] UpdateKeyValue([String]$Name,$Data) {
        # Determine if this value exists in Values
        If ($this.Values.Name -Contains $Name) {
            # Value exists; determine if type of value matches Data type
            If (($this.Values | Where-Object {$_.Name -eq $Name}).Data.GetType() -eq $Data.GetType()) {
                # Data types match; update with new Data
                ($this.Values | Where-Object {$_.Name -eq $Name}).Data = $Data
            } Else {
                $this.Logger.Write("Data type does not match; value will not be updated.","Warning")
            }
        } Else {
            # Value does not exist; add it
            $this.AddKeyValue([String]$Name,$Data)
        }
        # Display key values for user-interactive sessions
        $this.DisplayKeyValues()
    }
    # METHODS: Write key values method
    [Boolean] ProcessChanges() {
        # Control variable
        [Boolean] $Return = $true
        # Determine that operator is local Administrator
        If (Test-OZOLocalAdministrator -eq $true) {
            # Operator is local Administrator; determine if key does not exist
            If ([Boolean](Test-Path -Path $this.keyPath -ErrorAction SilentlyContinue) -eq $false) {
                # Key does not exist; try to create it
                Try {
                    New-Item -Path $this.keyPath -ErrorAction Stop
                    # Success; iterate through Values
                    ForEach ($Value in $this.Values) {
                        # Try to create each value
                        Try {
                            New-ItemProperty -Path $this.keyPath -Name $Value.Name -Value $Value.Data -PropertyType $Value.Type -ErrorAction Stop
                            # Success
                        } Catch {
                            # Failure
                            $this.Logger.Write(("Error creating " + $Value.Name + " in " + $this.keyPath + "."),"Error")
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
                    If ($this.Values.Name -NotContains $Property) {
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
                # Perform the update operation - iterate through the Names in Value
                ForEach ($Value in $this.Value) {
                    # Determine that Key.Property contains Value.Name
                    If ($this.Key.Property -Contains $Value.Name) {
                        # Key.Proeperty contains Value.Name; determine that Value.Data is different from the Key.Property value
                        If ($Value.Data -ne $this.Key.GetValue($Value.Name)) {
                            # Value.Data and the Key.Property value do not match; determine that the data types match
                            If ($Value.Type -eq $this.Key.GetValueKind($Value.Name)) {
                                # Types match; try to update
                                Try {
                                    Set-ItemProperty -Path $this.keyPath -Name $Value.Name -Value $Value.Data
                                    # Success
                                } Catch {
                                    # Failure
                                    $this.Logger.Write(("Unable to update " + $Value.Name + " in " + $this.keyPath + "."),"Error")
                                    $Return = $false
                                }
                            } Else {
                                # Types do not match
                                $this.Logger.Write(("Data type mismatch when attempting to update " + $Value.Name + " in " + $this.keyPath + "."),"Error")
                                $Return = $false
                            }
                        }
                    }
                }
                # Perform the add operation - iterate through the Names in Value
                ForEach ($Value in $this.Values) {
                    # Determine if the properties in Key do not contain Value
                    If ($this.Key.Property -NotContains $Value.Name) {
                        # Key does not contain Value; try to add it
                        Try {
                            New-ItemProperty -Path $this.keyPath -Name $Value.Name -Value $Value.Data -PropertyType $Value.Type -ErrorAction Stop
                            # Success
                        } Catch {
                            # Failure
                            $this.Logger.Write(("Failed to add " + $Value.Name + " to " + $this.keyPath),"Error")
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

Class OZORegistryKeyValue {
    # PROPERTIES
    [String] $Name = $null
    [String] $Type = $null
    # METHODS: Constructor method [Binary]
    OZORegistryKeyValue([String]$Name,[Byte[]]$Data) {
        # Set properties
        $this.Name = $Name
        $this.Type = "Binary"
        # Add and set Data property
        Add-Member -InputObject $this -MemberType NoteProperty -Name "Data" -TypeName "Byte[]" -Value $Data -Force
    }
    # METHODS: Constructor method [Dword]
    OZORegistryKeyValue([String]$Name,[Int32]$Data) {
        # Set properties
        $this.Name = $Name
        $this.Type = "Dword"
        # Add and set Data property
        Add-Member -InputObject $this -MemberType NoteProperty -Name "Data" -TypeName "Int32" -Value $Data -Force
    }
    # METHODS: Constructor method [ExpandString|String]
    OZORegistryKeyValue([String]$Name,[String]$Data) {
        # Set properties
        $this.Name = $Name
        # Determine if string contains a % character
        If ($Data -Like "*%*") {
            # Data contains a %
            $this.Type = "ExpandString"
        } Else {
            # Data does not contain a % character
            $this.Type = "String"
        }
        # Add the Data property with the correct type
        Add-Member -InputObject $this -MemberType NoteProperty -Name "Data" -TypeName "String" -Value $Data -Force
    }
    # METHODS: Constructor method [MultString]
    OZORegistryKeyValue([String]$Name,[String[]]$Data) {
        # Set properties
        $this.Name = $Name
        $this.Type = "MultString"
        # Add and set Data property
        Add-Member -InputObject $this -MemberType NoteProperty -Name "Data" -TypeName "String[]" -Value $Data -Force
    }
    # METHODS: Constructor method [Qword]
    OZORegistryKeyValue([String]$Name,[Int64]$Data) {
        # Set properties
        $this.Name = $Name
        $this.Type = "Qword"
        # Add and set Data property
        Add-Member -InputObject $this -MemberType NoteProperty -Name "Data" -TypeName "Int64" -Value $Data -Force
    }
}

# FUNCTIONS
Function Convert-OZORegistryPath {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Converts a registry string from one format to another, e.g., "HKCU:\SOFTWARE\Google\Chrome" to "HKEY_CURRENT_USER\SOFTWARE\Google\Chrome". If the input string is invalid, it is returned unmodified.
        .PARAMETER RegistryPath
        The registry string to convert. Accepts pipeline input.
        .EXAMPLE
        Convert-OZORegistryPath -Path "HKEY_CURRENT_USER\SOFTWARE\Google\Chrome"
        HKCU:\SOFTWARE\Google\Chrome
        .EXAMPLE
        Convert-OZORegistryPath -Path "HKCU:\SOFTWARE\Google\Chrome"
        HKEY_CURRENT_USER\SOFTWARE\Google\Chrome
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
        Returns an OZORegistryKey object.
        .PARAMETER Key
        The registry key in the short ("HKLM:\...") or long ("HKEY_LOCAL_MACHINE\...") format. Key may be an existing key or a new (non-existing) key.
        .PARAMETER Display
        Display console messages (effective only for user-interactive sessions).
        .EXAMPLE
        $ozoRegistryKey = (Get-OZORegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\One Zero One")
        .LINK
        https://github.com/onezeroone-dev/OZORegistry-PowerShell-Module/blob/main/Documentation/Get-OZORegistryKey.md
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

Function Read-OZORegistryKeyValueData {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        A simple function for returning the data from a single registry key value. Returns "Invalid path" if the path is not valid, "Not found" if the path does not exist, "Could not read values" if the key values could not be read, and "Unhandled data type" if the data cannot be returned.
        .PARAMETER Key
        The registry key.
        .PARAMETER Value
        The key value.
        .EXAMPLE
        Read-OZORegistryKeyValueData -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion" -Value "ProgramFilesDir"
        C:\Program Files
        .EXAMPLE
        Read-OZORegistryKeyValueData -Key "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion" -Value "ProgramFilesDir"
        C:\Program Files
        .LINK
        https://github.com/onezeroone-dev/OZORegistry-PowerShell-Module/blob/main/Documentation/Read-OZORegistryKeyValueData.md
    #>
    # Parameters
    [CmdletBinding()] Param (
        [Parameter(Mandatory=$true,HelpMessage="The registry key")][String]$Key,
        [Parameter(Mandatory=$true,HelpMessage="The key value")][String]$Value
    )
    # Instantiate an OZORegistryKey object and return the value data
    return ([OZORegistryKey]::new($Key,$false)).ReturnKeyValueData($Value)
}

Function Read-OZORegistryKeyValueType {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        A simple function for returning the data _type_ from a single registry key value. Returns "Invalid path" if the path is not valid, "Not found" if the path does not exist, and "Could not read values" if the key values could not be read.
        .PARAMETER Key
        The registry key.
        .PARAMETER Value
        The key value.
        .EXAMPLE
        Read-OZORegistryKeyValueType -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion" -Value "ProgramFilesDir"
        String
        .EXAMPLE
        Read-OZORegistryKeyValueType -Key "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion" -Value "ProgramFilesDir"
        String
        .LINK
        https://github.com/onezeroone-dev/OZORegistry-PowerShell-Module/blob/main/Documentation/Read-OZORegistryKeyValueType.md
    #>
    # Parameters
    [CmdletBinding()] Param (
        [Parameter(Mandatory=$true,HelpMessage="The registry key")][String]$Key,
        [Parameter(Mandatory=$true,HelpMessage="The key value")][String]$Value
    )
    # Instantiate an OZORegistryKey object and return the value type
    return ([OZORegistryKey]::new($Key,$false)).ReturnKeyValueType($Value)
}

Function Write-OZORegistryKeyValueData {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        A simple function for adding or updating a single registry key value. If the key value does not exist, it will be created. If it does exist, it will be updated. Returns True on success and False on failure. Failures are typically due to inadequate permissions or data type mismatches.
        .PARAMETER Key
        The registry key.
        .PARAMETER Value
        The key value.
        .PARAMETER Data
        The value data.
        .PARAMETER Type
        The data type. Valid types are "Binary", "Dword", "ExpandString", "MultString", "None", "Qword", "String", and "Unknown". Defaults to "String".
        .EXAMPLE
        Write-OZORegistryKeyValueData -Key "HKEY_LOCAL_MACHINE\SOFTWARE\One Zero One" -Value "Acronym" -Data "OZO" -Type "String"
        .LINK
        https://github.com/onezeroone-dev/OZORegistry-PowerShell-Module/blob/main/Documentation/Write-OZORegistryKeyValueData.md
        .NOTES
        Requires Administrator privileges.
    #>
    # Parameters
    [CmdletBinding()] Param (
        [Parameter(Mandatory=$true,HelpMessage="The registry key")][String]$Key,
        [Parameter(Mandatory=$true,HelpMessage="The key value")][String]$Value,
        [Parameter(Mandatory=$true,HelpMessage="The value data")]$Data,
        [Parameter(Mandatory=$false,HelpMessage="The data type")][ValidateSet("Binary","Dword","ExpandString","MultString","Qword","String")][String]$Type = "String"
    )
    # Instantiate an OZORegistryKey object and return the result of UpdateKeyValue
    return ([OZORegistryKey]::new($Key,$false)).UpdateKeyValue($Value,$Data)
}

Export-ModuleMember -Function Convert-OZORegistryString,Get-OZORegistryKey,Read-OZORegistryKeyValueData,Read-OZORegistryKeyValueType,Write-OZORegistryKeyValueData
