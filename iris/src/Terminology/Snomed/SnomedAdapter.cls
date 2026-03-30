/// SNOMED-specific business adapter.
/// Owns orchestration and business semantics while reusing SnomedRepository for SQL.
Class Terminology.Snomed.SnomedAdapter Extends %RegisteredObject
{

/// Implements the common concept search contract for SNOMED.
Method SearchConcepts(pReleaseId As %String = "", pLang As %String = "", pDialect As %String = "", pQuery As %String = "", pLimit As %Integer = 20, pOffset As %Integer = 0, Output pResult As Terminology.Snomed.DTO.SearchResult) As %Status
{
    Return ..GetRepository().SearchConcepts(pReleaseId, pLang, pDialect, pQuery, pLimit, pOffset, .pResult)
}

/// Implements the common lookup contract using the SNOMED concept query.
Method LookupCode(pCode As %String = "", pReleaseId As %String = "", pLang As %String = "", pDialect As %String = "", Output pResult As Terminology.Snomed.DTO.ConceptResult) As %Status
{
    Return ..GetRepository().GetConceptByCode(pCode, pReleaseId, pLang, pDialect, .pResult)
}

/// SNOMED-native hierarchy navigation that is not yet part of the neutral service contract.
Method GetChildren(pConceptId As %String = "", pReleaseId As %String = "", pView As %String = "", pLang As %String = "", pDialect As %String = "", Output pResult As Terminology.Snomed.DTO.ConceptListResult) As %Status
{
    Return ..GetRepository().GetChildren(pConceptId, pReleaseId, pView, pLang, pDialect, .pResult)
}

/// SNOMED-native hierarchy navigation that remains adapter-only for now.
Method GetDescendants(pConceptId As %String = "", pReleaseId As %String = "", pView As %String = "", pLang As %String = "", pDialect As %String = "", pLimit As %Integer = 100, pOffset As %Integer = 0, Output pResult As Terminology.Snomed.DTO.ConceptListResult) As %Status
{
    Return ..GetRepository().GetDescendants(pConceptId, pReleaseId, pView, pLang, pDialect, pLimit, pOffset, .pResult)
}

/// SNOMED-native hierarchy navigation that remains adapter-only for now.
Method GetAncestors(pConceptId As %String = "", pReleaseId As %String = "", pView As %String = "", pLang As %String = "", pDialect As %String = "", pIncludeSelf As %Integer = 0, pMaxDepth As %Integer = 0, pLimit As %Integer = 100, pOffset As %Integer = 0, Output pResult As Terminology.Snomed.DTO.ConceptListResult) As %Status
{
    Return ..GetRepository().GetAncestors(pConceptId, pReleaseId, pView, pLang, pDialect, pIncludeSelf, pMaxDepth, pLimit, pOffset, .pResult)
}

/// SNOMED-native description retrieval.
Method GetDescriptions(pConceptId As %String = "", pReleaseId As %String = "", pLang As %String = "", pActiveOnly As %Integer = 0, pTypeId As %String = "", pLimit As %Integer = 200, pOffset As %Integer = 0, Output pResult As Terminology.Snomed.DTO.DescriptionListResult) As %Status
{
    Return ..GetRepository().GetDescriptions(pConceptId, pReleaseId, pLang, pActiveOnly, pTypeId, pLimit, pOffset, .pResult)
}

/// Applies SNOMED subsumption semantics before delegating the actual closure check to the repository.
Method Subsumes(pReleaseId As %String = "", pView As %String = "", pCodeA As %String = "", pCodeB As %String = "", Output pResult As Terminology.Snomed.DTO.SubsumesResult) As %Status
{
    Set pResult = ##class(Terminology.Snomed.DTO.SubsumesResult).%New()

    If (pCodeA = "") || (pCodeB = "") {
        Set pResult.Relationship = "not-subsumed"
        Return $$$OK
    }

    If (pCodeA = pCodeB) {
        Set pResult.Relationship = "equivalent"
        Return $$$OK
    }

    Set tSC = ..GetRepository().GetSubsumptionRelation(pReleaseId, pView, pCodeA, pCodeB, .relationship)
    $$$ThrowOnError(tSC)

    Set pResult.Relationship = relationship
    Return $$$OK
}

/// Implements the common validate-code contract for SNOMED.
Method ValidateCode(pReleaseId As %String = "", pCode As %String = "", Output pResult As Terminology.Snomed.DTO.ValidateCodeResult) As %Status
{
    Return ..GetRepository().ValidateCode(pReleaseId, pCode, .pResult)
}

/// SNOMED-native refset listing remains adapter-only until there is a neutral model.
Method GetRefsets(pReleaseId As %String = "", pLimit As %Integer = 100, pOffset As %Integer = 0, Output pResult As Terminology.Snomed.DTO.RefsetListResult) As %Status
{
    Return ..GetRepository().GetRefsets(pReleaseId, pLimit, pOffset, .pResult)
}

/// SNOMED-native refset member retrieval remains adapter-only until there is a neutral model.
Method GetRefsetMembers(pRefsetId As %String = "", pReleaseId As %String = "", pLang As %String = "", pDialect As %String = "", pLimit As %Integer = 100, pOffset As %Integer = 0, Output pResult As Terminology.Snomed.DTO.RefsetMemberListResult) As %Status
{
    Return ..GetRepository().GetRefsetMembers(pRefsetId, pReleaseId, pLang, pDialect, pLimit, pOffset, .pResult)
}

/// Centralized repository creation keeps SQL access behind the adapter boundary.
Method GetRepository() As Terminology.Snomed.SnomedRepository [ Private ]
{
    Quit ##class(Terminology.Snomed.SnomedRepository).%New()
}

}
