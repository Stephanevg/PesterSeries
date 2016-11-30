Function Get-ComputerInfos {

  [cmdletbinding()]
  Param(
    [ValidateNotNullOrEmpty ()]
    [parameter(Mandatory=$false,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)] 
    [string[]]$computername=$env:COMPUTERNAME
       

  )

  #begin{
  
    $Objects = @()
  
  #}
  #Process{ 
    Foreach ($Computer in $ComputerName){
      if (Test-Connection -ComputerName $computername -Count 1 -Quiet){ #<-- Added Test-Connection in IF block
        
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
        
      }else{
        
        write-warning "Computer $($Computer) not available"
        $Properties = @{}
        $Properties.Add("ComputerName",$Computer)
        $Properties.Add("Architecture","")
        $Properties.add("LastBoot","")
        $Properties.Add("OSversion","")
        $Properties.Add("TotalMemorySize","")
        $Properties.Add("SPversion","")

        $object = New-object -TypeName psobject -Property $Properties
        $Objects += $object

      }
      
    }
  #}#EndProcess
  #End{
    return $Objects
  #}#End endblock

  
}


#$a = get-ComputerInfos -ComputerName $env:COMPUTERNAME,$env:COMPUTERNAME

