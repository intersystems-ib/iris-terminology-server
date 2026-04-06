Class Terminology.Production.BS.LoincFileService Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.File.InboundAdapter";

Property TargetConfigName As %String(MAXLEN = 200) [ InitialExpression = "LoincLoadProcessing" ];

Property ReleaseId As %String(MAXLEN = 100);

Property SystemUri As %String(MAXLEN = 200) [ InitialExpression = "http://loinc.org" ];

Property EffectiveDate As %Date;

Property SetActive As %Boolean [ InitialExpression = 1 ];

Parameter SETTINGS = "TargetConfigName,ReleaseId,SystemUri,EffectiveDate,SetActive";

Method OnProcessInput(pInput As %Stream.Object, Output pOutput As %RegisteredObject) As %Status
{
    Set tSC = $$$OK
    Set pOutput = ""

    Try {

        Set fileName = $Get(pInput.Attributes("Filename"))
        If fileName = "" {
            return $$$ERROR($$$GeneralError,"No se ha recibido el nombre del fichero")
        }
        Set req = ##class(Terminology.Production.Msg.LoincLoadRequest).%New()
        Set req.FileName = fileName
        Set req.Directory = ..Adapter.FilePath
        Set req.ReleaseId = ..ReleaseId
        Set req.SystemUri = ..SystemUri
        Set req.EffectiveDate = ..EffectiveDate
        Set req.SetActive = ..SetActive

        Do ##class(Ens.Util.Log).LogInfo(
            "Terminology.Production.BS.LoincFileService",
            "OnProcessInput",
            "Fichero detectado para carga LOINC: "_fileName
        )

        Set rsp = ""
        Set sc = ..SendRequestSync(..TargetConfigName, req, .rsp)
        If $$$ISERR(sc) {
            return sc
        }

        Set pOutput = rsp
        Return $$$OK

    } Catch ex {
        Return $$$ERROR($$$GeneralError, ex.DisplayString())
    }
}

}
