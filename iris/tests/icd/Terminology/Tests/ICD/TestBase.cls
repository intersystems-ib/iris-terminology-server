/// Shared ICD unit test fixture and HTTP helper methods.
Class Terminology.Tests.ICD.TestBase Extends Terminology.Tests.Snomed.TestBase
{

Parameter FixtureReleaseId = "UT-ICD-20260401";

Parameter FixtureVersion = 10;

Parameter FixtureCodeType = "DIAGNOSIS";

Parameter ParentCode = "A01";

Parameter ChildCode = "A01.0";

Parameter LeafCode = "A01.00";

Parameter InactiveCode = "A01.99";

Parameter FamilyCode = "A00-A09";

Parameter ChapterCode = "1";

/// Seeds a minimal release-scoped ICD dataset for the native API tests.
Method OnBeforeAllTests() As %Status
{
    Set tSC = ..CleanupFixture()
    If $$$ISERR(tSC) {
        Return tSC
    }

    Set tSC = ..InsertFamily(..#FamilyCode, "Infecciones intestinales", ..#ChapterCode, "A00", "A09")
    If $$$ISERR(tSC) {
        Return tSC
    }

    Set tSC = ..InsertCode(..#ParentCode, "Fiebre tifoidea", "", 1, 1)
    If $$$ISERR(tSC) {
        Return tSC
    }

    Set tSC = ..InsertCode(..#ChildCode, "Fiebre tifoidea con afectacion pulmonar", ..#ParentCode, 2, 1)
    If $$$ISERR(tSC) {
        Return tSC
    }

    Set tSC = ..InsertCode(..#LeafCode, "Fiebre tifoidea con afectacion pulmonar aguda", ..#ChildCode, 3, 1)
    If $$$ISERR(tSC) {
        Return tSC
    }

    Set tSC = ..InsertCode(..#InactiveCode, "Fiebre tifoidea historica", "", 2, 0)
    If $$$ISERR(tSC) {
        Return tSC
    }

    Set tSC = ..InsertHierarchyEdge(..#ParentCode, ..#ChildCode, 1)
    If $$$ISERR(tSC) {
        Return tSC
    }

    Set tSC = ..InsertHierarchyEdge(..#ChildCode, ..#LeafCode, 1)
    If $$$ISERR(tSC) {
        Return tSC
    }

    Return ..InsertHierarchyEdge(..#ParentCode, ..#LeafCode, 2)
}

/// Removes the synthetic release rows created for this test suite.
Method OnAfterAllTests() As %Status
{
    Return ..CleanupFixture()
}

/// Inserts one ICD code row with enough fields for lookup, search and hierarchy tests.
Method InsertCode(pCode As %String, pDescription As %String, pParentCode As %String, pHierarchyLevel As %Integer, pActive As %Boolean) As %Status
{
    Set code = ##class(Terminology.ICD.Code).%New()
    Set code.ReleaseId = ..#FixtureReleaseId
    Set code.Version = ..#FixtureVersion
    Set code.CodeType = ..#FixtureCodeType
    Set code.Code = pCode
    Set code.Description = pDescription
    Set code.DescriptionNorm = $ZCONVERT(pDescription, "L")
    Set code.ParentCode = pParentCode
    Set code.ChapterCode = ..#ChapterCode
    Set code.FamilyCode = ..#FamilyCode
    Set code.HierarchyLevel = pHierarchyLevel
    Set code.NodeFinal = $Select(pCode=..#LeafCode:1,1:0)
    Set code.Active = pActive
    Return code.%Save()
}

/// Inserts one ICD family row used by the native families endpoint.
Method InsertFamily(pFamilyCode As %String, pDescription As %String, pChapterCode As %String, pRangeStart As %String, pRangeEnd As %String) As %Status
{
    Set family = ##class(Terminology.ICD.Family).%New()
    Set family.ReleaseId = ..#FixtureReleaseId
    Set family.Version = ..#FixtureVersion
    Set family.CodeType = ..#FixtureCodeType
    Set family.FamilyCode = pFamilyCode
    Set family.Description = pDescription
    Set family.DescriptionNorm = $ZCONVERT(pDescription, "L")
    Set family.ChapterCode = pChapterCode
    Set family.RangeStart = pRangeStart
    Set family.RangeEnd = pRangeEnd
    Return family.%Save()
}

/// Inserts one transitive hierarchy edge row used by ancestor and descendant checks.
Method InsertHierarchyEdge(pParentCode As %String, pChildCode As %String, pDepth As %Integer) As %Status
{
    Set edge = ##class(Terminology.ICD.HierarchyEdge).%New()
    Set edge.ReleaseId = ..#FixtureReleaseId
    Set edge.Version = ..#FixtureVersion
    Set edge.CodeType = ..#FixtureCodeType
    Set edge.HierarchyType = "CODE"
    Set edge.ParentCode = pParentCode
    Set edge.ChildCode = pChildCode
    Set edge.Depth = pDepth
    Return edge.%Save()
}

/// Deletes all synthetic rows for the dedicated fixture release.
Method CleanupFixture() As %Status
{
    Set statements = $LB(
        "DELETE FROM Terminology_ICD.HierarchyEdge WHERE ReleaseId = ?",
        "DELETE FROM Terminology_ICD.Family WHERE ReleaseId = ?",
        "DELETE FROM Terminology_ICD.Code WHERE ReleaseId = ?"
    )

    For index=1:1:$LISTLENGTH(statements) {
        Set tSC = ..ExecuteUpdate($LISTGET(statements, index), ..#FixtureReleaseId)
        If $$$ISERR(tSC) {
            Return tSC
        }
    }

    Return $$$OK
}

/// Calls the deployed native ICD API over loopback HTTP and parses the JSON response.
Method InvokeApi(pMethodName As %String, pArg1 As %String = "", pArg2 As %String = "", pParamList As %List = "", Output pResponseObject As %DynamicObject, Output pHttpStatus As %String) As %Status
{
    Set pResponseObject = {}
    Set pHttpStatus = ""
    Set path = ..BuildApiPath(pMethodName, pArg1, pArg2, pParamList)
    If path = "" {
        Return $$$ERROR($$$GeneralError, "Unsupported API method for test helper: "_pMethodName)
    }

    Try {
        Set request = ##class(%Net.HttpRequest).%New()
        Set request.Server = "127.0.0.1"
        Set request.Port = 52773
        Set request.Https = 0
        Set request.ContentType = "application/json"
        Set request.Username = "superuser"
        Set request.Password = "SYS"

        Set tSC = request.Get(path)
        If $$$ISERR(tSC) {
            Return tSC
        }

        Set response = request.HttpResponse
        If '$IsObject(response) {
            Return $$$ERROR($$$GeneralError, "No HTTP response returned by "_pMethodName)
        }

        Set pHttpStatus = response.StatusLine
        Set payload = ..ReadHttpResponseBody(response)
        If (response.StatusCode < 200) || (response.StatusCode > 299) {
            Return $$$ERROR($$$GeneralError, "HTTP "_response.StatusCode_" returned by "_pMethodName_": "_payload)
        }

        If payload '= "" {
            Set pResponseObject = ##class(%DynamicObject).%FromJSON(payload)
        }

        Return $$$OK
    } Catch ex {
        Return ex.AsStatus()
    }
}

/// Maps test helper method names to native ICD API routes.
Method BuildApiPath(pMethodName As %String, pArg1 As %String = "", pArg2 As %String = "", pParamList As %List = "") As %String
{
    Set basePath = "/terminology/icd"

    If pMethodName = "Search" {
        Set path = basePath_"/search"
    } ElseIf pMethodName = "GetCode" {
        Set path = basePath_"/codes/"_pArg1
    } ElseIf pMethodName = "GetChildren" {
        Set path = basePath_"/codes/"_pArg1_"/children"
    } ElseIf pMethodName = "GetDescendants" {
        Set path = basePath_"/codes/"_pArg1_"/descendants"
    } ElseIf pMethodName = "GetAncestors" {
        Set path = basePath_"/codes/"_pArg1_"/ancestors"
    } ElseIf pMethodName = "GetFamilies" {
        Set path = basePath_"/families"
    } ElseIf pMethodName = "ValidateCode" {
        Set path = basePath_"/validate-code"
    } Else {
        Return ""
    }

    Set query = ..BuildQueryString(pParamList)
    If query '= "" {
        Set path = path_"?"_query
    }

    Return path
}

}
