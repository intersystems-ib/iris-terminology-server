Class Terminology.Loinc.DTO.PartResult Extends Terminology.Loinc.DTO.Base
{

Property Count As %Integer;

Property Items As list Of Terminology.Loinc.DTO.PartItem;

Storage Default
{
<Data name="PartResultState">
<Subscript>"PartResult"</Subscript>
<Value name="1">
<Value>Count</Value>
</Value>
<Value name="2">
<Value>Items</Value>
</Value>
</Data>
<State>PartResultState</State>
<Type>%Storage.Serial</Type>
}

}
