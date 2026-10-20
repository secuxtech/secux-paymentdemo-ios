# Demo wallet security

This application is a payment SDK demo. The create and restore wallet screens use
DASH testnet. Use fresh test wallets, never production recovery phrases or funds.
Recovery phrases, seeds and private keys must not be written to console or file logs.

## Historical test-wallet findings

The project owner confirmed the following historical findings as test-wallet data
on 2026-10-19. Classify these specific findings as **Used in tests**, rather than
outstanding production-wallet incidents. Keep the finding record for audit history.

| SHA-256 prefix from the audit | Historical commit | File |
| --- | --- | --- |
| `3e2c59` | `1dd3f7ed3107e7ded59c31c33cf0b0e5da06772c` | `MySecuXPay/ViewController/CreateWalletAccountViewController.swift` |
| `24f4b0` | `aea51230efd7c19366432758cca1231c7d86407a` | `MySecuXPay/ViewController/CreateWalletAccountViewController.swift` |

These short prefixes are audit references, not sufficient identifiers for a broad
scanner allowlist. Match the repository, historical location and complete finding
before dismissing an alert. Do not exclude the entire file, repository or mnemonic
rule. This classification does not extend to other wallets or findings.

For a matching GitHub secret-scanning alert, select **Close as → Used in tests** and
record the confirmed test purpose. For an external scan, record the same decision
in that scanner's finding-level suppression mechanism. This document does not
automatically dismiss GitHub alerts or configure an external scanner.

The historical values are not repeated here. Removing a value from current source
does not remove it from Git history. Published test phrases must never be reused
for production funds.

## Remaining payment credential cleanup

- Removed test-login examples and the checked-in SDK administrator-password fallback. Configure fresh test credentials through `SecuXAccountManager.setAdminAccount(name:password:)`; missing configuration returns the existing missing-token result before HTTP. HTTP request/response logs that could expose credentials have also been removed.
- This repository vendors SDK sources. Reinstalling older Pods can reintroduce the original behavior. Consume an updated upstream SDK before reinstalling dependencies.

This cleanup removes the identified values/artifacts from the current branch. It does not revoke server accounts, rotate deployed device keys, rewrite Git history, remove old tags/releases, or automatically resolve scanner alerts. Treat previously published usable credentials as exposed and have their owners revoke or rotate them. Use new, narrowly scoped test credentials if development resumes.
