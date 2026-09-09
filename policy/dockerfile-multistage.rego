package main

# ==========================================================
# MULTI-STAGE BUILD RECOMMENDATION
# ==========================================================

warn[msg] {
    count(froms) < 2

    msg := "Consider using a multi-stage Docker build to reduce image size"
}

froms[i] {
    cmd(i) == "from"
}
