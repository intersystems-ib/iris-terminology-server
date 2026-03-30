# FHIR Scope

## Objective

Define the first FHIR terminology scope for this project.

This file is intentionally narrow.
The first goal is not "full FHIR terminology server".
The first goal is "credible, working MVP over the current SNOMED-oriented base".

## MVP philosophy

Implement FHIR operations in the order that maximizes reuse of current working logic.

The current project already appears to have SNOMED-oriented capabilities equivalent to:
- lookup-like behavior
- validate-code-like behavior
- subsumption/navigation behavior
- search support

The FHIR layer should reuse that logic through a common service contract.

## MVP in scope

### Resources
Minimal support for:
- `CodeSystem`
- `ValueSet`
- `ConceptMap` later in MVP or post-MVP depending on maturity

### Operations
Priority order:

1. `CodeSystem/$lookup`
2. `CodeSystem/$validate-code`
3. `CodeSystem/$subsumes`
4. `ValueSet/$expand`
5. `ConceptMap/$translate`

## Detailed MVP scope

### 1. CodeSystem/$lookup
Purpose:
- return core concept information for a given code

Initial expectations:
- code existence
- display
- active status
- system/version support
- designations where available
- selected properties if already easy to expose

May initially be SNOMED-only behind a generic FHIR contract.

### 2. CodeSystem/$validate-code
Purpose:
- validate whether a code is valid in a code system/version
- optionally validate display if supported

Initial expectations:
- valid / invalid
- inactive where relevant
- diagnostics message
- version-sensitive behavior when possible

### 3. CodeSystem/$subsumes
Purpose:
- determine hierarchical relationship between two concepts

Initial expectations:
- equivalent
- subsumes
- subsumed-by
- not-subsumed

Likely based on existing closure/ancestor-descendant logic in the SNOMED implementation.

### 4. ValueSet/$expand
Purpose:
- return members of a ValueSet

Initial MVP can be narrow:
- expansion of simple predefined value sets
- expansion from stored local definitions
- limited filters

Avoid building a full generic composition engine too early.

### 5. ConceptMap/$translate
Purpose:
- translate a code using stored mappings

Only implement after mapping model/storage is sufficiently clear.

## Explicitly out of scope for first iteration

- full authoring support
- full SNOMED ECL engine
- all FHIR search interactions
- complete metadata parity with enterprise terminology servers
- broad multi-terminology support before common contracts are stable

## Service contract required

FHIR implementation should depend on service methods like:

- `LookupCode(system, version, code, language, propertySet)`
- `ValidateCode(system, version, code, display, valueSet)`
- `Subsumes(system, version, codeA, codeB)`
- `ExpandValueSet(valueSetId, filter, offset, count)`
- `TranslateCode(sourceSystem, sourceCode, targetSystem)`

Near-term implementation note:
- the first concrete common contract should stay narrow and only cover currently justified SNOMED-backed operations
- `LookupCode`
- `ValidateCode`
- `Subsumes`
- `SearchConcepts`
- hierarchy navigation, descriptions and refset operations may remain adapter-specific until the FHIR layer needs a neutral shape

## Incremental rollout rule

Each FHIR operation should be delivered with:
- documented mapping to existing logic
- at least a minimal test set
- examples of request/response
- explicit statement of current limitations

## Initial target
Initial practical target:
- SNOMED-backed FHIR terminology operations
- architecture ready for future LOINC/other terminology adapters
