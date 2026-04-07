Class Terminology.Production.Msg.LoincSearchResponse Extends Ens.Response
{

Property Payload As Terminology.Loinc.DTO.SearchResult;

Storage Default
{
<Data name="LoincSearchResponseDefaultData">
<Subscript>"LoincSearchResponse"</Subscript>
<Value name="1">
<Value>Payload</Value>
</Value>
</Data>
<DefaultData>LoincSearchResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
