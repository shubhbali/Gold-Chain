# Unified API Policy

This project treats the Unified API as the only supported client-facing API.

## Policy

- Public users and apps should use only the Unified `eth_*` API.
- Direct `qkc_*` API usage is unsupported for normal product usage.
- If a developer bypasses Unified and calls direct `qkc_*` endpoints, any failure or shard-routing issue is their responsibility.

## Reason

- Unified API handles shard routing automatically.
- Users should not need to know shard keys or shard IDs.
- This keeps UX and integration simple for normal users.

## Operational Rule

- Expose Unified API publicly.
- Keep direct `qkc_*` endpoints internal/private whenever possible.

