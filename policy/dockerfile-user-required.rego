package main

# ==========================================================
# USER MUST BE DEFINED
# ==========================================================

deny[msg] {
    not any_user_defined

    msg := "No USER specified. Container runs as root by default"
}

any_user_defined {
    some i

    cmd(i) == "user"
}
