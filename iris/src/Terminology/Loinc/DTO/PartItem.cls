Class Terminology.Loinc.DTO.PartItem Extends Terminology.Loinc.DTO.Base
{

Property LoincNum As %String;

Property PartNumber As %String;

Property PartTypeName As %String;

Property LinkTypeName As %String;

Property PropertySlot As %String;

Property PartName As %String;

Property PartDisplayName As %String;

Property Status As %String;

Storage Default
{
<Data name="PartItemState">
<Subscript>"PartItem"</Subscript>
<Value name="1">
<Value>LoincNum</Value>
</Value>
<Value name="2">
<Value>PartNumber</Value>
</Value>
<Value name="3">
<Value>PartTypeName</Value>
</Value>
<Value name="4">
<Value>LinkTypeName</Value>
</Value>
<Value name="5">
<Value>PropertySlot</Value>
</Value>
<Value name="6">
<Value>PartName</Value>
</Value>
<Value name="7">
<Value>PartDisplayName</Value>
</Value>
<Value name="8">
<Value>Status</Value>
</Value>
</Data>
<State>PartItemState</State>
<Type>%Storage.Serial</Type>
}

}
