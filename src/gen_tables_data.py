"""Generate tables_data.c from python_doom/doom/tables_data.py (vanilla tables.c)."""
from __future__ import annotations

import importlib.util
import pathlib

ROOT = pathlib.Path(__file__).resolve().parents[2]
TD = ROOT / "python_doom" / "doom" / "tables_data.py"
OUT = pathlib.Path(__file__).resolve().parent / "tables_data.c"


def load_tables():
    spec = importlib.util.spec_from_file_location("td", TD)
    mod = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(mod)
    return mod.FINESINE, mod.FINETANGENT, mod.TANTOANGLE


def emit(name: str, arr) -> str:
    lines = [f"const int {name}[{len(arr)}] = {{"]
    row: list[str] = []
    for v in arr:
        row.append(str(int(v)))
        if len(row) == 16:
            lines.append("    " + ", ".join(row) + ",")
            row = []
    if row:
        lines.append("    " + ", ".join(row) + ",")
    lines.append("};")
    return "\n".join(lines)


def main() -> None:
    finesine, finetangent, tantoangle = load_tables()
    parts = [
        "/* Auto-generated from python_doom/doom/tables_data.py — vanilla tables.c */",
        '#include "tables_data.h"',
        "",
        emit("DOOM_FINESINE", finesine),
        "",
        emit("DOOM_FINETANGENT", finetangent),
        "",
        emit("DOOM_TANTOANGLE", tantoangle),
        "",
    ]
    OUT.write_text("\n".join(parts), encoding="utf-8")
    print(f"wrote {OUT} ({OUT.stat().st_size} bytes)")
    print(len(finesine), len(finetangent), len(tantoangle))


if __name__ == "__main__":
    main()
