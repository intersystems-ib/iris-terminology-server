Class Terminology.Production.BO.LoincRepositoryOperation Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

XData MessageMap
{
<MapItems>
    <MapItem MessageType="Terminology.Production.Msg.LoincSearchRequest">
        <Method>HandleSearch</Method>
    </MapItem>
    <MapItem MessageType="Terminology.Production.Msg.LoincGetCodeRequest">
        <Method>HandleGetCode</Method>
    </MapItem>
    <MapItem MessageType="Terminology.Production.Msg.LoincGetDisplaysRequest">
        <Method>HandleGetDisplays</Method>
    </MapItem>
    <MapItem MessageType="Terminology.Production.Msg.LoincGetPartsRequest">
        <Method>HandleGetParts</Method>
    </MapItem>
    <MapItem MessageType="Terminology.Production.Msg.LoincGetAncestorsRequest">
        <Method>HandleGetAncestors</Method>
    </MapItem>
    <MapItem MessageType="Terminology.Production.Msg.LoincGetDescendantsRequest">
        <Method>HandleGetDescendants</Method>
    </MapItem>
    <MapItem MessageType="Terminology.Production.Msg.LoincGetGroupsRequest">
        <Method>HandleGetGroups</Method>
    </MapItem>
    <MapItem MessageType="Terminology.Production.Msg.LoincGetGroupMembersRequest">
        <Method>HandleGetGroupMembers</Method>
    </MapItem>
    <MapItem MessageType="Terminology.Production.Msg.LoincValidateCodeRequest">
        <Method>HandleValidateCode</Method>
    </MapItem>
</MapItems>
}

Method OnMessage(pRequest As Ens.Request, Output pResponse As Ens.Response) As %Status
{
    Return $$$ERROR($$$NotImplemented, "Tipo de mensaje no soportado por LoincRepositoryOperation")
}

Method HandleSearch(pRequest As Terminology.Production.Msg.LoincSearchRequest, Output pResponse As Terminology.Production.Msg.LoincSearchResponse) As %Status
{
    Set pResponse = ##class(Terminology.Production.Msg.LoincSearchResponse).%New()

    Try {
        Set whereList = ""
        Set query = ""
        Set sql = "SELECT %ID, LoincNum, Display, DisplayType "_
                  "FROM Terminology_Loinc.Display "
        Set endSQL = "ORDER BY RankOrder, Display"

        If (pRequest.ReleaseId '= "") {
            Set whereList = whereList_$ListBuild("ReleaseId = ?")
            Set tArgs($I(tArgs)) = pRequest.ReleaseId
        }

        If (pRequest.Lang '= "") {
            Set whereList = whereList_$ListBuild("Lang = ?")
            Set tArgs($I(tArgs)) = pRequest.Lang
        }

        If (pRequest.Query '= "") {
            Set whereList = whereList_$ListBuild("DisplayNorm %STARTSWITH ?")
            Set tArgs($I(tArgs)) = ..NormalizeTerm(pRequest.Query)
        }

        If (whereList '= "") {
            Set query = sql_"WHERE "_$ListToString(whereList," AND ")_" "_endSQL
        } Else {
            Set query = sql_" "_endSQL
        }

        Set statement = ##class(%SQL.Statement).%New()
        $$$ThrowOnError(statement.%Prepare(query))
        Set rset = statement.%Execute(tArgs...)

        Set items = []
        Set skipped = 0
        Set added = 0
        Set limit = $Select(pRequest.Limit>0:pRequest.Limit,1:20)
        Set offset = $Select(pRequest.Offset>0:pRequest.Offset,1:0)

        While rset.%Next() {
            If skipped < offset {
                Set skipped = skipped + 1
                Continue
            }
            If added >= limit {
                Continue
            }

            Set item = {}
            Set item.loincNum = rset.%Get("LoincNum")
            Set item.display = rset.%Get("Display")
            Set item.displayType = rset.%Get("DisplayType")
            Do items.%Push(item)
            Set added = added + 1
        }

        Set payload = {}
        Set payload.items = items
        Set payload.count = items.%Size()
        Set pResponse.Payload = payload
        Return $$$OK
    } Catch ex {
        Return $$$ERROR($$$GeneralError, ex.DisplayString())
    }
}

