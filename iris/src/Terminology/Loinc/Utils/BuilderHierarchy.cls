Class Terminology.Loinc.Utils.BuilderHierarchy Extends %RegisteredObject
{

ClassMethod Build(pDir As %String, pReleaseId As %String, pBuildComponentBySystem As %Boolean = 1, pBuildGroupHierarchy As %Boolean = 1) As %Status
{
    Quit ..BuildPy(pDir, pReleaseId, pBuildComponentBySystem, pBuildGroupHierarchy)
}

ClassMethod BuildPy(pDir As %String, pReleaseId As %String, pBuildComponentBySystem As %Boolean, pBuildGroupHierarchy As %Boolean) As %Status [ Language = python ]
{
import os
import glob
import csv
import json
import iris
from collections import defaultdict

_stmt_cache = {}

def log_info(msg):
    try:
        iris.cls("Ens.Util.Log").LogInfo(
            "Terminology.Loinc.Utils.BuilderHierarchy",
            "BuildPy",
            str(msg)
        )
    except Exception:
        pass

def prepare(sql, context=""):
    cache_key = ("prepare", sql)
    if cache_key in _stmt_cache:
        return _stmt_cache[cache_key]
    try:
        stmt = iris.sql.prepare(sql)
        _stmt_cache[cache_key] = stmt
        return stmt
    except Exception as e:
        log_info(
            "SQL PREPARE ERROR [" + context + "] | SQL: " + str(sql) +
            " | Error: " + str(e)
        )
        raise

def execute_non_query(sql, *params, context=""):
    try:
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
            raise Exception("ExecuteNonQuery devolvió error")
    except Exception as e:
        log_info(
            "NON QUERY ERROR [" + context + "] | SQL: " + str(sql) +
            " | Params: " + str(params) +
            " | Error: " + str(e)
        )
        raise

def get_insert_stmt(context, sql):
    cache_key = ("insert", context)
    if cache_key not in _stmt_cache:
        _stmt_cache[cache_key] = prepare(sql, "insert_" + context)
    return _stmt_cache[cache_key]

def flush_rows(stmt, rows, context="", progress_label="", counter_state=None):
    if not rows:
        return

    inserted_now = 0
    for row in rows:
        try:
            stmt.execute(*row)
            inserted_now += 1
        except Exception as e:
            log_info(
                "ROW INSERT ERROR [" + context + "] | Row: " + str(row) +
                " | Error: " + str(e)
            )
            raise

    if counter_state is not None:
        counter_state["count"] = counter_state.get("count", 0) + inserted_now
        if progress_label:
            log_info(progress_label + ": " + str(counter_state["count"]))

    rows.clear()

def ensure_dir(path):
    if not os.path.isdir(path):
        raise Exception("Directory not found: " + str(path))

def find_first(pattern):
    hits = glob.glob(pattern, recursive=True)
    if hits:
        hits.sort()
        return hits[0]
    return None

def resolve_files(base_dir):
    return {
        "component_hierarchy": (
            find_first(os.path.join(base_dir, "**", "AccessoryFiles", "ComponentHierarchyBySystem", "ComponentHierarchyBySystem.csv"))
            or find_first(os.path.join(base_dir, "**", "AccessoryFiles", "ComponentHierarchyBySystem", "Component.HierarchyBySystem.csv"))
        ),
        "group": find_first(os.path.join(base_dir, "**", "AccessoryFiles", "GroupFile", "Group.csv"))
    }

def read_csv_rows(path):
    with open(path, "r", encoding="utf-8-sig", newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            yield {k.strip(): (v if v is not None else "") for k, v in row.items()}

def pick(row, *names):
    for name in names:
        if name in row and row[name] not in (None, ""):
            return row[name]
    return ""

def load_component_edges(file_path):
    rows = []
    seen = set()
    dup_count = 0

    for row in read_csv_rows(file_path):
        parent_code = pick(row, "IMMEDIATE_PARENT")
        child_code = pick(row, "CODE")
        path_to_root = pick(row, "PATH_TO_ROOT")

        if not parent_code or not child_code or parent_code == child_code:
            continue

        key = ("COMPONENTBYSYSTEM", parent_code, child_code)
        if key in seen:
            dup_count += 1
            continue

        seen.add(key)

        rows.append((
            "COMPONENTBYSYSTEM",
            parent_code,
            child_code,
            "LOINC",
            "LOINC",
            path_to_root
        ))

    log_info("Component hierarchy duplicate edges skipped: " + str(dup_count))
    return rows

def load_group_edges(file_path):
    rows = []
    seen = set()

    for row in read_csv_rows(file_path):
        parent_code = pick(row, "ParentGroupId")
        child_code = pick(row, "GroupId")

        if not parent_code or not child_code or parent_code == child_code:
            continue

        key = ("GROUP", parent_code, child_code)
        if key in seen:
            continue

        seen.add(key)

        rows.append((
            "GROUP",
            parent_code,
            child_code,
            "GROUP",
            "GROUP",
            ""
        ))

    return rows

def build_parent_map(edge_rows, hierarchy_type):
    parents_by_child = defaultdict(set)
    all_nodes = set()

    for row in edge_rows:
        htype, parent_code, child_code, _, _, _ = row
        if htype != hierarchy_type:
            continue

        parents_by_child[child_code].add(parent_code)
        all_nodes.add(parent_code)
        all_nodes.add(child_code)

    return parents_by_child, all_nodes

def merge_min_depth(target, source, depth_offset):
    for ancestor_id, depth in source.items():
        new_depth = depth + depth_offset
        old_depth = target.get(ancestor_id)
        if old_depth is None or new_depth < old_depth:
            target[ancestor_id] = new_depth

def compute_ancestors(node_id, parents_by_child, memo, visiting):
    if node_id in memo:
        return memo[node_id]

    if node_id in visiting:
        return {}

    visiting.add(node_id)
    result = {}

    for parent_id in parents_by_child.get(node_id, set()):
        old_depth = result.get(parent_id)
        if old_depth is None or 1 < old_depth:
            result[parent_id] = 1

        parent_ancestors = compute_ancestors(parent_id, parents_by_child, memo, visiting)
        merge_min_depth(result, parent_ancestors, 1)

    visiting.remove(node_id)
    memo[node_id] = result
    return result

ensure_dir(pDir)
files = resolve_files(pDir)

log_info("ComponentHierarchyBySystem file: " + str(files["component_hierarchy"]))
log_info("Group file: " + str(files["group"]))

execute_non_query(
    "DELETE FROM Terminology_Loinc.Closure WHERE ReleaseId = ?",
    pReleaseId,
    context="delete_closure"
)

execute_non_query(
    "DELETE FROM Terminology_Loinc.HierarchyEdge WHERE ReleaseId = ?",
    pReleaseId,
    context="delete_hierarchyedge"
)

edge_insert_sql = """
INSERT INTO Terminology_Loinc.HierarchyEdge
(ReleaseId, HierarchyType, ParentCode, ChildCode, ParentNodeType, ChildNodeType, PathToRoot)
SELECT ?,?,?,?,?,?,?
"""
edge_stmt = get_insert_stmt("edge", edge_insert_sql)
edge_rows_to_insert = []
edge_counter = {"count": 0}
all_edge_rows = []

if bool(pBuildComponentBySystem) and files["component_hierarchy"]:
    component_rows = load_component_edges(files["component_hierarchy"])
    log_info("Component hierarchy edges loaded: " + str(len(component_rows)))
    all_edge_rows.extend(component_rows)

if bool(pBuildGroupHierarchy) and files["group"]:
    group_rows = load_group_edges(files["group"])
    log_info("Group hierarchy edges loaded: " + str(len(group_rows)))
    all_edge_rows.extend(group_rows)

log_info("Total hierarchy edges to insert: " + str(len(all_edge_rows)))

for htype, parent_code, child_code, parent_type, child_type, path_to_root in all_edge_rows:
    edge_rows_to_insert.append([
        pReleaseId,
        htype,
        parent_code,
        child_code,
        parent_type,
        child_type,
        path_to_root
    ])

    if len(edge_rows_to_insert) >= 500:
        flush_rows(
            edge_stmt,
            edge_rows_to_insert,
            "insert_edge",
            "HierarchyEdge inserted",
            edge_counter
        )

flush_rows(
    edge_stmt,
    edge_rows_to_insert,
    "insert_edge",
    "HierarchyEdge inserted",
    edge_counter
)

closure_insert_sql = """
INSERT INTO Terminology_Loinc.Closure
(ReleaseId, HierarchyType, AncestorCode, DescendantCode, Depth)
SELECT ?,?,?,?,?
"""
closure_stmt = get_insert_stmt("closure", closure_insert_sql)

for hierarchy_type in ("COMPONENTBYSYSTEM", "GROUP"):
    parents_by_child, all_nodes = build_parent_map(all_edge_rows, hierarchy_type)

    if len(all_nodes) == 0:
        log_info("No nodes found for hierarchy type: " + hierarchy_type)
        continue

    log_info(
        "Building closure for hierarchy type: " + hierarchy_type +
        " | Nodes: " + str(len(all_nodes))
    )

    memo = {}
    closure_rows = []
    closure_counter = {"count": 0}
    processed = 0

    for node_id in sorted(all_nodes):
        ancestors = compute_ancestors(node_id, parents_by_child, memo, set())

        for ancestor_id, depth in ancestors.items():
            closure_rows.append([
                pReleaseId,
                hierarchy_type,
                ancestor_id,
                node_id,
                depth
            ])

        processed += 1

        if len(closure_rows) >= 1000:
            flush_rows(
                closure_stmt,
                closure_rows,
                "insert_closure_" + hierarchy_type,
                "Closure inserted " + hierarchy_type,
                closure_counter
            )

        if processed % 1000 == 0:
            log_info(
                "Closure progress | Type=" + hierarchy_type +
                " | Nodes processed=" + str(processed) +
                " | Rows=" + str(closure_counter["count"])
            )

    flush_rows(
        closure_stmt,
        closure_rows,
        "insert_closure_" + hierarchy_type,
        "Closure inserted " + hierarchy_type,
        closure_counter
    )

    log_info(
        "Closure complete | Type=" + hierarchy_type +
        " | Nodes processed=" + str(processed) +
        " | Rows=" + str(closure_counter["count"])
    )

log_info("BuilderHierarchy completed")
return iris.system.Status.OK()
}

}
