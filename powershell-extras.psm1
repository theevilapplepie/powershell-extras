# Load includes
gci $($PSScriptRoot + "\includes\*.ps1") | %{ . "$_" }

# Export Everything ;)
Export-ModuleMember -alias * -function *