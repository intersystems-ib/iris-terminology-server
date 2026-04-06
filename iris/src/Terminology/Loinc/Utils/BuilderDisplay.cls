Class Terminology.Loinc.Utils.BuilderDisplay Extends %RegisteredObject
{

ClassMethod Build(pDir As %String, pReleaseId As %String, pLang As %String = "es", pLinguisticVariantPrefix As %String = "") As %Status
{
    Set tSC = $$$OK

    Try {
        Do ..LogInfo("Inicio BuildDisplay | ReleaseId="_pReleaseId_" | Lang="_pLang_" | Prefix="_pLinguisticVariantPrefix)

        Do ..LogInfo("Paso 1: limpieza de Display")
        Set tSC = ..DeleteExisting(pReleaseId, pLang)
        If $$$ISERR(tSC) {
            Do ..LogInfo("Error en Paso 1: "_$System.Status.GetOneErrorText(tSC))
            Return tSC
        }

        Do ..LogInfo("Paso 2: inserción de displays base")
        Set tSC = ..InsertBaseDisplays(pReleaseId, pLang)
        If $$$ISERR(tSC) {
            Do ..LogInfo("Error en Paso 2: "_$System.Status.GetOneErrorText(tSC))
            Return tSC
        }

        Do ..LogInfo("Paso 3: inserción de ConsumerName")
        Set tSC = ..InsertConsumerDisplays(pReleaseId, pLang)
        If $$$ISERR(tSC) {
            Do ..LogInfo("Error en Paso 3: "_$System.Status.GetOneErrorText(tSC))
            Return tSC
        }

        Do ..LogInfo("Paso 4: resolución de fichero de variante lingüística")
        Set variantFile = ..ResolveLinguisticVariantFile(pDir, pLinguisticVariantPrefix)
        If variantFile'="" {
            Do ..LogInfo("Fichero de variante encontrado: "_variantFile)
            Set tSC = ..InsertVariantDisplays(variantFile, pReleaseId, pLang)
            If $$$ISERR(tSC) {
                Do ..LogInfo("Error en Paso 4: "_$System.Status.GetOneErrorText(tSC))
                Return tSC
            }
        } Else {
            Do ..LogInfo("No se encontró fichero de variante para prefijo: "_pLinguisticVariantPrefix)
        }

        Do ..LogInfo("Fin BuildDisplay OK | ReleaseId="_pReleaseId_" | Lang="_pLang)
        Return $$$OK
    } Catch ex {
        Do ..LogInfo("Excepción en BuildDisplay: "_ex.DisplayString())
        Return $$$ERROR($$$GeneralError, ex.DisplayString())
    }
}

ClassMethod DeleteExisting(pReleaseId As %String, pLang As %String) As %Status
{
    Set stmt = ##class(%SQL.Statement).%New()
    Set sql = "DELETE FROM Terminology_Loinc.Display WHERE ReleaseId = ? AND Lang = ?"

    Set tSC = stmt.%Prepare(sql)
    If $$$ISERR(tSC) {
        Return tSC
    }

    Set rset = stmt.%Execute(pReleaseId, pLang)
    Return $$$OK
}

ClassMethod InsertBaseDisplays(pReleaseId As %String, pLang As %String) As %Status
{
    Set tSC = $$$OK

    Set tSC = ..InsertDisplayType(
        pReleaseId,
        pLang,
        "LONGCOMMONNAME",
        "LongCommonName",
        1
    )
    If $$$ISERR(tSC) Return tSC

    Set tSC = ..InsertDisplayType(
        pReleaseId,
        pLang,
        "SHORTNAME",
        "ShortName",
        2
    )
    If $$$ISERR(tSC) Return tSC

    Set tSC = ..InsertDisplayType(
        pReleaseId,
        pLang,
        "DISPLAYNAME",
        "DisplayName",
        3
    )
    If $$$ISERR(tSC) Return tSC

    Return $$$OK
}

ClassMethod InsertConsumerDisplays(pReleaseId As %String, pLang As %String) As %Status
{
    Quit ..InsertDisplayType(
        pReleaseId,
        pLang,
        "CONSUMERNAME",
        "ConsumerName",
        4
    )
}

ClassMethod InsertDisplayType(pReleaseId As %String, pLang As %String, pDisplayType As %String, pSourceField As %String, pRankOrder As %Integer) As %Status
{
    Set stmt = ##class(%SQL.Statement).%New()

    Set sql = ""
    Set sql = sql_"INSERT INTO Terminology_Loinc.Display "
    Set sql = sql_"(ReleaseId, LoincNum, Lang, DisplayType, Display, DisplayNorm, RankOrder) "
    Set sql = sql_"SELECT "
    Set sql = sql_"?, LoincNum, ?, ?, "_pSourceField_", %SQLUPPER("_pSourceField_"), ? "
    Set sql = sql_"FROM Terminology_Loinc.Code "
    Set sql = sql_"WHERE ReleaseId = ? "
    Set sql = sql_"AND "_pSourceField_" IS NOT NULL "
    Set sql = sql_"AND "_pSourceField_" <> ''"

    Do ..LogInfo("InsertDisplayType "_pDisplayType_" SQL preparado")

    Set tSC = stmt.%Prepare(sql)
    If $$$ISERR(tSC) {
        Return tSC
    }

    Set rset = stmt.%Execute(
        pReleaseId,
        pLang,
        pDisplayType,
        pRankOrder,
        pReleaseId
    )

    Return $$$OK
}

ClassMethod ResolveLinguisticVariantFile(pDir As %String, pPrefix As %String) As %String
{
    If pPrefix="" {
        Quit ""
    }

    Set targetName = pPrefix_"LinguisticVariant.csv"
    Set found = ""

    Set tSC = ..FindFileRecursive(pDir, targetName, .found)
    If $$$ISERR(tSC) {
        Quit ""
    }

    Quit found
}

