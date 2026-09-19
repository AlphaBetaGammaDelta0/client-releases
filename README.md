# Client releases

Public downloads for builds that are developed privately. Nothing is built
here: each project's own repository builds its artifacts and publishes them
onto this one through `.github/workflows/publish.yml`.

Releases are named for the project they belong to, because they all share
this repo's single tag namespace:

    amazon-hot-selling-v1.2.0

so the downloads for one project are the assets of its own releases, and a
version number never collides with another project's.

## Adding a project

A project publishes here by calling `.github/workflows/publish.yml` and
passing a token that may write releases to this repo. GitHub only shares
organisation secrets with private repositories on paid plans, so the token is
held once in the Keychain and copied into each project instead:

    ./scripts/release-setup.sh store          # once, on your machine
    ./scripts/release-setup.sh <owner/repo>   # once per project

Then the project's own workflow needs only:

    publish:
      needs: build
      uses: AlphaBetaGammaDelta0/client-releases/.github/workflows/publish.yml@main
      with:
        project: <name>
        version: ${{ needs.build.outputs.version }}
      secrets:
        releases_token: ${{ secrets.RELEASES_TOKEN }}
