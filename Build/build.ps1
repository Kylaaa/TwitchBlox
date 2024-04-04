param(
	[Parameter(Mandatory=$false)]
	[Alias("Project")]
	[string]$projectName = "default",

	[Parameter(Mandatory=$false)]
	[Alias("Output")]
	[string]$outputName = "TwitchBloxLibrary-Wally.rbxm"
)

$originalDirectory = $pwd
$projectRoot = Resolve-Path -Path "$PSScriptRoot\.."
$binDirectory = "$projectRoot\Bin"

$outFile = "$projectRoot\Bin\$outputName"

cd $projectRoot
wally install
rojo build --output $outFile "$projectName.project.json"

cd $originalDirectory