Method HandleGetCode(pRequest As Terminology.Production.Msg.LoincGetCodeRequest, Output pResponse As Terminology.Production.Msg.LoincGetCodeResponse) As %Status
{
    Set pResponse = ##class(Terminology.Production.Msg.LoincGetCodeResponse).%New()

    Try {
        Set whereList = ""
        Set query = ""

        Set sql = "SELECT %ID, LoincNum, Component, PropertyCode, TimeAspct, SystemCode, ScaleTyp, MethodTyp, "_
                  "ClassCode, Status, ConsumerName, ShortName, LongCommonName, DefinitionDescription, DisplayName "_
                  "FROM Terminology_Loinc.Code "

        If (pRequest.ReleaseId '= "") {
            Set whereList = whereList_$ListBuild("ReleaseId = ?")
            Set tArgs($I(tArgs)) = pRequest.ReleaseId
        }

        If (pRequest.LoincNum '= "") {
            Set whereList = whereList_$ListBuild("LoincNum = ?")
            Set tArgs($I(tArgs)) = pRequest.LoincNum
        }

        If (whereList '= "") {
            Set query = sql_"WHERE "_$ListToString(whereList," AND ")
        } Else {
            Set query = sql
        }

        Set statement = ##class(%SQL.Statement).%New()
        $$$ThrowOnError(statement.%Prepare(query))
        Set rset = statement.%Execute(tArgs...)

        Set payload = {}
        If rset.%Next() {
            Set payload.loincNum = rset.%Get("LoincNum")
            Set payload.component = rset.%Get("Component")
            Set payload.property = rset.%Get("PropertyCode")
            Set payload.timeAspct = rset.%Get("TimeAspct")
            Set payload.system = rset.%Get("SystemCode")
            Set payload.scaleTyp = rset.%Get("ScaleTyp")
            Set payload.methodTyp = rset.%Get("MethodTyp")
            Set payload.classCode = rset.%Get("ClassCode")
            Set payload.status = rset.%Get("Status")
            Set payload.consumerName = rset.%Get("ConsumerName")
            Set payload.shortName = rset.%Get("ShortName")
            Set payload.longCommonName = rset.%Get("LongCommonName")
            Set payload.definitionDescription = rset.%Get("DefinitionDescription")
            Set payload.displayName = rset.%Get("DisplayName")
        }

        Set pResponse.Payload = payload
        Return $$$OK
    } Catch ex {
        Return $$$ERROR($$$GeneralError, ex.DisplayString())
    }
}

Method HandleGetDisplays(pRequest As Terminology.Production.Msg.LoincGetDisplaysRequest, Output pResponse As Terminology.Production.Msg.LoincGetDisplaysResponse) As %Status
{
    Set pResponse = ##class(Terminology.Production.Msg.LoincGetDisplaysResponse).%New()

    Try {
        Set whereList = ""
        Set query = ""
        Set sql = "SELECT %ID, LoincNum, Lang, DisplayType, Display, RankOrder "_
                  "FROM Terminology_Loinc.Display "
        Set endSQL = "ORDER BY RankOrder, Display"

        If (pRequest.ReleaseId '= "") {
            Set whereList = whereList_$ListBuild("ReleaseId = ?")
            Set tArgs($I(tArgs)) = pRequest.ReleaseId
        }

        If (pRequest.LoincNum '= "") {
            Set whereList = whereList_$ListBuild("LoincNum = ?")
            Set tArgs($I(tArgs)) = pRequest.LoincNum
        }

        If (pRequest.Lang '= "") {
            Set whereList = whereList_$ListBuild("Lang = ?")
            Set tArgs($I(tArgs)) = pRequest.Lang
        }

        If (whereList '= "") {
            Set query = sql_"WHERE "_$ListToString(whereList," AND ")_" "_endSQL
        } Else {
            Set query = sql_" "_endSQL
        }

        Set statement = ##class(%SQL.Statement).%New()
        $$$ThrowOnError(statement.%Prepare(query))
        Set rset = statement.%Execute(tArgs...)

        Set items = []
        Set skipped = 0
        Set added = 0
        Set limit = $Select(pRequest.Limit>0:pRequest.Limit,1:100)
        Set offset = $Select(pRequest.Offset>0:pRequest.Offset,1:0)

        While rset.%Next() {
            If skipped < offset {
                Set skipped = skipped + 1
                Continue
            }
            If added >= limit {
                Continue
            }

            Set item = {}
            Set item.loincNum = rset.%Get("LoincNum")
            Set item.lang = rset.%Get("Lang")
            Set item.displayType = rset.%Get("DisplayType")
            Set item.display = rset.%Get("Display")
            Set item.rankOrder = rset.%Get("RankOrder")
            Do items.%Push(item)
            Set added = added + 1
        }

        Set payload = {}
        Set payload.items = items
        Set payload.count = items.%Size()
        Set pResponse.Payload = payload
        Return $$$OK
    } Catch ex {
        Return $$$ERROR($$$GeneralError, ex.DisplayString())
    }
}

