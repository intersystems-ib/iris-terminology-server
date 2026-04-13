/// Covers the deployed native /terminology/icd HTTP surface.
Class Terminology.Tests.ICD.ApiTests Extends Terminology.Tests.ICD.TestBase
{

/// Verifies native search and code lookup responses over HTTP.
Method TestSearchAndGetCodeEndpoints() As %Status
{
    Set params = $LB("releaseId", ..#FixtureReleaseId, "version", ..#FixtureVersion, "codeType", ..#FixtureCodeType, "q", "tifoidea", "limit", 20, "offset", 0)
    Set tSC = ..InvokeApi("Search", "", "", params, .searchResponse, .httpStatus)
    Do ..AssertStatusOKViaMacro("", tSC, "Search API invocation returns OK")
    Do ..AssertEqualsViaMacro("", searchResponse.%Get("Count"), 4, "Search endpoint returns all synthetic tifoidea rows")
    Set searchItem = ..GetArrayItem(searchResponse, "Items", 0)
    Do ..AssertEqualsViaMacro("", searchItem.%Get("Code"), ..#ParentCode, "Search endpoint returns the parent code first")
    Do ..AssertEqualsViaMacro("", searchItem.%Get("Description"), "Fiebre tifoidea", "Search endpoint returns the parent description")

    Set params = $LB("releaseId", ..#FixtureReleaseId, "version", ..#FixtureVersion, "codeType", ..#FixtureCodeType)
    Set tSC = ..InvokeApi("GetCode", ..#LeafCode, "", params, .codeResponse, .httpStatus)
    Do ..AssertStatusOKViaMacro("", tSC, "GetCode API invocation returns OK")
    Do ..AssertEqualsViaMacro("", codeResponse.%Get("Code"), ..#LeafCode, "GetCode returns the requested code")
    Do ..AssertEqualsViaMacro("", codeResponse.%Get("ParentCode"), ..#ChildCode, "GetCode returns the direct parent code")
    Do ..AssertEqualsViaMacro("", codeResponse.%Get("FamilyCode"), ..#FamilyCode, "GetCode returns the expected family code")
    Do ..AssertEqualsViaMacro("", codeResponse.%Get("Active"), 1, "GetCode returns the active flag")
    Return $$$OK
}

/// Verifies native hierarchy and family responses over HTTP.
Method TestHierarchyAndFamiliesEndpoints() As %Status
{
    Set params = $LB("releaseId", ..#FixtureReleaseId, "version", ..#FixtureVersion, "codeType", ..#FixtureCodeType, "limit", 100, "offset", 0)
    Set tSC = ..InvokeApi("GetChildren", ..#ParentCode, "", params, .childrenResponse, .httpStatus)
    Do ..AssertStatusOKViaMacro("", tSC, "GetChildren API invocation returns OK")
    Do ..AssertEqualsViaMacro("", childrenResponse.%Get("Count"), 1, "GetChildren returns one direct child")
    Set childItem = ..GetArrayItem(childrenResponse, "Items", 0)
    Do ..AssertEqualsViaMacro("", childItem.%Get("Code"), ..#ChildCode, "GetChildren returns the synthetic child")

    Set params = $LB("releaseId", ..#FixtureReleaseId, "version", ..#FixtureVersion, "codeType", ..#FixtureCodeType, "includeSelf", 1, "maxDepth", 10, "limit", 100, "offset", 0)
    Set tSC = ..InvokeApi("GetDescendants", ..#ParentCode, "", params, .descendantsResponse, .httpStatus)
    Do ..AssertStatusOKViaMacro("", tSC, "GetDescendants API invocation returns OK")
    Do ..AssertEqualsViaMacro("", descendantsResponse.%Get("Count"), 3, "GetDescendants returns self plus both descendants")
    Set leafDescendant = ..FindArrayItemByProperty(descendantsResponse, "Items", "Code", ..#LeafCode)
    Do ..AssertNotEqualsViaMacro("", leafDescendant, "", "GetDescendants includes the synthetic leaf")
    Do ..AssertEqualsViaMacro("", leafDescendant.%Get("Depth"), 2, "GetDescendants preserves the transitive depth")

    Set tSC = ..InvokeApi("GetAncestors", ..#LeafCode, "", params, .ancestorsResponse, .httpStatus)
    Do ..AssertStatusOKViaMacro("", tSC, "GetAncestors API invocation returns OK")
    Do ..AssertEqualsViaMacro("", ancestorsResponse.%Get("Count"), 3, "GetAncestors returns self plus both ancestors")
    Set ancestorParent = ..FindArrayItemByProperty(ancestorsResponse, "Items", "Code", ..#ParentCode)
    Do ..AssertNotEqualsViaMacro("", ancestorParent, "", "GetAncestors includes the synthetic parent")

    Set params = $LB("releaseId", ..#FixtureReleaseId, "version", ..#FixtureVersion, "codeType", ..#FixtureCodeType, "limit", 100, "offset", 0)
    Set tSC = ..InvokeApi("GetFamilies", "", "", params, .familiesResponse, .httpStatus)
    Do ..AssertStatusOKViaMacro("", tSC, "GetFamilies API invocation returns OK")
    Do ..AssertEqualsViaMacro("", familiesResponse.%Get("Count"), 1, "GetFamilies returns the synthetic family")
    Set familyItem = ..GetArrayItem(familiesResponse, "Items", 0)
    Do ..AssertEqualsViaMacro("", familyItem.%Get("FamilyCode"), ..#FamilyCode, "GetFamilies returns the family code")
    Do ..AssertEqualsViaMacro("", familyItem.%Get("RangeStart"), "A00", "GetFamilies returns the family range start")
    Return $$$OK
}

/// Verifies native validate-code semantics for active, inactive and missing codes.
Method TestValidateCodeEndpoint() As %Status
{
    Set params = $LB("releaseId", ..#FixtureReleaseId, "version", ..#FixtureVersion, "codeType", ..#FixtureCodeType, "code", ..#ParentCode)
    Set tSC = ..InvokeApi("ValidateCode", "", "", params, .activeResponse, .httpStatus)
    Do ..AssertStatusOKViaMacro("", tSC, "ValidateCode API invocation returns OK for active code")
    Do ..AssertEqualsViaMacro("", activeResponse.%Get("Exists"), 1, "Active code exists at the API")
    Do ..AssertEqualsViaMacro("", activeResponse.%Get("Active"), 1, "Active code is marked active")
    Do ..AssertEqualsViaMacro("", activeResponse.%Get("Code"), ..#ParentCode, "Active code response echoes the code")

    Set params = $LB("releaseId", ..#FixtureReleaseId, "version", ..#FixtureVersion, "codeType", ..#FixtureCodeType, "code", ..#InactiveCode)
    Set tSC = ..InvokeApi("ValidateCode", "", "", params, .inactiveResponse, .httpStatus)
    Do ..AssertStatusOKViaMacro("", tSC, "ValidateCode API invocation returns OK for inactive code")
    Do ..AssertEqualsViaMacro("", inactiveResponse.%Get("Exists"), 1, "Inactive code still exists at the API")
    Do ..AssertEqualsViaMacro("", inactiveResponse.%Get("Active"), 0, "Inactive code is not active")

    Set params = $LB("releaseId", ..#FixtureReleaseId, "version", ..#FixtureVersion, "codeType", ..#FixtureCodeType, "code", "A99.999")
    Set tSC = ..InvokeApi("ValidateCode", "", "", params, .missingResponse, .httpStatus)
    Do ..AssertStatusOKViaMacro("", tSC, "ValidateCode API invocation returns OK for missing code")
    Do ..AssertEqualsViaMacro("", missingResponse.%Get("Exists"), 0, "Missing code does not exist at the API")
    Do ..AssertEqualsViaMacro("", missingResponse.%Get("Active"), 0, "Missing code is not active")
    Return $$$OK
}

/// Returns the first array item whose property matches the requested value.
Method FindArrayItemByProperty(pObject As %DynamicObject, pProperty As %String, pFieldName As %String, pExpectedValue As %String) As %DynamicObject
{
    Set array = pObject.%Get(pProperty)
    If '$IsObject(array) {
        Return ""
    }

    For index=0:1:(array.%Size()-1) {
        Set item = array.%Get(index)
        If $IsObject(item) && (item.%Get(pFieldName) = pExpectedValue) {
            Return item
        }
    }

    Return ""
}

}
