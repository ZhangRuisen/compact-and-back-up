#Need to install 7-zip firstly.
#Set the dictionary of 7-zip.
[String]$zip = "C:\Program Files\7-Zip\7z.exe"

#Set the name of compacted file.
[String]$name = "CompactedFileName_$((Get-Date).ToString("yyyyMMdd")).7z"

#Set the path of file or dictionary that you want to compact and back up.
[String]$path = "C:\test\"

[String]$temp = "$($env:TMP)\$((Get-Date).ToString("yyyyMMddHHmmss"))"
New-Item -ItemType Directory -Path $temp
cd $temp
& $zip a $name $path

if ($?)
{
    #Set the dictionary that you want to restore.
	[String]$destinationPath = "$($HOME)\Documents\Back_up\$((Get-Date).ToString("yyyyMM"))"

	if (!(Test-Path -Path $destinationPath))
	{
		New-Item -ItemType Directory -Path $destinationPath
	}

	Copy-Item $name $destinationPath -Force
	
    #Set the dictionary of other drive that you want to restore.
	if (Test-Path -Path "O:\")
	{
		[String]$destinationPathO = "O:\Back_up\$((Get-Date).ToString("yyyyMM"))"

		if (!(Test-Path -Path $destinationPathO))
		{
			New-Item -ItemType Directory -Path $destinationPathO
		}
		Copy-Item $name $destinationPathO -Force
	}	
}

cd $HOME
Remove-Item $temp -Recurse