Method HandleGetParts(pRequest As Terminology.Production.Msg.LoincGetPartsRequest, Output pResponse As Terminology.Production.Msg.LoincGetPartsResponse) As %Status
{
    Set pResponse = ##class(Terminology.Production.Msg.LoincGetPartsResponse).%New()

    Try {
        Set whereList = ""
        Set query = ""

        Set sql = "SELECT l.%ID, l.LoincNum, l.PartNumber, l.PartTypeName, l.LinkTypeName, l.PropertySlot, "_
                  "p.PartName, p.PartDisplayName, p.Status "_
                  "FROM Terminology_Loinc.CodePartLink l "_
                  "LEFT JOIN Terminology_Loinc.Part p "_
                  "ON p.ReleaseId = l.ReleaseId AND p.PartNumber = l.PartNumber "

        Set endSQL = "ORDER BY l.PartTypeName, p.PartDisplayName"

        If (pRequest.ReleaseId '= "") {
            Set whereList = whereList_$ListBuild("l.ReleaseId = ?")
            Set tArgs($I(tArgs)) = pRequest.ReleaseId
        }

        If (pRequest.LoincNum '= "") {
            Set whereList = whereList_$ListBuild("l.LoincNum = ?")
            Set tArgs($I(tArgs)) = pRequest.LoincNum
        }

        If (whereList '= "") {
            Set query = sql_"WHERE "_$ListToString(whereList," AND ")_" "_endSQL
        } Else {
            Set query = sql_" "_endSQL
        }

        Set statement = ##class(%SQL.Statement).%New()
        $$$ThrowOnError(statement.%Prepare(query))
        Set rset = statement.%Execute(tArgs...)

        Set items = []
        Set skipped = 0
        Set added = 0
        Set limit = $Select(pRequest.Limit>0:pRequest.Limit,1:200)
        Set offset = $Select(pRequest.Offset>0:pRequest.Offset,1:0)

        While rset.%Next() {
            If skipped < offset {
                Set skipped = skipped + 1
                Continue
            }
            If added >= limit {
                Continue
            }

            Set item = {}
            Set item.loincNum = rset.%Get("LoincNum")
            Set item.partNumber = rset.%Get("PartNumber")
            Set item.partTypeName = rset.%Get("PartTypeName")
            Set item.linkTypeName = rset.%Get("LinkTypeName")
            Set item.propertySlot = rset.%Get("PropertySlot")
            Set item.partName = rset.%Get("PartName")
            Set item.partDisplayName = rset.%Get("PartDisplayName")
            Set item.status = rset.%Get("Status")
            Do items.%Push(item)
            Set added = added + 1
        }

        Set payload = {}
        Set payload.items = items
        Set payload.count = items.%Size()
        Set pResponse.Payload = payload
        Return $$$OK
    } Catch ex {
        Return $$$ERROR($$$GeneralError, ex.DisplayString())
    }
}

