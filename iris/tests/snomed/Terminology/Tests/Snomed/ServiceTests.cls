/// Covers the SNOMED service and adapter layers with the synthetic release fixture.
Class Terminology.Tests.Snomed.ServiceTests Extends Terminology.Tests.Snomed.TestBase
{

/// Verifies search and lookup against the common terminology service.
Method TestTermServiceSearchAndLookup() As %Status
{
    Set service = ##class(Terminology.Core.TermService).%New()

    Set tSC = service.SearchConcepts("snomed", ..#FixtureReleaseId, "es", "es-ES", "hijo", 20, 0, .searchResult)
    Do ..AssertStatusOKViaMacro("", tSC, "TermService search returns OK")
    Do ..AssertEqualsViaMacro("", searchResult.Count, 1, "Search returns one synthetic concept")

    Set firstItem = searchResult.Items.GetAt(1)
    Do ..AssertEqualsViaMacro("", firstItem.ConceptId, ..#ChildConceptId, "Search returns the child concept")
    Do ..AssertEqualsViaMacro("", firstItem.PreferredTerm, "Concepto hijo sintetico", "Search returns the preferred term")

    Set tSC = service.LookupCode("snomed", ..#ChildConceptId, ..#FixtureReleaseId, "es", "es-ES", .concept)
    Do ..AssertStatusOKViaMacro("", tSC, "TermService lookup returns OK")
    Do ..AssertEqualsViaMacro("", concept.ConceptId, ..#ChildConceptId, "Lookup returns the requested concept")
    Do ..AssertEqualsViaMacro("", concept.PreferredTerm, "Concepto hijo sintetico", "Lookup returns the preferred term")
    Quit $$$OK
}

/// Verifies validate-code and subsumption semantics through TermService.
Method TestTermServiceValidateCodeAndSubsumes() As %Status
{
    Set service = ##class(Terminology.Core.TermService).%New()

    Set tSC = service.ValidateCode("snomed", ..#FixtureReleaseId, ..#ChildConceptId, .activeResult)
    Do ..AssertStatusOKViaMacro("", tSC, "ValidateCode returns OK for an active concept")
    Do ..AssertEqualsViaMacro("", activeResult.Exists, 1, "Active concept exists")
    Do ..AssertEqualsViaMacro("", activeResult.Active, 1, "Active concept is active")

    Set tSC = service.ValidateCode("snomed", ..#FixtureReleaseId, ..#InactiveConceptId, .inactiveResult)
    Do ..AssertStatusOKViaMacro("", tSC, "ValidateCode returns OK for an inactive concept")
    Do ..AssertEqualsViaMacro("", inactiveResult.Exists, 1, "Inactive concept still exists")
    Do ..AssertEqualsViaMacro("", inactiveResult.Active, 0, "Inactive concept is marked inactive")

    Set tSC = service.ValidateCode("snomed", ..#FixtureReleaseId, "999999999999", .missingResult)
    Do ..AssertStatusOKViaMacro("", tSC, "ValidateCode returns OK for a missing concept")
    Do ..AssertEqualsViaMacro("", missingResult.Exists, 0, "Missing concept does not exist")
    Do ..AssertEqualsViaMacro("", missingResult.Active, 0, "Missing concept is not active")

    Set tSC = service.Subsumes("snomed", ..#FixtureReleaseId, "inferred", ..#ParentConceptId, ..#ChildConceptId, .subsumesResult)
    Do ..AssertStatusOKViaMacro("", tSC, "Subsumes returns OK for ancestor relationship")
    Do ..AssertEqualsViaMacro("", subsumesResult.Relationship, "subsumes", "Parent subsumes child")

    Set tSC = service.Subsumes("snomed", ..#FixtureReleaseId, "inferred", ..#ChildConceptId, ..#ParentConceptId, .subsumedByResult)
    Do ..AssertStatusOKViaMacro("", tSC, "Subsumes returns OK for descendant relationship")
    Do ..AssertEqualsViaMacro("", subsumedByResult.Relationship, "subsumed-by", "Child is subsumed by parent")

    Set tSC = service.Subsumes("snomed", ..#FixtureReleaseId, "inferred", ..#ChildConceptId, ..#ChildConceptId, .equivalentResult)
    Do ..AssertStatusOKViaMacro("", tSC, "Subsumes returns OK for equivalent concepts")
    Do ..AssertEqualsViaMacro("", equivalentResult.Relationship, "equivalent", "Matching codes are equivalent")
    Quit $$$OK
}

/// Verifies hierarchy and refset behavior that stays SNOMED-specific in the adapter.
Method TestSnomedAdapterHierarchyAndRefsets() As %Status
{
    Set adapter = ##class(Terminology.Snomed.SnomedAdapter).%New()

    Set tSC = adapter.GetChildren(..#ParentConceptId, ..#FixtureReleaseId, "inferred", "es", "es-ES", .children)
    Do ..AssertStatusOKViaMacro("", tSC, "GetChildren returns OK")
    Do ..AssertEqualsViaMacro("", children.Count, 1, "Parent has one synthetic child")
    Do ..AssertEqualsViaMacro("", children.Items.GetAt(1).ConceptId, ..#ChildConceptId, "GetChildren returns the child concept")

    Set tSC = adapter.GetAncestors(..#ChildConceptId, ..#FixtureReleaseId, "inferred", "es", "es-ES", 1, 0, 100, 0, .ancestors)
    Do ..AssertStatusOKViaMacro("", tSC, "GetAncestors returns OK")
    Do ..AssertEqualsViaMacro("", ancestors.Count, 2, "Child has self and parent in ancestor list")
    Do ..AssertEqualsViaMacro("", ancestors.Items.GetAt(1).ConceptId, ..#ChildConceptId, "Ancestors include self at depth 0")
    Do ..AssertEqualsViaMacro("", ancestors.Items.GetAt(2).ConceptId, ..#ParentConceptId, "Ancestors include parent at depth 1")

    Set tSC = adapter.GetRefsets(..#FixtureReleaseId, 100, 0, .refsets)
    Do ..AssertStatusOKViaMacro("", tSC, "GetRefsets returns OK")
    Do ..AssertEqualsViaMacro("", refsets.Count, 1, "Fixture exposes one refset")
    Do ..AssertEqualsViaMacro("", refsets.Items.GetAt(1).RefsetId, ..#RefsetId, "GetRefsets returns the synthetic refset")

    Set tSC = adapter.GetRefsetMembers(..#RefsetId, ..#FixtureReleaseId, "es", "es-ES", 100, 0, .members)
    Do ..AssertStatusOKViaMacro("", tSC, "GetRefsetMembers returns OK")
    Do ..AssertEqualsViaMacro("", members.Count, 1, "Only active refset members are returned")
    Do ..AssertEqualsViaMacro("", members.Items.GetAt(1).ConceptId, ..#ChildConceptId, "Refset member returns the referenced concept")
    Do ..AssertEqualsViaMacro("", members.Items.GetAt(1).PreferredTerm, "Concepto hijo sintetico", "Refset member resolves the preferred term")
    Quit $$$OK
}

}
