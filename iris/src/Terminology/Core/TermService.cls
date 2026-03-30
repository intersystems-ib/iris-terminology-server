/// Neutral terminology service entry point.
/// Keeps the common contract small and routes calls to the terminology adapter.
Class Terminology.Core.TermService Extends %RegisteredObject
{

/// Common lookup operation used by higher layers that should not know SNOMED tables.
Method LookupCode(pSystem As %String = "snomed", pCode As %String = "", pVersion As %String = "", pLang As %String = "", pDialect As %String = "", Output pResult As Terminology.Snomed.DTO.ConceptResult) As %Status
{
    Return ..ResolveAdapter(pSystem).LookupCode(pCode, pVersion, pLang, pDialect, .pResult)
}

/// Common validate-code operation.
Method ValidateCode(pSystem As %String = "snomed", pVersion As %String = "", pCode As %String = "", Output pResult As Terminology.Snomed.DTO.ValidateCodeResult) As %Status
{
    Return ..ResolveAdapter(pSystem).ValidateCode(pVersion, pCode, .pResult)
}

/// Common subsumption operation.
Method Subsumes(pSystem As %String = "snomed", pVersion As %String = "", pView As %String = "", pCodeA As %String = "", pCodeB As %String = "", Output pResult As Terminology.Snomed.DTO.SubsumesResult) As %Status
{
    Return ..ResolveAdapter(pSystem).Subsumes(pVersion, pView, pCodeA, pCodeB, .pResult)
}

/// Common text search operation.
Method SearchConcepts(pSystem As %String = "snomed", pVersion As %String = "", pLang As %String = "", pDialect As %String = "", pQuery As %String = "", pLimit As %Integer = 20, pOffset As %Integer = 0, Output pResult As Terminology.Snomed.DTO.SearchResult) As %Status
{
    Return ..ResolveAdapter(pSystem).SearchConcepts(pVersion, pLang, pDialect, pQuery, pLimit, pOffset, .pResult)
}

/// Explicit adapter resolution keeps the current implementation simple while making
/// the routing point obvious for future terminologies.
Method ResolveAdapter(pSystem As %String = "snomed") As Terminology.Snomed.SnomedAdapter [ Private ]
{
    If (pSystem = "") || ($ZCONVERT(pSystem, "L") = "snomed") || (pSystem = "http://snomed.info/sct") {
        Quit ##class(Terminology.Snomed.SnomedAdapter).%New()
    }

    Set tSC = $$$ERROR($$$NotImplemented, "Unsupported terminology system: "_pSystem)
    $$$ThrowOnError(tSC)
}

}
