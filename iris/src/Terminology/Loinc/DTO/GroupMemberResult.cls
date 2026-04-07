Class Terminology.Loinc.DTO.GroupMemberResult Extends Terminology.Loinc.DTO.Base
{

Property Count As %Integer;

Property Items As list Of Terminology.Loinc.DTO.GroupMemberItem;

Storage Default
{
<Data name="GroupMemberResultState">
<Subscript>"GroupMemberResult"</Subscript>
<Value name="1">
<Value>Count</Value>
</Value>
<Value name="2">
<Value>Items</Value>
</Value>
</Data>
<State>GroupMemberResultState</State>
<Type>%Storage.Serial</Type>
}

}
