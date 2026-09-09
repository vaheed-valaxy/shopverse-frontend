package main

# ==========================================================
# 1. BASE IMAGE MUST HAVE TAG OR DIGEST
# ==========================================================

deny[msg] {
    cmd(i) == "from"

    image := input[i].Value[0]

    not contains(image, ":")
    not contains(image, "@sha256:")

    msg := sprintf(
        "Line %d: Base image must have an explicit tag or digest: %s",
        [i, image]
    )
}


# ==========================================================
# 2. PREVENT ROOT USER
# ==========================================================

forbidden_users := {
    "root",
    "toor",
    "0"
}

deny[msg] {
    cmd(i) == "user"

    user := lower(input[i].Value[0])

    forbidden_users[user]

    msg := sprintf(
        "Line %d: Do not run as root user: %s",
        [i, user]
    )
}


# ==========================================================
# 3. POSSIBLE ENV SECRETS
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


# ==========================================================
# 4. BLOCK latest TAG
# ==========================================================

deny[msg] {
    cmd(i) == "from"

    image := lower(input[i].Value[0])

    contains(image, ":latest")

    msg := sprintf(
        "Line %d: Avoid using latest tag: %s",
        [i, image]
    )
}


# ==========================================================
# 5. AVOID ADD
# ==========================================================

deny[msg] {
    cmd(i) == "add"

    msg := sprintf(
        "Line %d: Use COPY instead of ADD",
        [i]
    )
}


# ==========================================================
# 6. BLOCK curl | bash
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


# ==========================================================
# 7. APT CACHE MUST BE CLEANED
# ==========================================================

deny[msg] {
    cmd(i) == "run"

    line := lower(val(i))

    contains(line, "apt-get install")
    not contains(line, "rm -rf /var/lib/apt/lists")

    msg := sprintf(
        "Line %d: Clean apt cache after package installation",
        [i]
    )
}

# ==========================================================
# 8. USER MUST BE DEFINED
# ==========================================================

deny[msg] {
    not any_user_defined

    msg := "No USER specified. Container runs as root by default"
}

any_user_defined {
    some i

    cmd(i) == "user"
}

# ==========================================================
# 9. MULTI-STAGE BUILD RECOMMENDATION
# ==========================================================

warn[msg] {
    count(froms) < 2

    msg := "Consider using a multi-stage Docker build to reduce image size"
}


froms[i] {
    cmd(i) == "from"
}