Method HandleGetAncestors(pRequest As Terminology.Production.Msg.LoincGetAncestorsRequest, Output pResponse As Terminology.Production.Msg.LoincGetAncestorsResponse) As %Status
{
    Set pResponse = ##class(Terminology.Production.Msg.LoincGetAncestorsResponse).%New()

    Try {
        Set whereList = ""
        Set query = ""
        Set sql = "SELECT %ID, AncestorCode, DescendantCode, Depth "_
                  "FROM Terminology_Loinc.Closure "
        Set endSQL = "ORDER BY Depth, AncestorCode"

        If (pRequest.ReleaseId '= "") {
            Set whereList = whereList_$ListBuild("ReleaseId = ?")
            Set tArgs($I(tArgs)) = pRequest.ReleaseId
        }

        If (pRequest.HierarchyType '= "") {
            Set whereList = whereList_$ListBuild("HierarchyType = ?")
            Set tArgs($I(tArgs)) = pRequest.HierarchyType
        }

        If (pRequest.Code '= "") {
            Set whereList = whereList_$ListBuild("DescendantCode = ?")
            Set tArgs($I(tArgs)) = pRequest.Code
        }

        If (pRequest.MaxDepth > 0) {
            Set whereList = whereList_$ListBuild("Depth <= ?")
            Set tArgs($I(tArgs)) = pRequest.MaxDepth
        }

        If (whereList '= "") {
            Set query = sql_"WHERE "_$ListToString(whereList," AND ")_" "_endSQL
        } Else {
            Set query = sql_" "_endSQL
        }

        Set statement = ##class(%SQL.Statement).%New()
        $$$ThrowOnError(statement.%Prepare(query))
        Set rset = statement.%Execute(tArgs...)

        Set items = []
        Set skipped = 0
        Set added = 0
        Set limit = $Select(pRequest.Limit>0:pRequest.Limit,1:100)
        Set offset = $Select(pRequest.Offset>0:pRequest.Offset,1:0)

        While rset.%Next() {
            If skipped < offset {
                Set skipped = skipped + 1
                Continue
            }
            If added >= limit {
                Continue
            }

            Set item = {}
            Set item.ancestorCode = rset.%Get("AncestorCode")
            Set item.descendantCode = rset.%Get("DescendantCode")
            Set item.depth = rset.%Get("Depth")
            Do items.%Push(item)
            Set added = added + 1
        }

        Set payload = {}
        Set payload.items = items
        Set payload.count = items.%Size()
        Set pResponse.Payload = payload
        Return $$$OK
    } Catch ex {
        Return $$$ERROR($$$GeneralError, ex.DisplayString())
    }
}

Method HandleGetDescendants(pRequest As Terminology.Production.Msg.LoincGetDescendantsRequest, Output pResponse As Terminology.Production.Msg.LoincGetDescendantsResponse) As %Status
{
    Set pResponse = ##class(Terminology.Production.Msg.LoincGetDescendantsResponse).%New()

    Try {
        Set whereList = ""
        Set query = ""
        Set sql = "SELECT %ID, AncestorCode, DescendantCode, Depth "_
                  "FROM Terminology_Loinc.Closure "
        Set endSQL = "ORDER BY Depth, DescendantCode"

        If (pRequest.ReleaseId '= "") {
            Set whereList = whereList_$ListBuild("ReleaseId = ?")
            Set tArgs($I(tArgs)) = pRequest.ReleaseId
        }

        If (pRequest.HierarchyType '= "") {
            Set whereList = whereList_$ListBuild("HierarchyType = ?")
            Set tArgs($I(tArgs)) = pRequest.HierarchyType
        }

        If (pRequest.Code '= "") {
            Set whereList = whereList_$ListBuild("AncestorCode = ?")
            Set tArgs($I(tArgs)) = pRequest.Code
        }

        If (pRequest.MaxDepth > 0) {
            Set whereList = whereList_$ListBuild("Depth <= ?")
            Set tArgs($I(tArgs)) = pRequest.MaxDepth
        }

        If (whereList '= "") {
            Set query = sql_"WHERE "_$ListToString(whereList," AND ")_" "_endSQL
        } Else {
            Set query = sql_" "_endSQL
        }

        Set statement = ##class(%SQL.Statement).%New()
        $$$ThrowOnError(statement.%Prepare(query))
        Set rset = statement.%Execute(tArgs...)

        Set items = []
        Set skipped = 0
        Set added = 0
        Set limit = $Select(pRequest.Limit>0:pRequest.Limit,1:100)
        Set offset = $Select(pRequest.Offset>0:pRequest.Offset,1:0)

        While rset.%Next() {
            If skipped < offset {
                Set skipped = skipped + 1
                Continue
            }
            If added >= limit {
                Continue
            }

            Set item = {}
            Set item.ancestorCode = rset.%Get("AncestorCode")
            Set item.descendantCode = rset.%Get("DescendantCode")
            Set item.depth = rset.%Get("Depth")
            Do items.%Push(item)
            Set added = added + 1
        }

        Set payload = {}
        Set payload.items = items
        Set payload.count = items.%Size()
        Set pResponse.Payload = payload
        Return $$$OK
    } Catch ex {
        Return $$$ERROR($$$GeneralError, ex.DisplayString())
    }
}

