Class Terminology.Loinc.DTO.CodeResult Extends Terminology.Loinc.DTO.Base
{

Property LoincNum As %String;

Property Component As %String;

Property PropertyCode As %String;

Property TimeAspct As %String;

Property SystemCode As %String;

Property ScaleTyp As %String;

Property MethodTyp As %String;

Property ClassCode As %String;

Property Status As %String;

Property ConsumerName As %String;

Property ShortName As %String;

Property LongCommonName As %String;

Property DefinitionDescription As %String;

Property DisplayName As %String;

Storage Default
{
<Data name="CodeResultState">
<Subscript>"CodeResult"</Subscript>
<Value name="1">
<Value>LoincNum</Value>
</Value>
<Value name="2">
<Value>Component</Value>
</Value>
<Value name="3">
<Value>PropertyCode</Value>
</Value>
<Value name="4">
<Value>TimeAspct</Value>
</Value>
<Value name="5">
<Value>SystemCode</Value>
</Value>
<Value name="6">
<Value>ScaleTyp</Value>
</Value>
<Value name="7">
<Value>MethodTyp</Value>
</Value>
<Value name="8">
<Value>ClassCode</Value>
</Value>
<Value name="9">
<Value>Status</Value>
</Value>
<Value name="10">
<Value>ConsumerName</Value>
</Value>
<Value name="11">
<Value>ShortName</Value>
</Value>
<Value name="12">
<Value>LongCommonName</Value>
</Value>
<Value name="13">
<Value>DefinitionDescription</Value>
</Value>
<Value name="14">
<Value>DisplayName</Value>
</Value>
</Data>
<State>CodeResultState</State>
<Type>%Storage.Serial</Type>
}

}
