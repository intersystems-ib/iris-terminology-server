-- Applies SQL tuning statements for SNOMED tables.
-- Optional step for local performance tuning.
TUNE TABLE Terminology_Snomed.Concept;
TUNE TABLE Terminology_Snomed.Description;
TUNE TABLE Terminology_Snomed.Relationship;
TUNE TABLE Terminology_Snomed.RefsetMember;
TUNE TABLE Terminology_Snomed.PreferredTerm;
TUNE TABLE Terminology_Snomed.IsaClosure;
TUNE TABLE Terminology_Snomed.PreferredTermStage;
TUNE TABLE Terminology_Snomed.LanguageRefSetConfig;
