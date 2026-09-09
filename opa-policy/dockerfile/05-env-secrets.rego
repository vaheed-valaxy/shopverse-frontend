package main

# ==========================================================
# POSSIBLE ENV SECRETS
# ==========================================================

deny[msg] {
    cmd(i) == "env"

    re_match(
        "(?i)(^|[[:space:]])(password|passwd|pass|secret|token|api[_-]?key|access[_-]?key|auth[_-]?token|credential)([=[:space:]]|$)",
        val(i)
    )

    msg := sprintf(
        "Line %d: Possible secret detected in ENV instruction: %s",
        [i, val(i)]
    )
}
