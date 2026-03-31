/// Aggregates terminology-specific FHIR operation classes for the server strategy.
Class Terminology.Fhir.TerminologyOperations Extends Terminology.Fhir.LookupOperation
{

/// Enumerates the operations supported by this terminology server operation chain.
ClassMethod AddSupportedOperations(pMap As %DynamicObject)
{
    Do ##class(Terminology.Fhir.LookupOperation).AddSupportedOperations(pMap)
}

}
