/// Neutral code system list/search result returned to API layers.
Class Terminology.Core.DTO.CodeSystemListResult Extends Terminology.Core.DTO.Base
{

Property Items As list Of Terminology.Core.DTO.CodeSystemInfo(%JSONFIELDNAME = "items");

Property Count As %Integer(%JSONFIELDNAME = "count");

Storage Default
{
<Data name="CodeSystemListResultState">
<Subscript>"CodeSystemListResult"</Subscript>
<Value name="1">
<Value>Items</Value>
</Value>
<Value name="2">
<Value>Count</Value>
</Value>
</Data>
<State>CodeSystemListResultState</State>
<Type>%Storage.Serial</Type>
}

}
