# IISWebFarm Design Reasoning

Last Updated : 2026-11-26
Module Version: 1.1.0.0

## PROJECT GOAL

IISWebFarm was originally created to simplify the
management of multiple IIS servers hosting the
same applications.

The primary objective is to ensure that IIS
configuration remains consistent across all
participating servers while providing reliable
methods for validation, synchronization, backup
and recovery.

Validation serves as the decision-making layer
that determines whether synchronization or
corrective actions are required.

## Why PowerShell Classes

The module uses strongly typed PowerShell classes
instead of PSCustomObject or Hashtable-based output.

Reasons:

* Predictable object structure
* Consistent serialization
* JSON export support
* Easier testing
* Easier maintenance
* Future API compatibility

The class model forms the foundation of logging,
reporting and monitoring integrations.

## Why Custom Exceptions

PowerShell defaults to generic exceptions for many
failure scenarios.

Custom exceptions were introduced to:

* Provide meaningful error messages
* Simplify troubleshooting
* Support deterministic exit codes
* Improve testability

The module treats most validation failures as
terminating conditions rather than warnings.

Fail fast is preferred over silent failures.

## Why Exit Codes

The module is intended to support:

* Scheduled Tasks
* Monitoring systems
* Wazuh
* Future CI/CD integrations

Exit codes provide a machine-readable result that
can be interpreted without parsing textual output.

## Why Health Checks Instead of Connectivity Checks

A successful TCP connection does not prove that a
web application is functioning correctly.

Examples:

* IIS may be running while the application is not.
* Requests may fail internally.
* Redirect loops may exist.
* Dependencies may be unavailable.

The module therefore favors health probes over
simple connectivity tests whenever possible.

## Why Configuration Validation Exists

Configuration errors are typically discovered late
during execution.

Validation is executed as early as possible to:

* Detect problems quickly
* Reduce troubleshooting time
* Prevent partial execution
* Improve operator feedback

## Why JSONL Logging

JSONL was selected because:

* One record per line
* Easy ingestion into Wazuh
* Human readable
* Append-friendly
* Stream-friendly

JSONL logging remains optional because not all
environments require centralized log collection.

## Why Log Retention Is Enforced

Unmanaged log directories inevitably grow.

Operational experience shows that temporary log
storage often becomes permanent storage.

Automatic retention reduces:

* Disk consumption
* Manual maintenance
* Long-term operational risk

Long-term retention belongs in monitoring systems,
not application log folders.

## Why PowerShell 5.1 Compatibility

Many IIS environments continue to run Windows
Server installations where PowerShell 5.1 remains
the operational standard.

Maintaining compatibility reduces barriers to
adoption and simplifies deployment.