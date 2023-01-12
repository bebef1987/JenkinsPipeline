param(
                        $ProjectFilePath=".\\",
                        $OutputFilePath="$(Get-Date -Format \'yyyy-MM-dd-HH-mm-ss\')-Workflow-Analysis.json",
                        $StandaloneAnalyzerPath = "C:\\Users\\sebastian.balan\\Downloads\\bin\\Debug\\net6.0-windows7.0\\UiPath.ProjectPackager.dll",
                        $PolicyfilePath = ".\\uipath.policy.Development.json"
                    )
                    
                
                    Write-Output "$(Get-Date -Format 'HH:mm:ss') - STARTED - Static Code Analyzer"
                    
                    $Command = "dotnet $StandaloneAnalyzerPath analyze -p `'$ProjectFilePath`' --policy_file $PolicyfilePath"
                    Invoke-Expression $Command | Out-File -FilePath $OutputFilePath
                    $rp = Get-Content $OutputFilePath | foreach {$_.replace("#json","")}
                    
                    Set-Content -Path $OutputFilePath -Value $rp
                    #Write-Output $rp
                    $JO = Get-Content $OutputFilePath | ConvertFrom-Json
                    
                    #Write-Output $JO[1]
                    $totalErros=0
                    
                    
                    $ErrorCode = "Error Code"
                    $ErrorSeverity = "Error Severity"
                    $Description = "Description"
                    $Recommendation = "Recommendation"
                    $FilePath = "File Path"
                    
                    
                    foreach ($row in $JO) {
                        foreach ($ky in $row.PSObject.Properties)
                        {
                        	if ($ky.Name.EndsWith("ErrorCode"))
                        	{
                        		$ErrorCode = $ky.Value
                        	}
                        	if ($ky.Name.EndsWith("Description"))
                        	{
                        		$Description = $ky.Value
                        	}
                        	if ($ky.Name.EndsWith("FilePath"))
                        	{
                        		$FilePath = $ky.Value
                        	}
                        	if ($ky.Name.EndsWith("ErrorSeverity"))
                        	{
                        		$ErrorSeverity = $ky.Value
                        		if ($ErrorSeverity.Equals("Error"))
                        		{
                        			$totalErros++
                        		}
                        	}
                        	if ($ky.Name.EndsWith("Recommendation"))
                        	{
                        		$Recommendation = $ky.Value
                        		if ($ErrorSeverity.Equals("Error"))
                        		{ 
                        			Write-Output "Error code: $ErrorCode, File: $FilePath, $Description, $Recommendation"
                        		}
                        	}
                        
                        }
                    }
                    
                    
                    
                    
                    #Write-Output to pipeline
                    
                    Write-Output "$(Get-Date -Format 'HH:mm:ss') - COMPLETED - Static Code Analyzer"
                    
                    #Get-Content $OutputFilePath | ConvertFrom-Json | ConvertTo-Csv | Out-File $CSVFilePath
                    
                    
                    Write-Output "Total Number of Violations = $totalErros"
                    if ($totalErros > 0)
                    {
                    	Exit 1
                    }
             