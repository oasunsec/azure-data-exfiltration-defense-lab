# Defender endpoint scope

I checked Defender's machine inventory and the subscription's Azure VM inventory. Both were empty. Microsoft 365 E5 includes the relevant service plans, but there was no dedicated Windows lab endpoint to onboard without separate setup. [Inventory result](docs/evidence/public/endpoint-readiness.json).

**Defender endpoint correlation: NOT VALIDATED.**

The personal workstation was excluded from the lab. No device timeline, process event, or file event was collected. Endpoint DLP, USB/Bluetooth transfer, clipboard, and printing controls remain future work.

A later endpoint test can correlate actual Defender device/file events with Purview matches and Entra sign-ins. That integration is not implemented here.
