$project = (Split-Path -Parent $MyInvocation.MyCommand.Path).Replace(".Tests", "")
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".tests.", ".")
. "$project\$sut"

Describe "ManipulateFolders"{

	#Scoped to all tests under Describe
	Mock Get-Date { New-Object DateTime (2000, 1, 1) }

	Context "Depending on the existence of a folder" {
		$folder = "c:\temp"
		#Mock my function with the expected parameter
		Mock Myfunction {} -Verifiable -ParameterFilter {$myparam -eq $folder}
		#Mock these functions to manipulate the file system and scope to Context
		Mock Remove-Item
		Mock New-Item

		It "It Should Delete The Folder" {
			Mock Get-Item { $true }   #return true, scoped to It
			$result = DoStuffToFolders $folder
			Assert-VerifiableMocks #will fail if any -Verifiable mocks didn't meet criteria
			$result | Should be "Deleted folder"
		}
		It "It Should Create The Folder" {
			Mock Get-Item { $false }   #return false, scoped to It
			$result = DoStuffToFolders $folder
			Assert-VerifiableMocks #will fail if any -Verifiable mocks didn't meet criteria
			$result | Should be "Created folder"
		}
	}

	Context "When you get a date"{
			$date = GetMyOwnDate

			It "It Should Be The Year 2000"{
				($date).year | Should be "2000"
			}
		}
}







