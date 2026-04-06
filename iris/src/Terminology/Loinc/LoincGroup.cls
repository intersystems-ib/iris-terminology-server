Class Terminology.Loinc.LoincGroup Extends %Persistent
{

Property ReleaseId As %String(MAXLEN = 100) [ Required ];

Property GroupId As %String(MAXLEN = 100) [ Required ];

Property GroupName As %String(MAXLEN = 1000);

Property GroupType As %String(MAXLEN = 100);

Property Version As %String(MAXLEN = 50);

Index PK On (ReleaseId, GroupId) [ Unique ];

Storage Default
{
<Data name="LoincGroupDefaultData">
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
<Value>GroupName</Value>
</Value>
<Value name="5">
<Value>GroupType</Value>
</Value>
<Value name="6">
<Value>Version</Value>
</Value>
</Data>
<DataLocation>^Terminology.Loinc.LoincGroupD</DataLocation>
<DefaultData>LoincGroupDefaultData</DefaultData>
<IdLocation>^Terminology.Loinc.LoincGroupD</IdLocation>
<IndexLocation>^Terminology.Loinc.LoincGroupI</IndexLocation>
<StreamLocation>^Terminology.Loinc.LoincGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