ClassMethod FindFileRecursive(pDir As %String, pTargetName As %String, Output pFound As %String) As %Status
{
    Set pFound = ""

    Try {
        Set normDir = ##class(%File).NormalizeDirectory(pDir)
        If normDir = "" {
            Return $$$ERROR($$$GeneralError, "Directory not found: "_pDir)
        }

        Set stmt = ##class(%SQL.Statement).%New()
        Set sql = "SELECT Name "_
                  "FROM %Library.File_FileSet(?, ?, ?, ?, ?)"

        Set tSC = stmt.%Prepare(sql)
        If $$$ISERR(tSC) {
            Return tSC
        }

        Set rset = stmt.%Execute(normDir, "*", "Name", 1, ";")

        While rset.%Next() {
            Set name = rset.%Get("Name")
            If (name = ".") || (name = "..") {
                Continue
            }

            Set fullPath = ##class(%File).NormalizeFilename(name, normDir)

            If ##class(%File).DirectoryExists(fullPath) {
                Set tSC = ..FindFileRecursive(fullPath, pTargetName, .pFound)
                If $$$ISERR(tSC) {
                    Return tSC
                }
                If pFound'="" {
                    Return $$$OK
                }
            } ElseIf ##class(%File).GetFilename(fullPath) = pTargetName {
                Set pFound = fullPath
                Return $$$OK
            }
        }

        Return $$$OK
    } Catch ex {
        Return $$$ERROR($$$GeneralError, ex.DisplayString())
    }
}

ClassMethod InsertVariantDisplays(pFilePath As %String, pReleaseId As %String, pLang As %String) As %Status
{
    Try {
        Set stream = ##class(%Stream.FileCharacter).%New()
        Set tSC = stream.LinkToFile(pFilePath)
        If $$$ISERR(tSC) {
            Return tSC
        }

        Do stream.Rewind()

        Set headerLine = stream.ReadLine()
        If headerLine="" {
            Do ..LogInfo("Fichero de variante vacío: "_pFilePath)
            Return $$$OK
        }

        Set header = ..ParseCsvLine(headerLine)

        Set idxLoinc = ..FindHeaderIndex(header, "LOINC_NUM")
        If idxLoinc<1 {
            Set idxLoinc = ..FindHeaderIndex(header, "LoincNum")
        }

        Set idxText = ..FindHeaderIndex(header, "DisplayName")
        If idxText<1 {
            Set idxText = ..FindHeaderIndex(header, "LONG_COMMON_NAME")
        }
        If idxText<1 {
            Set idxText = ..FindHeaderIndex(header, "LongCommonName")
        }
        If idxText<1 {
            Set idxText = ..FindHeaderIndex(header, "NAME")
        }
        If idxText<1 {
            Set idxText = ..FindHeaderIndex(header, "TRANSLATED_TEXT")
        }

        If (idxLoinc<1)||(idxText<1) {
            Return $$$ERROR($$$GeneralError, "Cabecera no válida en fichero de variante: "_pFilePath)
        }

        Set stmt = ##class(%SQL.Statement).%New()
        Set sql = "INSERT INTO Terminology_Loinc.Display "_
                  "(ReleaseId, LoincNum, Lang, DisplayType, Display, DisplayNorm, RankOrder) "_
                  "SELECT ?, ?, ?, ?, ?, %SQLUPPER(?), ?"

        Set tSC = stmt.%Prepare(sql)
        If $$$ISERR(tSC) {
            Return tSC
        }

        Set count = 0

        While 'stream.AtEnd {
            Set line = stream.ReadLine()
            If line="" {
                Continue
            }

            Set cols = ..ParseCsvLine(line)
            Set loinc = $Get(cols(idxLoinc))
            Set text = $Get(cols(idxText))

            If (loinc="")!(text="") {
                Continue
            }

            Set rset = stmt.%Execute(
                pReleaseId,
                loinc,
                pLang,
                "LINGUISTICVARIANT",
                text,
                text,
                0
            )

            Set count = count + 1
            If '(count#500) {
                Do ..LogInfo("Variant displays insertados: "_count)
            }
        }

        Do ..LogInfo("Variant displays insertados totales: "_count)
        Return $$$OK
    } Catch ex {
        Return $$$ERROR($$$GeneralError, ex.DisplayString())
    }
}

ClassMethod FindHeaderIndex(pHeader As %ListOfDataTypes, pName As %String) As %Integer
{
    Set i = ""
    For {
        Set i = pHeader.Next(i)
        Quit:i=""
        If pHeader.GetAt(i)=pName {
            return i
        }
    }
    Quit 0
}

ClassMethod ParseCsvLine(pLine As %String) As %ListOfDataTypes
{
    Set result = ##class(%ListOfDataTypes).%New()
    Set inQuotes = 0
    Set value = ""
    Set len = $Length(pLine)

    For i=1:1:len {
        Set ch = $Extract(pLine,i)

        If ch="""" {
            If inQuotes,(i<len),($Extract(pLine,i+1)="""") {
                Set value = value_""""
                Set i = i + 1
            } Else {
                Set inQuotes = 'inQuotes
            }
            Continue
        }

        If ch=",",'inQuotes {
            Do result.Insert(value)
            Set value = ""
            Continue
        }

        Set value = value_ch
    }

    Do result.Insert(value)
    Quit result
}

ClassMethod LogInfo(pText As %String) As %Status
{
    Do ##class(Ens.Util.Log).LogInfo(
        "Terminology.Loinc.BuilderDisplay",
        "Build",
        pText
    )
    Return $$$OK
}

}
