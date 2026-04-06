Class Terminology.Loinc.Code Extends %Persistent
{

Property ReleaseId As %String(MAXLEN = 100) [ Required ];

Property LoincNum As %String(MAXLEN = 20) [ Required ];

Property Component As %String(MAXLEN = 500);

Property PropertyCode As %String(MAXLEN = 100);

Property TimeAspct As %String(MAXLEN = 100);

Property SystemCode As %String(MAXLEN = 500);

Property ScaleTyp As %String(MAXLEN = 100);

Property MethodTyp As %String(MAXLEN = 500);

Property ClassCode As %String(MAXLEN = 100);

Property VersionLastChanged As %String(MAXLEN = 30);

Property ChangeType As %String(MAXLEN = 50);

Property DefinitionDescription As %String(MAXLEN = "");

Property Status As %String(MAXLEN = 50);

Property ConsumerName As %String(MAXLEN = 1000);

Property ClassType As %Integer;

Property Formula As %String(MAXLEN = 4000);

Property ExampleAnswers As %String(MAXLEN = "");

Property SurveyQuestText As %String(MAXLEN = 4000);

Property SurveyQuestSrc As %String(MAXLEN = 500);

Property UnitsRequired As %String(MAXLEN = 10);

Property RelatedNames2 As %String(MAXLEN = 4000);

Property ShortName As %String(MAXLEN = 1000);

Property OrderObs As %String(MAXLEN = 50);

Property Hl7FieldSubfieldId As %String(MAXLEN = 200);

Property ExternalCopyrightNotice As %String(MAXLEN = 4000);

Property ExampleUnits As %String(MAXLEN = 1000);

Property LongCommonName As %String(MAXLEN = 4000);

Property ExampleUCUMUnits As %String(MAXLEN = 1000);

Property StatusReason As %String(MAXLEN = 1000);

Property StatusText As %String(MAXLEN = 4000);

Property ChangeReasonPublic As %String(MAXLEN = 4000);

Property CommonTestRank As %Integer;

Property CommonOrderRank As %Integer;

Property Hl7AttachmentStructure As %String(MAXLEN = 500);

Property ExternalCopyrightLink As %String(MAXLEN = 1000);

Property PanelType As %String(MAXLEN = 50);

Property AskAtOrderEntry As %String(MAXLEN = 10);

Property AssociatedObservations As %String(MAXLEN = 4000);

Property VersionFirstReleased As %String(MAXLEN = 30);

Property ValidHL7AttachmentRequest As %String(MAXLEN = 10);

Property DisplayName As %String(MAXLEN = 1000);

Index PK On (ReleaseId, LoincNum) [ Unique ];

Index IXStatus On (ReleaseId, Status, LoincNum);

Index IXClassCode On (ReleaseId, ClassCode, LoincNum);

Storage Default
{
<Data name="CodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReleaseId</Value>
</Value>
<Value name="3">
<Value>LoincNum</Value>
</Value>
<Value name="4">
<Value>Component</Value>
</Value>
<Value name="5">
<Value>PropertyCode</Value>
</Value>
<Value name="6">
<Value>TimeAspct</Value>
</Value>
<Value name="7">
<Value>SystemCode</Value>
</Value>
<Value name="8">
<Value>ScaleTyp</Value>
</Value>
<Value name="9">
<Value>MethodTyp</Value>
</Value>
<Value name="10">
<Value>ClassCode</Value>
</Value>
<Value name="11">
<Value>VersionLastChanged</Value>
</Value>
<Value name="12">
<Value>ChangeType</Value>
</Value>
<Value name="13">
<Value>DefinitionDescription</Value>
</Value>
<Value name="14">
<Value>Status</Value>
</Value>
<Value name="15">
<Value>ConsumerName</Value>
</Value>
<Value name="16">
<Value>ClassType</Value>
</Value>
<Value name="17">
<Value>Formula</Value>
</Value>
<Value name="18">
<Value>ExampleAnswers</Value>
</Value>
<Value name="19">
<Value>SurveyQuestText</Value>
</Value>
<Value name="20">
<Value>SurveyQuestSrc</Value>
</Value>
<Value name="21">
<Value>UnitsRequired</Value>
</Value>
<Value name="22">
<Value>RelatedNames2</Value>
</Value>
<Value name="23">
<Value>ShortName</Value>
</Value>
<Value name="24">
<Value>OrderObs</Value>
</Value>
<Value name="25">
<Value>Hl7FieldSubfieldId</Value>
</Value>
<Value name="26">
<Value>ExternalCopyrightNotice</Value>
</Value>
<Value name="27">
<Value>ExampleUnits</Value>
</Value>
<Value name="28">
<Value>LongCommonName</Value>
</Value>
<Value name="29">
<Value>ExampleUCUMUnits</Value>
</Value>
<Value name="30">
<Value>StatusReason</Value>
</Value>
<Value name="31">
<Value>StatusText</Value>
</Value>
<Value name="32">
<Value>ChangeReasonPublic</Value>
</Value>
<Value name="33">
<Value>CommonTestRank</Value>
</Value>
<Value name="34">
<Value>CommonOrderRank</Value>
</Value>
<Value name="35">
<Value>Hl7AttachmentStructure</Value>
</Value>
<Value name="36">
<Value>ExternalCopyrightLink</Value>
</Value>
<Value name="37">
<Value>PanelType</Value>
</Value>
<Value name="38">
<Value>AskAtOrderEntry</Value>
</Value>
<Value name="39">
<Value>AssociatedObservations</Value>
</Value>
<Value name="40">
<Value>VersionFirstReleased</Value>
</Value>
<Value name="41">
<Value>ValidHL7AttachmentRequest</Value>
</Value>
<Value name="42">
<Value>DisplayName</Value>
</Value>
</Data>
<DataLocation>^Terminology.Loinc.CodeD</DataLocation>
<DefaultData>CodeDefaultData</DefaultData>
<IdLocation>^Terminology.Loinc.CodeD</IdLocation>
<IndexLocation>^Terminology.Loinc.CodeI</IndexLocation>
<StreamLocation>^Terminology.Loinc.CodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
