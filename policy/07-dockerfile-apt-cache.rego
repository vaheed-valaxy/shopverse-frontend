package main

# ==========================================================
# APT CACHE MUST BE CLEANED
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
