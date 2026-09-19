# Client releases

Public downloads for builds that are developed privately. Nothing is built
here: each project's own repository builds its artifacts and publishes them
onto this one through `.github/workflows/publish.yml`.

Releases are named for the project they belong to, because they all share
this repo's single tag namespace:

    amazon-hot-selling-v1.2.0

so the downloads for one project are the assets of its own releases, and a
version number never collides with another project's.
