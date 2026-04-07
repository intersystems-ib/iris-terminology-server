-- Resets terminology runtime and core metadata tables for a fresh local load.
-- Run only in development environments.

-- snomed
TRUNCATE TABLE Terminology_Snomed.IsaClosure;
TRUNCATE TABLE Terminology_Snomed.PreferredTermStage;
TRUNCATE TABLE Terminology_Snomed.PreferredTerm;
TRUNCATE TABLE Terminology_Snomed.LanguageRefSetConfig;
TRUNCATE TABLE Terminology_Snomed.EditionModule;

TRUNCATE TABLE Terminology_Snomed.RefsetMember;
TRUNCATE TABLE Terminology_Snomed.Relationship;
TRUNCATE TABLE Terminology_Snomed.Description;
TRUNCATE TABLE Terminology_Snomed.Concept;

-- loinc
TRUNCATE TABLE Terminology_Loinc.Closure;
TRUNCATE TABLE Terminology_Loinc.HierarchyEdge;
TRUNCATE TABLE Terminology_Loinc.Display;
TRUNCATE TABLE Terminology_Loinc.GroupMember;
TRUNCATE TABLE Terminology_Loinc.LoincGroup;
TRUNCATE TABLE Terminology_Loinc.CodePartLink;
TRUNCATE TABLE Terminology_Loinc.Part;
TRUNCATE TABLE Terminology_Loinc.Code;

TRUNCATE TABLE Terminology_Core.VersionRelease;
TRUNCATE TABLE Terminology_Core.LicenseNotice;
TRUNCATE TABLE Terminology_Core.CodeSystem;
