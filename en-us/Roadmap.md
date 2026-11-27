# IISWebFarm Roadmap

## Completed ✅

### Architecture

✅ Module structure

✅ Private/

✅ Public/

✅ Classes/

✅ Tests/

✅ en-US/

✅ README.md

✅ IISWebFarm.psd1

✅ IISWebFarm.psm1

✅ Central exception hierarchy

✅ Central exit code strategy

---

### Core Classes

✅ IISWebFarmExitCode

✅ IISWebFarmException

✅ LoggingInitializationException

✅ LogRetentionException

✅ ConfigurationImportException

✅ SettingsValidationException

✅ DnsValidationException

✅ HttpsValidationException

✅ HealthProbeException

✅ WebsiteValidationException

✅ ApplicationPoolValidationException

✅ WebDeployValidationException

✅ NotificationException

✅ UnexpectedIISWebFarmException

✅ BaseResult

---

### Logging Framework

✅ Initialize-ExecutionMetadata

✅ Initialize-Logging

✅ Invoke-LogRetention

✅ Write-JsonLine

---

### Configuration Framework

✅ Import-IISWebFarmSettings

✅ Test-IISWebFarmSettings

✅ Resolve-Checks

---

### Validation Framework Tests

#### Exception Framework

✅ Enum uniqueness validation

✅ Inheritance validation

✅ ExitCode validation

✅ Enum type validation

✅ Message validation

✅ InnerException validation

#### Import-IISWebFarmSettings

✅ Valid PSD1 import

✅ Settings path validation

✅ Missing settings file validation

✅ Missing mail settings file validation

✅ Invalid Verify PSD1 validation

✅ Invalid Mail PSD1 validation

✅ ConfigurationImportException validation

✅ ExitCode validation

#### Resolve-Checks

✅ Pester tests

#### Write-JsonLine

✅ Pester tests

#### Test-IISWebFarmSettings

✅ Pester tests

---

### Health Endpoint Architecture

✅ /health endpoint

✅ HTTP-only health check support

✅ HTTPS redirect handling

✅ HSTS isolation

✅ IIS redirect isolation

✅ ASP.NET redirect isolation

✅ HAProxy-proof health validation design

✅ Configurable ProbePath

✅ Configurable TimeoutSeconds

✅ Health validation architecture

---

### Documentation

✅ about_IISWebFarm

✅ about_IISWebFarmClasses

✅ about_IISWebFarmExceptions

✅ about_IISWebFarmLogging

✅ about_IISWebFarmRequirements

✅ ADR.md

✅ DesignPrinciples.md

✅ Reasoning.md

---

## In Progress 🚧

### Discovery Framework

✅ Resolve-WebDeployInstallation

✅ Resolve-IISWebsite

✅ Resolve-WebsiteBinding

✅ Resolve-ApplicationPool

---

### Environment Validation

✅ IISWebFarmRequirementResult

✅ Test-ModuleRequirements

✅ Bootstrap failure logging

⏳ Pester tests

---

### Validation Functions

#### Health Validation

⏳ Test-HealthProbe

⏳ Pester tests

#### DNS Validation

⏳ Test-DnsBinding

⏳ Pester tests

#### HTTPS Validation

⏳ Test-HttpsBinding

⏳ Pester tests

#### Website Validation

⏳ Test-WebsiteConfiguration

⏳ Pester tests

#### Application Pool Validation

⏳ Test-ApplicationPoolConfiguration

⏳ Pester tests

#### Web Deploy Validation

⏳ Test-WebDeploy

⏳ Pester tests

---

### Notifications

⏳ Send-Notification

⏳ Pester tests

---

### Public Commands

⏳ Verify-WebFarm

---

### Documentation

⏳ about_IISWebFarmExitCodes

✅ Roadmap.md

---

## Planned 🚀

### Backup

⏳ Backup-WebFarm

⏳ Backup configuration classes

⏳ Backup result classes

⏳ Pester tests

---

### Restore

⏳ Restore-WebFarm

⏳ Restore validation

⏳ Restore result classes

⏳ Pester tests

---

### Synchronization

⏳ Sync-WebFarm

⏳ Website synchronization

⏳ Application Pool synchronization

⏳ Binding synchronization

⏳ Web Deploy integration

⏳ Pester tests

---

### Reporting

⏳ HTML reports

⏳ Structured validation reports

⏳ Dashboard integrations

---

## Future Considerations

⏳ Parallel validation

⏳ Scheduled validation

⏳ Configuration drift detection

⏳ Backup retention management

⏳ Centralized reporting

⏳ CI/CD integration

⏳ Additional load balancer integrations

---

## Vision

IISWebFarm is intended to become a complete IIS Web Farm Management Toolkit.

The long-term goal is to provide:

- Validation
- Backup
- Restore
- Synchronization
- Drift Detection
- Reporting

for IIS environments hosting the same applications across multiple servers.

Validation is considered a foundational capability used to determine whether synchronization or corrective actions are required.

IISWebFarm uses a layered architecture consisting of:

- Resolve Functions (Discovery)
- Test Functions (Validation)
- Backup Functions (Recovery)
- Restore Functions (Recovery)
- Sync Functions (Remediation)

Resolve functions provide a reusable inventory and discovery layer used by validation, synchronization, backup and restore operations.

Test functions validate collected data and determine whether remediation or corrective action is required.

The original design target remains a highly available IIS farm consisting of two or more synchronized IIS servers capable of automated validation, recovery and operational maintenance.