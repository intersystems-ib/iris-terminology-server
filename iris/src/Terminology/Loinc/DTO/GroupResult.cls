Class Terminology.Loinc.DTO.GroupResult Extends Terminology.Loinc.DTO.Base
{

Property Count As %Integer;

Property Items As list Of Terminology.Loinc.DTO.GroupItem;

Storage Default
{
<Data name="GroupResultState">
<Subscript>"GroupResult"</Subscript>
<Value name="1">
<Value>Count</Value>
</Value>
<Value name="2">
<Value>Items</Value>
</Value>
</Data>
<State>GroupResultState</State>
<Type>%Storage.Serial</Type>
}

}
