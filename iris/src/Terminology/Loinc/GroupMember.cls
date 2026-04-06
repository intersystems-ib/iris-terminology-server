Class Terminology.Loinc.GroupMember Extends %Persistent
{

Property ReleaseId As %String(MAXLEN = 100) [ Required ];

Property GroupId As %String(MAXLEN = 100) [ Required ];

Property LoincNum As %String(MAXLEN = 20) [ Required ];

Index PK On (ReleaseId, GroupId, LoincNum) [ Unique ];

Index IXGroup On (ReleaseId, GroupId, LoincNum);

Index IXLoincNum On (ReleaseId, LoincNum, GroupId);

Storage Default
{
<Data name="GroupMemberDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReleaseId</Value>
</Value>
<Value name="3">
<Value>GroupId</Value>
</Value>
<Value name="4">
<Value>LoincNum</Value>
</Value>
</Data>
<DataLocation>^Terminology.Loinc.GroupMemberD</DataLocation>
<DefaultData>GroupMemberDefaultData</DefaultData>
<IdLocation>^Terminology.Loinc.GroupMemberD</IdLocation>
<IndexLocation>^Terminology.Loinc.GroupMemberI</IndexLocation>
<StreamLocation>^Terminology.Loinc.GroupMemberS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
