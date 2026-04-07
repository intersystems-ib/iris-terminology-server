Class Terminology.Production.Msg.LoincGetCodeResponse Extends Ens.Response
{

Property Payload As Terminology.Loinc.DTO.CodeResult;

Storage Default
{
<Data name="LoincGetCodeResponseDefaultData">
<Subscript>"LoincGetCodeResponse"</Subscript>
<Value name="1">
<Value>Payload</Value>
</Value>
</Data>
<DefaultData>LoincGetCodeResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
