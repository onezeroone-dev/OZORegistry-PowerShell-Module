Function Convert-OZORegistryString {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Converts a registry string from one format to another, e.g., "HKCU:\SOFTWARE\Google\Chrome" to "HKEY_CURRENT_USER\SOFTWARE\Google\Chrome". If the input string is invalid, it is returned unmodified.
        .PARAMETER RegistryPath
        The registry string to convert. Accepts pipeline input.
        .EXAMPLE
        Convert-OZORegistryString -Path "HKEY_CURRENT_USER\SOFTWARE\Google\Chrome"
        HKCU:\SOFTWARE\Google\Chrome
        .EXAMPLE
        
    #>
}

Function Read-OZORegistryValue {

}

Function Read-OZORegistryValueType {

}

Function Write-OZORegistryValue {

}

Export-ModuleMember -Function Convert-OZORegistryString,Read-OZORegistryValue,Read-OZORegistryValueType,Write-OZORegistryValue