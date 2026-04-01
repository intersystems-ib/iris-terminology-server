# Open Questions

- SNOMED load pipeline:
  Consider moving away from direct Interoperability / BP orchestration.
  Alternative: expose a REST API that starts a load, returns a job id, and lets clients query progress/status later.

- FHIR:
  Implement `TerminologyCapabilities`.

- SNOMED load metadata:
  Check whether load should populate these correctly:
  `Terminology.Core.CodeSystem`, `Terminology.Core.VersionRelease`, `Terminology.Core.LicenseNotice`.

- LOINC:
  LOINC will be the next terminology to support.
  Directions to consider:
  start with a minimal read-only slice: lookup, search, basic FHIR support.
  define the LOINC load path and decide which source files/tables are needed first.
  review `Terminology.Core` and remove or isolate SNOMED-specific assumptions.
  decide what hierarchy/navigation means for the first LOINC milestone.
  define the first repository, adapter, and test surface before adding broader features.
