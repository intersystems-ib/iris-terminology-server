Class Terminology.Loinc.DTO.DisplayResult Extends Terminology.Loinc.DTO.Base
{

Property Count As %Integer;

Property Items As list Of Terminology.Loinc.DTO.DisplayItem;

Storage Default
{
<Data name="DisplayResultState">
<Subscript>"DisplayResult"</Subscript>
<Value name="1">
<Value>Count</Value>
</Value>
<Value name="2">
<Value>Items</Value>
</Value>
</Data>
<State>DisplayResultState</State>
<Type>%Storage.Serial</Type>
}

}
