class IISWebFarmRequirementResult : BaseResult {
    [string]$ComputerName

    [bool]$Passed

    [string[]]$FailureReasons

    [bool]$WinRMAvailable

    [string]$OperatingSystem

    [version]$PowerShellVersion

    [bool]$IISInstalled

    [bool]$W3SVCRunning

    [bool]$WebAdministrationAvailable

    [version]$WebDeployVersion

    [string]$WebDeployPath

    IISWebFarmRequirementResult() {

        $this.Passed = $false

        $this.FailureReasons = @()

        $this.WinRMAvailable = $false

        $this.IISInstalled = $false

        $this.W3SVCRunning = $false

        $this.WebAdministrationAvailable = $false
    } #constructor

    [hashtable] ToHashtable() {

        $Hash = $this.GetBaseHashtable()

        $Hash.ComputerName = $this.ComputerName

        $Hash.Passed = $this.Passed

        $Hash.FailureReasons = $this.FailureReasons

        $Hash.WinRMAvailable = $this.WinRMAvailable

        $Hash.OperatingSystem = $this.OperatingSystem

        $Hash.PowerShellVersion = if ($this.PowerShellVersion)
        {
            $this.PowerShellVersion.ToString()
        }
        else
        {
            $null
        } #if

        $Hash.IISInstalled = $this.IISInstalled

        $Hash.W3SVCRunning = $this.W3SVCRunning

        $Hash.WebAdministrationAvailable =
            $this.WebAdministrationAvailable

        $Hash.WebDeployVersion = if ($this.WebDeployVersion)
        {
            $this.WebDeployVersion.ToString()
        }
        else
        {
            $null
        } #if

        $Hash.WebDeployPath = $this.WebDeployPath

        return $Hash
    } #ToHashtable
} #class IISWebFarmRequirementResult