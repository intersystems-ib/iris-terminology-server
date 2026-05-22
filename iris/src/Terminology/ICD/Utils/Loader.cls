Class Terminology.ICD.Utils.Loader Extends %RegisteredObject
{

ClassMethod LoadSnapshot(pFilePath As %String, pReleaseId As %String, pVersion As %Integer, pCodeType As %String, pSystemUri As %String = "", pEffectiveDate As %Date = "", pSetActive As %Boolean = 1, pClearRelease As %Boolean = 0, pGenerateVectors As %Boolean = 0, pLang As %String = "es") As %Status
{
    Quit ..LoadSnapshotPy(
        pFilePath,
        pReleaseId,
        pVersion,
        pCodeType,
        pSystemUri,
        pEffectiveDate,
        pSetActive,
        pClearRelease,
        pGenerateVectors,
        pLang
    )
}

ClassMethod LoadSnapshotPy(pFilePath As %String, pReleaseId As %String, pVersion As %Integer, pCodeType As %String, pSystemUri As %String = "", pEffectiveDate As %String = "", pSetActive As %Boolean = 1, pClearRelease As %Boolean = 0, pGenerateVectors As %Boolean = 0, pLang As %String = "es") As %Status [ Language = python ]
{
    import json
    import iris

    def log_info(msg):
        try:
            iris.cls("Ens.Util.Log").LogInfo(
                "Terminology.ICD.Loader",
                "LoadSnapshotPy",
                str(msg)
            )
        except Exception:
            pass

    def execute_non_query(sql, *params, context=""):
        params_json = json.dumps(list(params), ensure_ascii=False)
        sc = iris.cls("Terminology.Core.SqlUtils").ExecuteNonQuery(sql, params_json)
        if not iris.system.Status.IsOK(sc):
            try:
                iris.cls("Terminology.Core.SqlUtils").LogStatus(
                    "ExecuteNonQuery [" + context + "]",
                    sc
                )
            except Exception:
                pass
            raise Exception("ExecuteNonQuery returned error in " + context)

    def prepare(sql):
        return iris.sql.prepare(sql)

    def execute_select_df(sql, *params):
        stmt = prepare(sql)
        rs = stmt.execute(*params)
        return rs.dataframe()

    def exists_sql(sql, *params):
        df = execute_select_df(sql, *params)
        return df is not None and not df.empty

    def get_system_uri(version, explicit_system_uri):
        if explicit_system_uri is not None and str(explicit_system_uri).strip() != "":
            return str(explicit_system_uri).strip()

        if int(version or 0) > 0:
            return "http://id.who.int/icd/release/" + str(version)

        return "http://id.who.int/icd/release"

    def get_code_system_name(version):
        if int(version or 0) > 0:
            return "ICD" + str(version)
        return "ICD"

    def ensure_code_system(system_uri, version, lang):
        default_name = get_code_system_name(version)
        default_lang = str(lang or "es")
        default_dialect = "es-ES" if default_lang.lower() == "es" else ""
        default_notes = "ICD-" + str(version) + " code system"
        default_type = "ICD"

        if exists_sql(
            "SELECT SystemUri FROM Terminology_Core.CodeSystem WHERE SystemUri = ?",
            system_uri
        ):
            execute_non_query(
                "UPDATE Terminology_Core.CodeSystem "
                "SET Name = ?, DefaultLang = ?, DefaultDialect = ?, Notes = ?, Type = ? "
                "WHERE SystemUri = ?",
                default_name,
                default_lang,
                default_dialect,
                default_notes,
                default_type,
                system_uri,
                context="update_codesystem"
            )
        else:
            execute_non_query(
                "INSERT INTO Terminology_Core.CodeSystem "
                "(SystemUri, Name, DefaultLang, DefaultDialect, Notes, Type) "
                "SELECT ?, ?, ?, ?, ?, ?",
                system_uri,
                default_name,
                default_lang,
                default_dialect,
                default_notes,
                default_type,
                context="insert_codesystem"
            )

    def ensure_release(release_id, system_uri, effective_date, set_active):
        if exists_sql(
            "SELECT ReleaseId FROM Terminology_Core.VersionRelease WHERE ReleaseId = ?",
            release_id
        ):
            if effective_date:
                execute_non_query(
                    "UPDATE Terminology_Core.VersionRelease "
                    "SET SystemUri = ?, VersionUri = ?, EffectiveDate = DATE(?), IsActive = 0 "
                    "WHERE ReleaseId = ?",
                    system_uri,
                    "",
                    effective_date,
                    release_id,
                    context="update_release"
                )
            else:
                execute_non_query(
                    "UPDATE Terminology_Core.VersionRelease "
                    "SET SystemUri = ?, VersionUri = ?, EffectiveDate = NULL, IsActive = 0 "
                    "WHERE ReleaseId = ?",
                    system_uri,
                    "",
                    release_id,
                    context="update_release_no_date"
                )
        else:
            if effective_date:
                execute_non_query(
                    "INSERT INTO Terminology_Core.VersionRelease "
                    "(ReleaseId, SystemUri, VersionUri, EffectiveDate, IsActive) "
                    "SELECT ?, ?, ?, DATE(?), 0",
                    release_id,
                    system_uri,
                    "",
                    effective_date,
                    context="insert_release"
                )
            else:
                execute_non_query(
                    "INSERT INTO Terminology_Core.VersionRelease "
                    "(ReleaseId, SystemUri, VersionUri, EffectiveDate, IsActive) "
                    "SELECT ?, ?, ?, NULL, 0",
                    release_id,
                    system_uri,
                    "",
                    context="insert_release_no_date"
                )

        if bool(int(set_active)):
            execute_non_query(
                "UPDATE Terminology_Core.VersionRelease SET IsActive = 0 WHERE SystemUri = ?",
                system_uri,
                context="reset_active_all"
            )
            execute_non_query(
                "UPDATE Terminology_Core.VersionRelease SET IsActive = 1 WHERE ReleaseId = ?",
                release_id,
                context="set_active"
            )

    def clear_vectors(system_uri, release_id, lang):
        if lang:
            execute_non_query(
                "DELETE %NOJOURN %NOLOCK FROM Terminology_Vector.TermEmbedding "
                "WHERE SystemUri = ? AND ReleaseId = ? AND (Lang = ? OR Lang = ?)",
                system_uri,
                release_id,
                lang,
                "",
                context="delete_vectors_lang"
            )
        else:
            execute_non_query(
                "DELETE %NOJOURN %NOLOCK FROM Terminology_Vector.TermEmbedding "
                "WHERE SystemUri = ? AND ReleaseId = ?",
                system_uri,
                release_id,
                context="delete_vectors"
            )

    def clear_release(system_uri, release_id, version, code_type, lang):
        log_info(
            "Clear release start | ReleaseId="
            + str(release_id)
            + " | Version="
            + str(version)
            + " | CodeType="
            + str(code_type)
            + " | Lang="
            + str(lang)
        )

        clear_vectors(system_uri, release_id, lang)

        execute_non_query(
            "DELETE %NOJOURN %NOLOCK FROM Terminology_ICD.HierarchyEdge "
            "WHERE ReleaseId = ? AND Version = ? AND CodeType = ?",
            release_id,
            version,
            code_type,
            context="delete_hierarchy"
        )
        execute_non_query(
            "DELETE %NOJOURN %NOLOCK FROM Terminology_ICD.Code "
            "WHERE ReleaseId = ? AND Version = ? AND CodeType = ?",
            release_id,
            version,
            code_type,
            context="delete_code"
        )
        execute_non_query(
            "DELETE %NOJOURN %NOLOCK FROM Terminology_ICD.Family "
            "WHERE ReleaseId = ? AND Version = ? AND CodeType = ?",
            release_id,
            version,
            code_type,
            context="delete_family"
        )
        execute_non_query(
            "DELETE %NOJOURN %NOLOCK FROM Terminology_ICD.Chapter "
            "WHERE ReleaseId = ? AND Version = ? AND CodeType = ?",
            release_id,
            version,
            code_type,
            context="delete_chapter"
        )
        execute_non_query(
            "DELETE %NOJOURN %NOLOCK FROM Terminology_ICD.LoadStage "
            "WHERE ReleaseId = ? AND Version = ? AND CodeType = ?",
            release_id,
            version,
            code_type,
            context="delete_stage"
        )

        log_info("Clear release end | ReleaseId=" + str(release_id))

    try:
        file_path = str(pFilePath)
        release_id = str(pReleaseId)
        version = int(pVersion)
        code_type = str(pCodeType)
        lang = str(pLang or "es")
        system_uri = get_system_uri(version, pSystemUri)

        log_info(
            "ICD load start | FilePath="
            + file_path
            + " | ReleaseId="
            + release_id
            + " | Version="
            + str(version)
            + " | CodeType="
            + code_type
            + " | SystemUri="
            + system_uri
        )

        ensure_code_system(system_uri, version, lang)
        ensure_release(release_id, system_uri, pEffectiveDate, pSetActive)

        if bool(int(pClearRelease)):
            clear_release(system_uri, release_id, version, code_type, lang)

        sc = iris.cls("Terminology.ICD.Utils.BuilderCode").Build(
            file_path,
            release_id,
            version,
            code_type,
            lang
        )
        if not iris.system.Status.IsOK(sc):
            return sc

        sc = iris.cls("Terminology.ICD.Utils.BuilderHierarchy").Build(
            release_id,
            version,
            code_type
        )
        if not iris.system.Status.IsOK(sc):
            return sc

        if bool(int(pGenerateVectors)):
            sc = iris.cls("Terminology.Vector.Utils").RebuildByRelease(
                release_id,
                "ICD",
                lang,
                "",
                version,
                code_type
            )
            if not iris.system.Status.IsOK(sc):
                return sc

        log_info("ICD load completed | ReleaseId=" + release_id)
        return iris.system.Status.OK()

    except Exception as err:
        log_info("Error: " + str(err))
        return iris.system.Status.Error(5001, str(err))
}

}
