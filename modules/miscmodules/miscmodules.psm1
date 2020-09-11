# Load misc modules
gci $($PSScriptRoot + "\modules\*.ps1") | %{ . "$_" }

# Export Everything ;)
Export-ModuleMember -alias * -function *