Method HandleGetGroups(pRequest As Terminology.Production.Msg.LoincGetGroupsRequest, Output pResponse As Terminology.Production.Msg.LoincGetGroupsResponse) As %Status
{
    Set pResponse = ##class(Terminology.Production.Msg.LoincGetGroupsResponse).%New()

    Try {
        Set whereList = ""
        Set query = ""
        Set sql = "SELECT %ID, GroupId, GroupName, GroupType, Version "_
                  "FROM Terminology_Loinc.LoincGroup "
        Set endSQL = "ORDER BY GroupName"

        If (pRequest.ReleaseId '= "") {
            Set whereList = whereList_$ListBuild("ReleaseId = ?")
            Set tArgs($I(tArgs)) = pRequest.ReleaseId
        }

        If (whereList '= "") {
            Set query = sql_"WHERE "_$ListToString(whereList," AND ")_" "_endSQL
        } Else {
            Set query = sql_" "_endSQL
        }

        Set statement = ##class(%SQL.Statement).%New()
        $$$ThrowOnError(statement.%Prepare(query))
        Set rset = statement.%Execute(tArgs...)

        Set items = []
        Set skipped = 0
        Set added = 0
        Set limit = $Select(pRequest.Limit>0:pRequest.Limit,1:100)
        Set offset = $Select(pRequest.Offset>0:pRequest.Offset,1:0)

        While rset.%Next() {
            If skipped < offset {
                Set skipped = skipped + 1
                Continue
            }
            If added >= limit {
                Continue
            }

            Set item = {}
            Set item.groupId = rset.%Get("GroupId")
            Set item.groupName = rset.%Get("GroupName")
            Set item.groupType = rset.%Get("GroupType")
            Set item.version = rset.%Get("Version")
            Do items.%Push(item)
            Set added = added + 1
        }

        Set payload = {}
        Set payload.items = items
        Set payload.count = items.%Size()
        Set pResponse.Payload = payload
        Return $$$OK
    } Catch ex {
        Return $$$ERROR($$$GeneralError, ex.DisplayString())
    }
}

