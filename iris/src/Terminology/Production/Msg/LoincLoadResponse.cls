Class Terminology.Production.Msg.LoincLoadResponse Extends Ens.Response
{

Property ReleaseId As %String;

Property FileName As %String;

Property Message As %String;

Storage Default
{
<Data name="LoincLoadResponseDefaultData">
<Subscript>"LoincLoadResponse"</Subscript>
<Value name="1">
<Value>ReleaseId</Value>
</Value>
<Value name="2">
<Value>FileName</Value>
</Value>
<Value name="3">
<Value>Message</Value>
</Value>
</Data>
<DefaultData>LoincLoadResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
