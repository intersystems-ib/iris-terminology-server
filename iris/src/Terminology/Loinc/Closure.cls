Class Terminology.Loinc.Closure Extends %Persistent
{

Property ReleaseId As %String(MAXLEN = 100) [ Required ];

Property HierarchyType As %String(MAXLEN = 50) [ Required ];

Property AncestorCode As %String(MAXLEN = 100) [ Required ];

Property DescendantCode As %String(MAXLEN = 100) [ Required ];

Property Depth As %Integer [ Required ];

Index PK On (ReleaseId, HierarchyType, AncestorCode, DescendantCode) [ IdKey, Unique ];

Index IXAncestor On (ReleaseId, HierarchyType, AncestorCode, Depth, DescendantCode);

Index IXDescendant On (ReleaseId, HierarchyType, DescendantCode, Depth, AncestorCode);

Storage Default
{
<Data name="ClosureDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Depth</Value>
</Value>
</Data>
<DataLocation>^Terminology.Loinc.ClosureD</DataLocation>
<DefaultData>ClosureDefaultData</DefaultData>
<IdLocation>^Terminology.Loinc.ClosureD</IdLocation>
<IndexLocation>^Terminology.Loinc.ClosureI</IndexLocation>
<StreamLocation>^Terminology.Loinc.ClosureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