Method HandleGetGroupMembers(pRequest As Terminology.Production.Msg.LoincGetGroupMembersRequest, Output pResponse As Terminology.Production.Msg.LoincGetGroupMembersResponse) As %Status
{
    Set pResponse = ##class(Terminology.Production.Msg.LoincGetGroupMembersResponse).%New()

    Try {
        Set whereList = ""
        Set joinList = ""
        Set query = ""

        Set sql = "SELECT gm.%ID, gm.GroupId, gm.LoincNum, d.Display "_
                  "FROM Terminology_Loinc.GroupMember gm "_
                  "LEFT JOIN Terminology_Loinc.Display d "_
                  "ON d.ReleaseId = gm.ReleaseId AND d.LoincNum = gm.LoincNum "

        Set endSQL = "ORDER BY d.RankOrder, d.Display, gm.LoincNum"

        If (pRequest.Lang '= "") {
            Set joinList = joinList_$ListBuild("d.Lang = ?")
            Set tArgs($I(tArgs)) = pRequest.Lang

            Set joinList = joinList_$ListBuild("d.RankOrder = 0 OR d.RankOrder = 1")
        }

        If (pRequest.ReleaseId '= "") {
            Set whereList = whereList_$ListBuild("gm.ReleaseId = ?")
            Set tArgs($I(tArgs)) = pRequest.ReleaseId
        }

        If (pRequest.GroupId '= "") {
            Set whereList = whereList_$ListBuild("gm.GroupId = ?")
            Set tArgs($I(tArgs)) = pRequest.GroupId
        }

        If (joinList '= "") {
            Set sql = sql_" AND ("_$ListToString(joinList," AND ")_") "
        }

        If (whereList '= "") {
            Set query = sql_"WHERE "_$ListToString(whereList," AND ")_" "_endSQL
        } Else {
            Set query = sql_" "_endSQL
        }

        Set statement = ##class(%SQL.Statement).%New()
        $$$ThrowOnError(statement.%Prepare(query))
        Set rset = statement.%Execute(tArgs...)

        Set items = []
        Set skipped = 0
        Set added = 0
        Set limit = $Select(pRequest.Limit>0:pRequest.Limit,1:100)
        Set offset = $Select(pRequest.Offset>0:pRequest.Offset,1:0)

        While rset.%Next() {
            If skipped < offset {
                Set skipped = skipped + 1
                Continue
            }
            If added >= limit {
                Continue
            }

            Set item = {}
            Set item.groupId = rset.%Get("GroupId")
            Set item.loincNum = rset.%Get("LoincNum")
            Set item.display = rset.%Get("Display")
            Do items.%Push(item)
            Set added = added + 1
        }

        Set payload = {}
        Set payload.items = items
        Set payload.count = items.%Size()
        Set pResponse.Payload = payload
        Return $$$OK
    } Catch ex {
        Return $$$ERROR($$$GeneralError, ex.DisplayString())
    }
}

Method HandleValidateCode(pRequest As Terminology.Production.Msg.LoincValidateCodeRequest, Output pResponse As Terminology.Production.Msg.LoincValidateCodeResponse) As %Status
{
    Set pResponse = ##class(Terminology.Production.Msg.LoincValidateCodeResponse).%New()

    Try {
        Set whereList = ""
        Set query = ""
        Set sql = "SELECT %ID, Status "_
                  "FROM Terminology_Loinc.Code "

        If (pRequest.ReleaseId '= "") {
            Set whereList = whereList_$ListBuild("ReleaseId = ?")
            Set tArgs($I(tArgs)) = pRequest.ReleaseId
        }

        If (pRequest.Code '= "") {
            Set whereList = whereList_$ListBuild("LoincNum = ?")
            Set tArgs($I(tArgs)) = pRequest.Code
        }

        If (whereList '= "") {
            Set query = sql_"WHERE "_$ListToString(whereList," AND ")
        } Else {
            Set query = sql
        }

        Set statement = ##class(%SQL.Statement).%New()
        $$$ThrowOnError(statement.%Prepare(query))
        Set rset = statement.%Execute(tArgs...)

        Set payload = {}

        If rset.%Next() {
            Set payload.exists = 1
            Set payload.status = rset.%Get("Status")
            Set payload.active = $Select($ZCONVERT($Get(payload.status),"L")="active":1,1:0)
        } Else {
            Set payload.exists = 0
            Set payload.status = ""
            Set payload.active = 0
        }

        Set pResponse.Payload = payload
        Return $$$OK
    } Catch ex {
        Return $$$ERROR($$$GeneralError, ex.DisplayString())
    }
}

ClassMethod NormalizeTerm(pValue As %String) As %String
{
    Quit $ZCONVERT($Get(pValue),"L")
}

}
