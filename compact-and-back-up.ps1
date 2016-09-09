#The comments are in zh-cn(simplified Chinese) with UTF-8.
#设置7-zip.exe的文件路径。需要先安装7-zip软件。
[String]$zip = "C:\Program Files\7-Zip\7z.exe"

#设置压缩文件的名称。
[String]$name = "KeePass-2.34.7z"

#设置需要备份的文件或者文件夹的路径。
[String]$path = "E:\Software\KeePass-2.34"

#在系统的Temp文件夹中建立临时文件夹，以“年月日时分秒”为名称。
[String]$temp = "$($env:TMP)\$((Get-Date).ToString("yyyyMMddHHmmss"))"
New-Item -ItemType Directory -Path $temp

#在新生产的临时文件夹中建立压缩文件。
cd $temp
& $zip a $name $path

#判断压缩文件是否建立成功。
if ($?)
{
	#设置备份路径，此处在个人文件夹下的文档文件夹下建立了一个专门用于备份的文件夹，并在按照“年月”的格式建立子文件夹，进一步以“年月日”的格式建立子文件夹。
	[String]$destinationPath = "$($HOME)\Documents\Back_up_daily\$((Get-Date).ToString("yyyyMM"))\$((Get-Date).ToString("yyyyMMdd"))"

    #如果目标文件夹不存在，则新建。
	if (!(Test-Path -Path $destinationPath))
	{
		New-Item -ItemType Directory -Path $destinationPath
	}

    #从临时文件夹中，将压缩文件复制到目标文件夹。如果已存在同名文件，则一定是当天的，以后者为准，强制覆盖。
	Copy-Item $name $destinationPath -Force
	
    #检测移动硬盘是否存在。在计算机管理中，将特定的移动硬盘的盘符设置为靠后的盘符，以防备份到他人的移动硬盘中，考虑到自己的电脑可能会有他人借用。
	if (Test-Path -Path "O:\")
	{
		#设置O盘中的备份路径。
		[String]$destinationPathO = "O:\Back_up_daily\$((Get-Date).ToString("yyyyMM"))\$((Get-Date).ToString("yyyyMMdd"))"

        #复制压缩文件到目标文件夹。
		if (!(Test-Path -Path $destinationPathO))
		{
			New-Item -ItemType Directory -Path $destinationPathO
		}
		Copy-Item $name $destinationPathO -Force
	}	
}

#切换到其他路径，删除系统Temp文件夹中建立的临时文件夹，以及其中的压缩文件。
cd $HOME
Remove-Item $temp -Recurse
