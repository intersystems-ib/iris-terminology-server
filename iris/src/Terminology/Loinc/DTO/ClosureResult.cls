Class Terminology.Loinc.DTO.ClosureResult Extends Terminology.Loinc.DTO.Base
{

Property Count As %Integer;

Property Items As list Of Terminology.Loinc.DTO.ClosureItem;

Storage Default
{
<Data name="ClosureResultState">
<Subscript>"ClosureResult"</Subscript>
<Value name="1">
<Value>Count</Value>
</Value>
<Value name="2">
<Value>Items</Value>
</Value>
</Data>
<State>ClosureResultState</State>
<Type>%Storage.Serial</Type>
}

}
