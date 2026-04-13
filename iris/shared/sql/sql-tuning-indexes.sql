-- Applies SQL tuning statements for terminology tables.
-- Optional step for local performance tuning.

-- snomed
TUNE TABLE Terminology_Snomed.Concept;
TUNE TABLE Terminology_Snomed.Description;
TUNE TABLE Terminology_Snomed.Relationship;
TUNE TABLE Terminology_Snomed.RefsetMember;
TUNE TABLE Terminology_Snomed.PreferredTerm;
TUNE TABLE Terminology_Snomed.IsaClosure;
TUNE TABLE Terminology_Snomed.PreferredTermStage;
TUNE TABLE Terminology_Snomed.LanguageRefSetConfig;

-- loinc
TUNE TABLE Terminology_Loinc.Code;
TUNE TABLE Terminology_Loinc.Display;
TUNE TABLE Terminology_Loinc.Part;
TUNE TABLE Terminology_Loinc.CodePartLink;
TUNE TABLE Terminology_Loinc.HierarchyEdge;
TUNE TABLE Terminology_Loinc.Closure;
TUNE TABLE Terminology_Loinc.LoincGroup;
TUNE TABLE Terminology_Loinc.GroupMember;

-- icd
TUNE TABLE Terminology_ICD.Code;
TUNE TABLE Terminology_ICD.Family;
TUNE TABLE Terminology_ICD.Chapter;
TUNE TABLE Terminology_ICD.HierarchyEdge;
TUNE TABLE Terminology_ICD.LoadStage;
