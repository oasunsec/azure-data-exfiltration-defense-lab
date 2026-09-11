from pathlib import Path


Path(__file__).resolve().parents[1].joinpath("runtime", "test-output").mkdir(
    parents=True, exist_ok=True
)
