$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
Write-Information "Dot sourcing $here\$sut"
. "$here\$sut"


Describe 'Testing the Get-ComputerInfos function' {
    
  Context 'Testing Input validation' {
    
    $ComputerArray = @($env:COMPUTERNAME;$env:COMPUTERNAME)
    $SingleComputer = $env:COMPUTERNAME

    it 'Should run when no parameter is provided'{
        $infos = Get-ComputerInfos
        $infos | should not beNullOrEmpty
    }
  
    it 'Should Accept PipeLine input'{
        $Infos = $ComputerArray | Get-ComputerInfos
        $infos | should not beNullOrEmpty
        $Infos[0].ComputerName | should be $env:COMPUTERNAME
        $Infos.count -gt 1 | should be $true 
    }
    
    it 'Should not accept null values'{
    
      {Get-ComputerInfos -ComputerName ''} | should throw
    
    }
  
    iT 'Should Accept Array of computers'{
    
        $Infos =  Get-ComputerInfos -ComputerName $ComputerArray
        $infos | should not beNullOrEmpty
        $Infos.count -gt 1 | should be $true 
    
    }
    
  }
  
  Context 'Testing returned object contents' {
  
      $ComputerArray = @($env:COMPUTERNAME;$env:COMPUTERNAME)
      $SingleComputer = $env:COMPUTERNAME
      $Infos = Get-ComputerInfos -ComputerName $SingleComputer
  
    it 'Should Have a ComputerName' {
      $Infos.ComputerNAme | should be $env:COMPUTERNAME
  
    }
  
    it 'Should Have a TotalMemorySize' {
        $Infos.TotalMemorySize | should not be EmptyOrNull
    }
  
    it 'Should Have a CPU' {
        $Infos.TotalMemorySize | should not be EmptyOrNull
    }
    
    it 'Should Have a LastBoot' {
         $Infos.Lastboot | should not be EmptyOrNull
    }
    
    it 'Should Have a ArchitectureType' {
      $Infos.ArchitectureType | should not be EmptyOrNull
    }
  
  } 
  
  Context 'Testing with big amount of data' {
  
    Mock -CommandName Get-ComputerInfos -MockWith {
    
      $objects = @()
      for ($i = 0; $i -lt 1; $i += 1) 
      {
        $obj = [PSCustomObject]@{
      
          "Architecture"='64-bit'
          "ComputerName"="District$i"
          "LastBoot" = get-date 
          "OsVersion" = "Microsoft Windows 7 Enterprise"
          "SPVersion" = 1
          "TotalMemorySize" = 33111412
        }
      
        $objects += $obj

      }
    
      return $objects
    }
    
    #Calling our command that is this time 'mocked'
    
    $a = 1..10
    $CompInfos = @()
    for ($i = 0; $i -lt 10; $i += 1) 
    {
      $CompInfos += Get-ComputerInfos -computername $i
    }
    
    
    
    it "Should return 10 objects" {
      $CompInfos.Count -eq 10 | should be $true
    }
    
    it 'Should have mocked Get-ComputerInfos'{
      Assert-MockCalled -CommandName Get-ComputerInfos -Times 10 -Exactly
      
    }
  }
    
} -Tag "Unit_Tests"

Describe 'Testing the Get-ComputerInfos function' {
    
  Context 'Stress Test: Calling 100 times without mocking' {
    
    $a = 1..100
    $CompInfos = @()
    for ($i = 0; $i -lt 100; $i += 1) 
    {
      $CompInfos += Get-ComputerInfos -computername $env:COMPUTERNAME
    }
    
    
    
    it "Should return 100 objects" {
      $CompInfos.Count -eq 100 | should be $true
    }
    
    
  }
    
} -Tag "Operational_Tests"

