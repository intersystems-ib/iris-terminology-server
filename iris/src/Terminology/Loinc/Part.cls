Class Terminology.Loinc.Part Extends %Persistent
{

Property ReleaseId As %String(MAXLEN = 100) [ Required ];

Property PartNumber As %String(MAXLEN = 50) [ Required ];

Property PartTypeName As %String(MAXLEN = 100);

Property PartName As %String(MAXLEN = 1000);

Property PartDisplayName As %String(MAXLEN = 1000);

Property Status As %String(MAXLEN = 50);

Index PK On (ReleaseId, PartNumber) [ Unique ];

Index IXPartType On (ReleaseId, PartTypeName, PartNumber);

Storage Default
{
<Data name="PartDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReleaseId</Value>
</Value>
<Value name="3">
<Value>PartNumber</Value>
</Value>
<Value name="4">
<Value>PartTypeName</Value>
</Value>
<Value name="5">
<Value>PartName</Value>
</Value>
<Value name="6">
<Value>PartDisplayName</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^Terminology.Loinc.PartD</DataLocation>
<DefaultData>PartDefaultData</DefaultData>
<IdLocation>^Terminology.Loinc.PartD</IdLocation>
<IndexLocation>^Terminology.Loinc.PartI</IndexLocation>
<StreamLocation>^Terminology.Loinc.PartS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
