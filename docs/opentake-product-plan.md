# OpenTake product plan

## Desktop milestone

Build a signed Windows x64 MSIX and NSIS from the same commit. Install the MSIX on a clean Windows profile and verify it can coexist with Recordly. Test capture, camera, mic, pause and MP4 export. Test x64 under emulation on Snapdragon before claiming support. Keep the MSIX publisher and package name stable across updates. Treat Microsoft Store packaging and native ARM64 as separate milestones.

## Google Drive milestone

After local MP4 finalization, let the user connect Google via desktop OAuth in the system browser and upload to an app folder in their own My Drive. Use a narrow per-file scope, local secure storage for tokens and a resumable queue that survives restarts. Upload private by default. Only copy an unrestricted viewer link after the user explicitly chooses link access and Google confirms it. Local recording and export remain available without sign-in.

## Hosted milestone

Start with a landing page and downloads linked to matching source revisions. Add a separately deployed account and workspace service when a team workflow requires it. Keep hosted video sharing optional. Decide between access through the viewer's existing Drive permissions and an explicitly uploaded hosted copy before designing playback. Avoid proxying private Drive videos through the service by default. Validate deletion, access revocation, retention, and per-workspace isolation before hosting customer recordings.

Review AGPL obligations before deploying any modified AGPL component that users interact with over a network. Keep upstream copyright notices and attribution, and provide corresponding source for distributed desktop binaries.
