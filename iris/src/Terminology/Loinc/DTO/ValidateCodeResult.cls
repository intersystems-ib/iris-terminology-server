Class Terminology.Loinc.DTO.ValidateCodeResult Extends Terminology.Loinc.DTO.Base
{

Property Exists As %Boolean;

Property Active As %Boolean;

Property Status As %String;

Storage Default
{
<Data name="ValidateCodeResultState">
<Subscript>"ValidateCodeResult"</Subscript>
<Value name="1">
<Value>Exists</Value>
</Value>
<Value name="2">
<Value>Active</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
</Data>
<State>ValidateCodeResultState</State>
<Type>%Storage.Serial</Type>
}

}
