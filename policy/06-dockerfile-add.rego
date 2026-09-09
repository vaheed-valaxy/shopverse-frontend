package main

# ==========================================================
# AVOID ADD
# ==========================================================

deny[msg] {
    cmd(i) == "add"

    msg := sprintf(
        "Line %d: Use COPY instead of ADD",
        [i]
    )
}
