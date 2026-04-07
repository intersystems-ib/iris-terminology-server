Class Terminology.Loinc.DTO.ClosureItem Extends Terminology.Loinc.DTO.Base
{

Property AncestorCode As %String;

Property DescendantCode As %String;

Property Depth As %Integer;

Storage Default
{
<Data name="ClosureItemState">
<Subscript>"ClosureItem"</Subscript>
<Value name="1">
<Value>AncestorCode</Value>
</Value>
<Value name="2">
<Value>DescendantCode</Value>
</Value>
<Value name="3">
<Value>Depth</Value>
</Value>
</Data>
<State>ClosureItemState</State>
<Type>%Storage.Serial</Type>
}

}
