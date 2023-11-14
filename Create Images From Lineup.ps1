# This script will read each pokemon name in $PokemonLineupFullFilePath
# and create a corresponding file in $StreamMediaDestinationFolder
# named pokemon1.png, pokemon2.png, pokemon3.png...
# In your stream overlay, you can select pokemon1.png, etc as your image sources, then run
# this script when you need to update the image based on the text file $PokemonLineupFullFilePath.

$PokemonSourceImagesFolder = ".\PokemonSourceImages\"

# If your media sources are stored somewhere else, update this
$StreamMediaDestinationFolder = ".\OverlayMediaSource\"

# Text file containing the names of your pokemon, separated by newlines
# Each name must match a file name in $PokemonSourceImagesFolder
$PokemonLineupFullFilePath = ".\Pokemon Lineup.txt"

$Index = 1;
foreach($PokemonName in [System.IO.File]::ReadLines($PokemonLineupFullFilePath))
{
    $DestinationPath = $StreamMediaDestinationFolder + "pokemon" + $Index + ".png"
    $DestinationPathShadow = $StreamMediaDestinationFolder + "shadow" + $Index + ".png"

    # Shadow
    if(($PokemonName.Length -gt 7) -and $PokemonName.Substring($PokemonName.Length - 7, 7).ToLower() -eq "_shadow")
    {
        $PokemonName = $PokemonName.Substring(0, $PokemonName.Length - 7)
        $SourcePathShadow = $PokemonSourceImagesFolder + "shadow.png"
    }
    else
    {
        $SourcePathShadow = $PokemonSourceImagesFolder + "empty.png"
    }

    copy-item $SourcePathShadow -Destination $DestinationPathShadow

	$SourcePath = $PokemonSourceImagesFolder + $PokemonName.ToLower() + ".png"

	$SourceFileExists = Test-Path -Path $SourcePath
	if (-Not $SourceFileExists)
	{
		$SourcePath = $PokemonSourceImagesFolder + "noimage.png"
	}

	copy-item $SourcePath -Destination $DestinationPath
	$Index++
}