/// Neutral value set list/search result returned to API layers.
Class Terminology.Core.DTO.ValueSetListResult Extends Terminology.Core.DTO.Base
{

Property Items As list Of Terminology.Core.DTO.ValueSetInfo(%JSONFIELDNAME = "items");

Property Count As %Integer(%JSONFIELDNAME = "count");

Storage Default
{
<Data name="ValueSetListResultState">
<Subscript>"ValueSetListResult"</Subscript>
<Value name="1">
<Value>Items</Value>
</Value>
<Value name="2">
<Value>Count</Value>
</Value>
</Data>
<State>ValueSetListResultState</State>
<Type>%Storage.Serial</Type>
}

}
