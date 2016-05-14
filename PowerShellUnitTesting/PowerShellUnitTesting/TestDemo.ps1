function Myfunction($myparam)
{
	$myparam | Write-Output
}

function GetMyOwnDate()
{ 
	return Get-Date
}

function DoStuffToFolders($folder)
{
	Myfunction $folder

	if (Get-Item $folder)
	{
		Remove-Item -Path $folder
		return "Deleted Folder"
	}
	else
	{
		New-Item -ItemType Directory -Name $folder
		return "Created folder"
	}
}



