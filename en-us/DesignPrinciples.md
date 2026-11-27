# Design Principles

Last Updated : 2026-11-26
Module Version: 1.1.0.0

## Fundamental Principle

Temporary fixes become permanent.

Architectural shortcuts should therefore be avoided
whenever practical.

## Simplicity

Favor simple solutions that remain maintainable
over time.

## One Source Of Truth

Configuration should exist in a single location.

Duplicate configuration inevitably drifts.

## Fail Fast

Errors should be discovered as early as possible.

## Health Over Connectivity

Validate application health rather than network
reachability whenever possible.

## Strongly Typed Output

Prefer PowerShell classes over PSCustomObject.

## Automation First

Design for unattended execution.

## Monitoring Friendly

Outputs should be consumable by people and systems.

## Backwards Compatibility

Maintain PowerShell 5.1 compatibility unless there
is a compelling reason not to.

## Operational Pragmatism

Operational simplicity is preferred over technical
elegance when the two conflict.