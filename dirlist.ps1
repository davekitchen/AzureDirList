#
# ======================================================================================================
# Author:			D.Kitchen
# Created:			10-Nov-2019
# Description:		Powershell script for getting a directory listing of all files stored in all storage
#					accounts within the entire subscription. Think of this as a DIR c:\
#
# History:
# Date			Who	Ver		Desc
# 10-Nov-2019	DJK 0.1		Initial Version
# ======================================================================================================
#

Connect-AzureRmAccount #-Subscription ""

$storeList = Get-AzureRmStorageAccount

Write-Output "ResourceGroupName`tStorageAccountName`tContainerName`tObjectNameAndFolder`tLastModified`tLengthBytes"

#$results = @()
foreach($storageAccount in $storeList)
{
    $storeKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $storageAccount.ResourceGroupName -AccountName $storageAccount.StorageAccountName).Value[0]
    $storageContext = New-AzureStorageContext -StorageAccountName $storageAccount.StorageAccountName -StorageAccountKey $storeKey
    
    $storageContainers = Get-AzureStorageContainer -Context $storageContext
    foreach($storageContainer in $storageContainers)
    {
        $BlobObjects = Get-AzureStorageBlob -Context $storageContext -Container $storageContainer.Name
        foreach($BlobObject in $BlobObjects)
        {
            #$fileRec = @{
            #                ResourceGroupName = $storageAccount.ResourceGroupName;
            #                StorageAccountName = $storageAccount.StorageAccountName;
            #                ContainerName = $storageContainer.Name;
            #                ObjectNameAndFolder = $BlobObject.Name;
            #                LastModified = $BlobObject.LastModified;
            #                Length = $BlobObjects.Length
            #            }
            #$fileRec
            #$results += $fileRec

            $displayResult =    $storageAccount.ResourceGroupName + "`t"
            $displayResult +=   $storageAccount.StorageAccountName + "`t"
            $displayResult +=   $storageContainer.Name + "`t"
            $displayResult +=   $BlobObject.Name + "`t"
            $displayResult +=   $BlobObject.LastModified.ToString() + "`t"
            $displayResult +=   $BlobObject.Length.ToString()

            Write-Output $displayResult
        }
    }
}
