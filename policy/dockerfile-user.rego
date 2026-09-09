package main

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

deny[msg] {
    not any_user_defined

    msg := "No USER specified. Container runs as root by default"
}

any_user_defined {
    some i
    cmd(i) == "user"
}
