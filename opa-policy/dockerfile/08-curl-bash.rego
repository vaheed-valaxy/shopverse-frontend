package main

# ==========================================================
# BLOCK curl | bash
# ==========================================================

deny[msg] {
    cmd(i) == "run"

    line := lower(val(i))

    contains(line, "curl")
    contains(line, "|")
    contains(line, "bash")

    msg := sprintf(
        "Line %d: Avoid curl | bash pattern",
        [i]
    )
}
