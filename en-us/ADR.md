# Architectural Decision Record

Last Updated : 2026-11-26
Module Version: 1.1.0.0

## ADR-001
### Strongly Typed Object Model

Status
Accepted

Decision

The module shall use PowerShell classes as the
primary object model.

Reason

Typed objects provide a stable contract between
functions, tests, logs and future integrations.

Alternatives Considered

* PSCustomObject
* Hashtable

Rejected Because

Object structures can change without detection and
provide limited validation.

---

## ADR-002
### Central Exception Hierarchy

Status
Accepted

Decision

All module-specific failures shall inherit from
IISWebFarmException.

Reason

Provides consistent error handling and exit code
mapping.

Alternatives Considered

* Generic exceptions
* Write-Error only

Rejected Because

Inconsistent handling complicates automation and
testing.

---

## ADR-003
### One Source Of Truth

Status
Accepted

Decision

Website configuration shall be discovered from IIS.

Reason

Bindings already contain the authoritative
configuration.

Alternatives Considered

* Hostnames in PSD1
* Websites in PSD1
* Bindings in PSD1

Rejected Because

Creates duplicate configuration and increases drift
risk.

---

## ADR-004
### Health Over Connectivity

Status
Accepted

Decision

Application health validation shall use dedicated
health endpoints whenever available.

Reason

Connectivity alone does not indicate service
health.

Alternatives Considered

* Ping
* TCP Port Check
* HTTP Connect Only

Rejected Because

They cannot validate application state.

---

## ADR-005
### Direct Server Validation

Status
Accepted

Decision

Health probes shall target individual backend
servers directly.

Reason

Load balancers may redirect traffic to another
node.

Alternatives Considered

* Public hostname
* HAProxy hostname

Rejected Because

Results may represent another server.

---

## ADR-006
### Optional JSONL Logging

Status
Accepted

Decision

JSONL logging shall remain optional.

Reason

Not all environments use centralized monitoring.

Alternatives Considered

* Mandatory JSONL logging

Rejected Because

Introduces unnecessary complexity for smaller
deployments.

---

## ADR-007
### Automatic Log Retention

Status
Accepted

Decision

The module shall manage retention of its own logs.

Reason

Prevent uncontrolled growth of local storage.

Alternatives Considered

* Manual cleanup
* External cleanup task

Rejected Because

Operational maintenance is frequently neglected.

---

## ADR-008
### Configuration Through PSD1

Status
Accepted

Decision

Configuration shall be provided through PSD1 files.

Reason

PSD1 is native to PowerShell and supports comments,
versioning and source control.

Alternatives Considered

* JSON
* XML
* YAML

Rejected Because

PSD1 provides the best integration with native
PowerShell tooling.

---

## ADR-009
### Fail Fast

Status
Accepted

Decision

Configuration and structural errors shall stop
execution.

Reason

Continuing with invalid configuration often
produces misleading validation results.

Alternatives Considered

* Warning-based execution

Rejected Because

Operators may overlook warnings and assume success.

ADR-010
Web Deploy discovery

Decision

Web Deploy is discovered through its installation
registry keys.

Reason

PATH configuration is not required for proper
operation.

Rejected alternatives

Get-Command msdeploy.exe

Reason for rejection

Depends on local PATH configuration and may
produce false negatives.