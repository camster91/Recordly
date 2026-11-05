# OpenTake

OpenTake is a screen recorder and video editor maintained by Cameron Ashley. This development branch starts from Recordly v1.4.0 and keeps the original recording and editing workflow while introducing a separate product and Windows package identity.

- [Product design](https://www.figma.com/design/w7aIqeIWLYsnHOD1teGwIY?node-id=3-2)
- [MVP spec](https://www.figma.com/design/w7aIqeIWLYsnHOD1teGwIY?node-id=2-2)

## Windows builds

The Windows workflow builds the x64 desktop application and runs packaged-binary smoke checks. With branch-specific Azure signing configured, it produces a signed NSIS installer and a signed sideloadable MSIX. The MSIX uses its own package identity. A Microsoft Store build would require a separate Partner Center identity and validation. Windows ARM64 capture support needs a dedicated build and device testing.

## Hosted service

The first integration is optional desktop Google OAuth and direct uploads to the user's Drive. A separate hosted service can later provide accounts, team workspaces and a playback or sharing experience. Keep authentication and storage boundaries explicit and review licence obligations for each deployed component before release. Neither the hosted service nor Google Drive upload is implemented in this branch yet.

## Source and attribution

OpenTake is based on [Recordly v1.4.0](https://github.com/webadderallorg/Recordly/tree/v1.4.0), itself derived from [OpenScreen](https://github.com/getopenscreen/openscreen). OpenTake changes began in November 2026. This derivative is distributed under AGPLv3 with upstream notices in [LICENSE.md](LICENSE.md). For a distributed binary, link recipients to the exact corresponding source revision and build instructions.
