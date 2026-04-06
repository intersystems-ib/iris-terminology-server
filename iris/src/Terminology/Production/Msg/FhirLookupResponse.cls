Class Terminology.Production.Msg.FhirLookupResponse Extends Ens.Response
{

Property Name As %String;

Property System As %String;

Property Version As %String;

Property Code As %String;

Property Display As %String;

Property Active As %Boolean;

Property DefinitionStatusId As %String;

Property ModuleId As %String;

Property EffectiveTime As %String;

Property Designations As list Of Terminology.Production.Msg.FhirDesignation;

Storage Default
{
<Data name="FhirLookupResponseDefaultData">
<Subscript>"FhirLookupResponse"</Subscript>
<Value name="1">
<Value>Name</Value>
</Value>
<Value name="2">
<Value>System</Value>
</Value>
<Value name="3">
<Value>Version</Value>
</Value>
<Value name="4">
<Value>Code</Value>
</Value>
<Value name="5">
<Value>Display</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>DefinitionStatusId</Value>
</Value>
<Value name="8">
<Value>ModuleId</Value>
</Value>
<Value name="9">
<Value>EffectiveTime</Value>
</Value>
<Value name="10">
<Value>Designations</Value>
</Value>
</Data>
<DefaultData>FhirLookupResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
