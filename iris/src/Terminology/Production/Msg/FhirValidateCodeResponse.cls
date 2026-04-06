Class Terminology.Production.Msg.FhirValidateCodeResponse Extends Ens.Response
{

Property Result As %Boolean;

Property Code As %String;

Property System As %String;

Property Version As %String;

Property Display As %String;

Property Message As %String;

Storage Default
{
<Data name="FhirValidateCodeResponseDefaultData">
<Subscript>"FhirValidateCodeResponse"</Subscript>
<Value name="1">
<Value>Result</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>System</Value>
</Value>
<Value name="4">
<Value>Version</Value>
</Value>
<Value name="5">
<Value>Display</Value>
</Value>
<Value name="6">
<Value>Message</Value>
</Value>
</Data>
<DefaultData>FhirValidateCodeResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
