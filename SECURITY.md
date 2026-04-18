# Security Policy

## Supported Versions

Only the latest release of Alea published on [Itch.io](https://itch.io) receives security fixes.
Older builds are not maintained.

| Version | Supported |
| ------- | --------- |
| Latest  | Yes       |
| Older   | No        |

## Reporting a Vulnerability

If you discover a security vulnerability, please **do not open a public GitHub issue**.

Instead, report it privately using [GitHub's private security advisory feature](https://github.com/The-Scholarship/Alea_Game-of-dice/security/advisories/new).

Please include:
- A clear description of the vulnerability
- Steps to reproduce it
- The potential impact
- Any suggested fix if you have one

We will fix the issues as soon as possible.

## Scope

**In scope:**

- Logic bugs that could be exploited to cheat or manipulate game state in a way that harms other players (relevant once multiplayer is added)

**Out of scope:**
- Vulnerabilities in the Godot engine itself — report those to the [Godot Security team](https://godotengine.org/security)
- Issues that only affect local, single-player gameplay with no impact on other users
- Cheating in single-player mode

## Notes

This is a little game project. There is no server-side backend at this time, so the attack surface is limited to the game client and any future online features.
