package main

# ==========================================================
# BLOCK latest TAG
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
