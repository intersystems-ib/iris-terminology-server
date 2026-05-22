Class Terminology.Production.BP.ICDLoad Extends Ens.BusinessProcess
{

Property ClearBeforeLoad As %Boolean [ InitialExpression = 0 ];

Property GenerateVectors As %Boolean [ InitialExpression = 0 ];

Property Lang As %String(MAXLEN = 10) [ InitialExpression = "es" ];

Property SystemUri As %String(MAXLEN = 200);

Property EffectiveDate As %Date;

Property SetActive As %Boolean [ InitialExpression = 1 ];

Parameter SETTINGS = "ClearBeforeLoad,GenerateVectors,Lang,SystemUri,EffectiveDate,SetActive";

Method OnRequest(pRequest As Terminology.Production.Msg.ICDLoadRequest, Output pResponse As Ens.Response) As %Status
{
    Try {
        $$$LOGINFO("ICDLoad start "_pRequest.FilePath)

        Set tSC = ##class(Terminology.ICD.Utils.Loader).LoadSnapshot(
            pRequest.FilePath,
            pRequest.ReleaseId,
            pRequest.Version,
            pRequest.CodeType,
            ..SystemUri,
            ..EffectiveDate,
            ..SetActive,
            ..ClearBeforeLoad,
            ..GenerateVectors,
            ..Lang
        )
        If $$$ISERR(tSC) Return tSC

        $$$LOGINFO("ICDLoad end")

        Return $$$OK
    } Catch ex {
        Return $$$ERROR($$$GeneralError, ex.DisplayString())
    }
}

Storage Default
{
<Data name="ICDLoadDefaultData">
<Subscript>"ICDLoad"</Subscript>
<Value name="1">
<Value>ClearBeforeLoad</Value>
</Value>
<Value name="2">
<Value>GenerateVectors</Value>
</Value>
<Value name="3">
<Value>Lang</Value>
</Value>
<Value name="4">
<Value>SystemUri</Value>
</Value>
<Value name="5">
<Value>EffectiveDate</Value>
</Value>
<Value name="6">
<Value>SetActive</Value>
</Value>
</Data>
<DefaultData>ICDLoadDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
