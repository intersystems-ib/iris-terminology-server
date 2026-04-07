Class Terminology.Loinc.DTO.SearchResult Extends Terminology.Loinc.DTO.Base
{

Property Count As %Integer;

Property Items As list Of Terminology.Loinc.DTO.SearchItem;

Storage Default
{
<Data name="SearchResultState">
<Subscript>"SearchResult"</Subscript>
<Value name="1">
<Value>Count</Value>
</Value>
<Value name="2">
<Value>Items</Value>
</Value>
</Data>
<State>SearchResultState</State>
<Type>%Storage.Serial</Type>
}

}
