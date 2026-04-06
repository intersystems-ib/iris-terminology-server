Class Terminology.Production.Msg.FhirSubsumesResponse Extends Ens.Response
{

Property Outcome As %String;

Property CodeA As %String;

Property CodeB As %String;

Property System As %String;

Property Version As %String;

Storage Default
{
<Data name="FhirSubsumesResponseDefaultData">
<Subscript>"FhirSubsumesResponse"</Subscript>
<Value name="1">
<Value>Outcome</Value>
</Value>
<Value name="2">
<Value>CodeA</Value>
</Value>
<Value name="3">
<Value>CodeB</Value>
</Value>
<Value name="4">
<Value>System</Value>
</Value>
<Value name="5">
<Value>Version</Value>
</Value>
</Data>
<DefaultData>FhirSubsumesResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
