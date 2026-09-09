package main

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

deny[msg] {
    cmd(i) == "from"

    image := lower(input[i].Value[0])

    contains(image, ":latest")

    msg := sprintf(
        "Line %d: Avoid using latest tag: %s",
        [i, image]
    )
}
