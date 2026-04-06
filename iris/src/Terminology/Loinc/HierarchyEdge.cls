Class Terminology.Loinc.HierarchyEdge Extends %Persistent
{

Property ReleaseId As %String(MAXLEN = 100) [ Required ];

/// Tipo de jerarquía: COMPONENTBYSYSTEM o GROUP
Property HierarchyType As %String(MAXLEN = 50) [ Required ];

/// Nodo padre
Property ParentCode As %String(MAXLEN = 100) [ Required ];

/// Nodo hijo
Property ChildCode As %String(MAXLEN = 100) [ Required ];

/// Tipo de nodo padre: LOINC / PART / GROUP
Property ParentNodeType As %String(MAXLEN = 30);

/// Tipo de nodo hijo: LOINC / PART / GROUP
Property ChildNodeType As %String(MAXLEN = 30);

/// PathToRoot o ruta textual si viene en el archivo
Property PathToRoot As %String(MAXLEN = 4000);

Index PK On (ReleaseId, HierarchyType, ParentCode, ChildCode) [ IdKey, Unique ];

Index IXParent On (ReleaseId, HierarchyType, ParentCode, ChildCode);

Index IXChild On (ReleaseId, HierarchyType, ChildCode, ParentCode);

Storage Default
{
<Data name="HierarchyEdgeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ParentNodeType</Value>
</Value>
<Value name="3">
<Value>ChildNodeType</Value>
</Value>
<Value name="4">
<Value>PathToRoot</Value>
</Value>
</Data>
<DataLocation>^TerminologyB303.HierarchyEdgeD</DataLocation>
<DefaultData>HierarchyEdgeDefaultData</DefaultData>
<IdLocation>^TerminologyB303.HierarchyEdgeD</IdLocation>
<IndexLocation>^TerminologyB303.HierarchyEdgeI</IndexLocation>
<StreamLocation>^TerminologyB303.HierarchyEdgeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
