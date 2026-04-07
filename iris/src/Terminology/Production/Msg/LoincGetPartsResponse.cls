Class Terminology.Production.Msg.LoincGetPartsResponse Extends Ens.Response
{

Property Payload As Terminology.Loinc.DTO.PartResult;

Storage Default
{
<Data name="LoincGetPartsResponseDefaultData">
<Subscript>"LoincGetPartsResponse"</Subscript>
<Value name="1">
<Value>Payload</Value>
</Value>
</Data>
<DefaultData>LoincGetPartsResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
