# FHIR Scope

## Objective

Define the current FHIR terminology scope for this project.

This file is intentionally focused.
The goal is not full enterprise FHIR terminology parity.
The goal is a credible, working FHIR terminology surface on top of the repository's multi-terminology architecture.

## Current Position

The repository now exposes a shared FHIR R4 terminology surface over:

- SNOMED CT
- LOINC

The important architectural rule remains the same:

- FHIR classes stay focused on FHIR request and response behavior
- `Terminology.Core.TermService` provides the integrated logical routing layer
- terminology-specific behavior remains in adapters and repositories

## Scope Philosophy

Implement FHIR operations in the order that maximizes reuse of current working terminology logic.

The FHIR layer should reuse:

- shared service contracts where they exist
- terminology-specific adapters where behavior genuinely differs

The project should not force all terminologies into identical behavior just because the FHIR operation name is the same.

## In Scope

### Resources

Minimal support for:

- `CodeSystem`
- `ValueSet`
- `ConceptMap` later, depending on mapping maturity

Current metadata interaction support:

- `read` for `CodeSystem`
- `read` for `ValueSet`
- `search-type` for `CodeSystem` and `ValueSet` metadata exposure with a narrow parameter set

### Operations

Current priority operations:

1. `CodeSystem/$lookup`
2. `CodeSystem/$validate-code`
3. `CodeSystem/$subsumes`
4. `ValueSet/$expand`
5. `ConceptMap/$translate`

## Current Implementation Direction

### CodeSystem/$lookup

Purpose:

- return core concept information for a given code

Current expectations:

- system/version support
- code existence
- display
- selected fields that are already easy to expose from the terminology-specific DTOs

### CodeSystem/$validate-code

Purpose:

- validate whether a code is valid in a code system/version

Current expectations:

- valid / invalid result
- inactive where relevant
- version-sensitive behavior when possible

### CodeSystem/$subsumes

Purpose:

- determine hierarchical relationship between two concepts

Current expectations:

- equivalent
- subsumes
- subsumed-by
- not-subsumed

The implementation can remain terminology-sensitive behind the shared FHIR contract because hierarchy semantics are not identical across systems.

### ValueSet/$expand

Purpose:

- return members of a ValueSet

Current expectations:

- SNOMED-backed expansion through refset-like behavior
- LOINC-backed expansion through group membership behavior
- limited but practical metadata and expansion support

### ConceptMap/$translate

Purpose:

- translate a code using stored mappings

Only implement after the mapping model and storage are sufficiently clear.

## Explicitly Out Of Scope For The Current Stage

- full authoring support
- full enterprise FHIR terminology parity
- broad search interaction coverage beyond the implemented narrow metadata path
- pretending every terminology has identical FHIR semantics underneath

## Service Contract Required

FHIR implementation should continue to depend on service methods such as:

- `LookupCode(system, version, code, language, propertySet)`
- `ValidateCode(system, version, code, display, valueSet)`
- `Subsumes(system, version, codeA, codeB)`
- `ExpandValueSet(valueSetId, filter, offset, count)`
- `TranslateCode(sourceSystem, sourceCode, targetSystem)`

Near-term implementation rule:

- keep the common contract narrow
- expose only operations justified by real behavior across supported terminologies
- let terminology-specific complexity stay in adapters where needed

## Incremental Rollout Rule

Each FHIR operation should be delivered with:

- documented mapping to the underlying terminology logic
- at least a minimal test set
- example request/response usage
- explicit statement of current limitations

## Current Target

Current practical target:

- one working FHIR terminology surface on IRIS for Health
- SNOMED CT and LOINC both supported where the current implementation justifies it
- architecture ready for future terminology adapters without flattening terminology differences away
