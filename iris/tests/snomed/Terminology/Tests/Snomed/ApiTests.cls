/// Covers the deployed native /terminology/snomed HTTP surface.
Class Terminology.Tests.Snomed.ApiTests Extends Terminology.Tests.Snomed.TestBase
{

/// Verifies native search and concept lookup responses over HTTP.
Method TestSearchAndConceptEndpoints() As %Status
{
    Set params = $LB("releaseId", ..#FixtureReleaseId, "q", "hijo")
    Set tSC = ..InvokeApi("Search", "", "", params, .searchResponse, .httpStatus)
    Do ..AssertStatusOKViaMacro("", tSC, "Search API invocation returns OK")
    Do ..AssertEqualsViaMacro("", searchResponse.%Get("count"), 1, "Search endpoint returns one result")

    Set item = ..GetArrayItem(searchResponse, "items", 0)
    Do ..AssertEqualsViaMacro("", item.%Get("conceptId"), ..#ChildConceptId, "Search endpoint returns the child concept")
    Do ..AssertEqualsViaMacro("", item.%Get("preferredTerm"), "Concepto hijo sintetico", "Search endpoint returns the preferred term")

    Set params = $LB("releaseId", ..#FixtureReleaseId, "lang", "es", "dialect", "es-ES")
    Set tSC = ..InvokeApi("GetConcept", ..#ChildConceptId, "", params, .conceptResponse, .httpStatus)
    Do ..AssertStatusOKViaMacro("", tSC, "GetConcept API invocation returns OK")
    Do ..AssertEqualsViaMacro("", conceptResponse.%Get("conceptId"), ..#ChildConceptId, "GetConcept returns the requested concept")
    Do ..AssertEqualsViaMacro("", conceptResponse.%Get("preferredTerm"), "Concepto hijo sintetico", "GetConcept returns the preferred term")
    Quit $$$OK
}

/// Verifies native validate-code and subsumes responses over HTTP.
Method TestValidateCodeAndSubsumesEndpoints() As %Status
{
    Set params = $LB("releaseId", ..#FixtureReleaseId, "code", ..#ChildConceptId)
    Set tSC = ..InvokeApi("ValidateCode", "", "", params, .activeResponse, .httpStatus)
    Do ..AssertStatusOKViaMacro("", tSC, "ValidateCode API invocation returns OK for active concept")
    Do ..AssertEqualsViaMacro("", activeResponse.%Get("exists"), 1, "Active concept exists at the API")
    Do ..AssertEqualsViaMacro("", activeResponse.%Get("active"), 1, "Active concept is active at the API")

    Set params = $LB("releaseId", ..#FixtureReleaseId, "code", ..#InactiveConceptId)
    Set tSC = ..InvokeApi("ValidateCode", "", "", params, .inactiveResponse, .httpStatus)
    Do ..AssertStatusOKViaMacro("", tSC, "ValidateCode API invocation returns OK for inactive concept")
    Do ..AssertEqualsViaMacro("", inactiveResponse.%Get("exists"), 1, "Inactive concept exists at the API")
    Do ..AssertEqualsViaMacro("", inactiveResponse.%Get("active"), 0, "Inactive concept is inactive at the API")

    Set params = $LB("releaseId", ..#FixtureReleaseId, "code", "999999999999")
    Set tSC = ..InvokeApi("ValidateCode", "", "", params, .missingResponse, .httpStatus)
    Do ..AssertStatusOKViaMacro("", tSC, "ValidateCode API invocation returns OK for missing concept")
    Do ..AssertEqualsViaMacro("", missingResponse.%Get("exists"), 0, "Missing concept does not exist at the API")

    Set params = $LB("releaseId", ..#FixtureReleaseId, "view", "inferred")
    Set tSC = ..InvokeApi("GetSubsumes", ..#ParentConceptId, ..#ChildConceptId, params, .subsumesResponse, .httpStatus)
    Do ..AssertStatusOKViaMacro("", tSC, "GetSubsumes API invocation returns OK")
    Do ..AssertEqualsViaMacro("", subsumesResponse.%Get("relationship"), "subsumes", "GetSubsumes reports the ancestor relationship")
    Quit $$$OK
}

/// Verifies native hierarchy and refset responses over HTTP.
Method TestHierarchyAndRefsetEndpoints() As %Status
{
    Set params = $LB("releaseId", ..#FixtureReleaseId, "view", "inferred", "lang", "es", "dialect", "es-ES")
    Set tSC = ..InvokeApi("GetChildren", ..#ParentConceptId, "", params, .childrenResponse, .httpStatus)
    Do ..AssertStatusOKViaMacro("", tSC, "GetChildren API invocation returns OK")
    Do ..AssertEqualsViaMacro("", childrenResponse.%Get("count"), 1, "GetChildren returns one result")
    Set childItem = ..GetArrayItem(childrenResponse, "items", 0)
    Do ..AssertEqualsViaMacro("", childItem.%Get("conceptId"), ..#ChildConceptId, "GetChildren returns the synthetic child")

    Set params = $LB("releaseId", ..#FixtureReleaseId)
    Set tSC = ..InvokeApi("GetRefsets", "", "", params, .refsetsResponse, .httpStatus)
    Do ..AssertStatusOKViaMacro("", tSC, "GetRefsets API invocation returns OK")
    Do ..AssertEqualsViaMacro("", refsetsResponse.%Get("count"), 1, "GetRefsets returns one refset")
    Set refsetItem = ..GetArrayItem(refsetsResponse, "items", 0)
    Do ..AssertEqualsViaMacro("", refsetItem.%Get("refsetId"), ..#RefsetId, "GetRefsets returns the synthetic refset")

    Set params = $LB("releaseId", ..#FixtureReleaseId, "lang", "es", "dialect", "es-ES")
    Set tSC = ..InvokeApi("GetRefsetMembers", ..#RefsetId, "", params, .membersResponse, .httpStatus)
    Do ..AssertStatusOKViaMacro("", tSC, "GetRefsetMembers API invocation returns OK")
    Do ..AssertEqualsViaMacro("", membersResponse.%Get("count"), 1, "GetRefsetMembers returns only active members")
    Set memberItem = ..GetArrayItem(membersResponse, "items", 0)
    Do ..AssertEqualsViaMacro("", memberItem.%Get("conceptId"), ..#ChildConceptId, "GetRefsetMembers returns the referenced concept")
    Do ..AssertEqualsViaMacro("", memberItem.%Get("preferredTerm"), "Concepto hijo sintetico", "GetRefsetMembers resolves the preferred term")
    Quit $$$OK
}

}
