import-module "C:\Users\taavast3\OneDrive\Blogs\PowerShellDistrict\Pester\ModuleTesting\GetComputerInfos.psm1"

InModuleScope GetComputerInfos {

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
        for ($i = 0; $i -lt 15; $i += 1) 
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
      $CompInfos = Get-ComputerInfos
    
      it "Should return 15 objects" {
        $CompInfos.Count -eq 15 | should be $true
      }
    
      it "Assert function has been mocked"{
          Assert-VerifiableMocks
        }
      
      it "Should have been mocked 15 times"{
      
        
          Assert-MockCalled -CommandName Get-ComputerInfos -Exactly -times 15
        }
    
    }
    
  }



}
