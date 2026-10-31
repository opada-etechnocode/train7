"""Translate assets/lang/en.json -> assets/lang/ar.json with resume support."""
import json
import time
import copy
import re
from pathlib import Path

from deep_translator import GoogleTranslator

ROOT = Path(__file__).resolve().parents[1]
EN_PATH = ROOT / "assets" / "lang" / "en.json"
AR_PATH = ROOT / "assets" / "lang" / "ar.json"
CACHE_PATH = ROOT / "assets" / "lang" / "_ar_cache.json"


def main() -> None:
    en_data = json.loads(EN_PATH.read_text(encoding="utf-8"))
    cache: dict[str, str] = {}
    if CACHE_PATH.exists():
        cache = json.loads(CACHE_PATH.read_text(encoding="utf-8"))

    texts: list[str] = []
    for screen in en_data:
        for item in screen.get("keyword_data", []):
            value = item.get("keyword_value", "")
            if value and value not in texts:
                texts.append(value)

    translator = GoogleTranslator(source="en", target="ar")
    pending = [t for t in texts if t not in cache]
    print(f"total={len(texts)} cached={len(cache)} pending={len(pending)}", flush=True)

    for idx, text in enumerate(pending, start=1):
        if re.fullmatch(r"[\d\s\W_]+", text or ""):
            cache[text] = text
        else:
            parts = text.split("\n")
            out: list[str] = []
            for part in parts:
                if not part.strip():
                    out.append(part)
                    continue
                translated = None
                for attempt in range(8):
                    try:
                        translated = translator.translate(part)
                        break
                    except Exception as exc:  # noqa: BLE001
                        wait = min(30, 2 ** attempt)
                        print(f"retry {attempt} wait={wait}s err={exc}", flush=True)
                        time.sleep(wait)
                out.append(translated if translated else part)
                time.sleep(0.4)
            cache[text] = "\n".join(out)

        if idx % 10 == 0 or idx == len(pending):
            CACHE_PATH.write_text(
                json.dumps(cache, ensure_ascii=False, indent=2),
                encoding="utf-8",
            )
            print(f"progress {idx}/{len(pending)}", flush=True)
            time.sleep(1.5)

    ar_data = copy.deepcopy(en_data)
    for screen in ar_data:
        for item in screen.get("keyword_data", []):
            value = item.get("keyword_value", "")
            item["keyword_value"] = cache.get(value, value)

    AR_PATH.write_text(
        json.dumps(ar_data, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )

    arabic_count = 0
    for screen in ar_data:
        for item in screen.get("keyword_data", []):
            value = item.get("keyword_value", "")
            if any("\u0600" <= c <= "\u06FF" for c in value):
                arabic_count += 1
    print(f"DONE arabic_values={arabic_count}", flush=True)


if __name__ == "__main__":
    main()
