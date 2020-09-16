function Get-Hypervisor {

    $ComputerSystemInfo = Get-WmiObject -Class Win32_ComputerSystem
    $Hypervisor = "Unknown"
    $Virtual = $true

    # Check based on Model
    switch ($ComputerSystemInfo.Model) { 
        
        # Check for VMware Machine Type 
        "VMware Virtual Platform" { 
            Write-Output "This Machine is Virtual on VMware Platform."
            Break 
        } 

        # Check for Oracle VM Machine Type 
        "VirtualBox" { 
            Write-Output "This Machine is Virtual on Oracle VM / VirtualBox Platform."
            Break 
        } 
        
        # We do not have a Model match, Switch on Manufacturer
        default {

            Switch ($ComputerSystemInfo.Manufacturer) {

                # Check for Xen VM Machine Type
                "Xen" {
                    $Hypervisor = "Xen"
                    Break
                }

                # Check for KVM VM Machine Type
                "QEMU" {
                    $Hypervisor = "QEMU/KVM"
                    Break
                }
                # Check for Hyper-V Machine Type 
                "Microsoft Corporation" { 
                    if (get-service WindowsAzureGuestAgent -ErrorAction SilentlyContinue) {
                        $Hypervisor = "Azure"
                    }
                    else {
                        $Hypervisor = "Hyper-V"
                    }
                    Break
                }
                # Check for Google Cloud Platform
                "Google" {
                    $Hypervisor = "Google"
                    Break
                }

                # We do not have a Manufacturer Match, Any additional checks?
                default { 
                    # Check for AWS
                    if ((((Get-WmiObject -query "select uuid from Win32_ComputerSystemProduct" | Select-Object UUID).UUID).substring(0, 3) ) -match "EC2") {
                        $Hypervisor = "AWS"
                    }
                    # Otherwise it is a physical Box 
                    else {
                        $Hypervisor = $false
                        $Virtual = $false
                        Break
                    }
                } 
            }                  
        } 
    }
    New-Object PSObject -Property @{
        'isVirtual' = $Virtual
        'Hypervisor' = $Hypervisor
    }
}

Function Get-IsVirtual {
    $(Get-Hypervisor).isVirtual
}

Set-Alias -Name Is-Virtual -Value Get-IsVirtual