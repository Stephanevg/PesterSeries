Function Get-ComputerInfos {

  [cmdletbinding()]
  Param(
    [ValidateNotNullOrEmpty ()]
    [parameter(Mandatory=$false,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)] 
    [string[]]$computername=$env:COMPUTERNAME
       

  )

  begin{
  
    $Objects = @()
  
  }
  Process{ #<--Added process block
    Foreach ($Computer in $ComputerName){
      Write-Verbose "working on $ComputerName"
      $Infos = Get-CimInstance -Class win32_operatingSystem -Property OSArchitecture,LastBootUpTime,TotalVirtualMemorySize,Caption,servicepackmajorversion -ComputerName $Computer
      $Properties = @{}
      $Properties.Add("ComputerName",$Computer)
      $Properties.Add("Architecture",$Infos.OSArchitecture)
      $Properties.add("LastBoot",$Infos.LastBootupTime)
      $Properties.Add("OSversion",$Infos.Caption)
      $Properties.Add("TotalMemorySize",$Infos.TotalVirtualMemorySize)
      $Properties.Add("SPversion",$Infos.servicepackmajorversion)

      $object = New-object -TypeName psobject -Property $Properties
      $Objects += $object
    }
  }#EndProcess
  End{
    return $Objects
  }#End endblock

  
}


#$a = get-ComputerInfos -ComputerName $env:COMPUTERNAME,$env:COMPUTERNAME

