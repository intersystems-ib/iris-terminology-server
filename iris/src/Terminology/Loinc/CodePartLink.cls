Class Terminology.Loinc.CodePartLink Extends %Persistent
{

Property ReleaseId As %String(MAXLEN = 100) [ Required ];

Property LoincNum As %String(MAXLEN = 20) [ Required ];

Property PartNumber As %String(MAXLEN = 50) [ Required ];

Property PartTypeName As %String(MAXLEN = 100);

Property LinkTypeName As %String(MAXLEN = 100);

Property PropertySlot As %String(MAXLEN = 100);

Index PK On (ReleaseId, LoincNum, PartNumber, LinkTypeName) [ Unique ];

Index IXLoincNum On (ReleaseId, LoincNum, PartNumber);

Index IXPartNumber On (ReleaseId, PartNumber, LoincNum);

Storage Default
{
<Data name="CodePartLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReleaseId</Value>
</Value>
<Value name="3">
<Value>LoincNum</Value>
</Value>
<Value name="4">
<Value>PartNumber</Value>
</Value>
<Value name="5">
<Value>PartTypeName</Value>
</Value>
<Value name="6">
<Value>LinkTypeName</Value>
</Value>
<Value name="7">
<Value>PropertySlot</Value>
</Value>
</Data>
<DataLocation>^Terminology.LB303.CodePartLinkD</DataLocation>
<DefaultData>CodePartLinkDefaultData</DefaultData>
<IdLocation>^Terminology.LB303.CodePartLinkD</IdLocation>
<IndexLocation>^Terminology.LB303.CodePartLinkI</IndexLocation>
<StreamLocation>^Terminology.LB303.CodePartLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
