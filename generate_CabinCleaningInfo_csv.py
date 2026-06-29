import argparse
import csv
import re
from decimal import Decimal
from pathlib import Path


DEFAULT_INPUT = Path("insert_CabinCleaningInfo.sql")
DEFAULT_OUTPUT = Path("CabinCleaningInfo.csv")
BASE_COLUMNS = [
    "BookingItemTypeId",
    "Description",
    "BedsToMake",
    "CleaningMinutes",
    "CleaningWindowHours",
]


def split_top_level(value_text):
    parts = []
    start = 0
    depth = 0
    in_string = False
    i = 0

    while i < len(value_text):
        char = value_text[i]
        next_char = value_text[i + 1] if i + 1 < len(value_text) else ""

        if in_string:
            if char == "'" and next_char == "'":
                i += 2
                continue
            if char == "'":
                in_string = False
            i += 1
            continue

        if char == "'":
            in_string = True
        elif char == "(":
            depth += 1
        elif char == ")":
            depth -= 1
        elif char == "," and depth == 0:
            parts.append(value_text[start:i].strip())
            start = i + 1
        i += 1

    parts.append(value_text[start:].strip())
    return parts


def extract_row_texts(sql_text):
    values_match = re.search(
        r"USING\s*\(VALUES\s*(?P<values>.*?)\)\s*AS\s+source",
        sql_text,
        flags=re.IGNORECASE | re.DOTALL,
    )
    if not values_match:
        raise ValueError("Could not find USING (VALUES ...) block in input SQL.")

    values = values_match.group("values")
    rows = []
    depth = 0
    in_string = False
    row_start = None
    i = 0

    while i < len(values):
        char = values[i]
        next_char = values[i + 1] if i + 1 < len(values) else ""

        if in_string:
            if char == "'" and next_char == "'":
                i += 2
                continue
            if char == "'":
                in_string = False
            i += 1
            continue

        if char == "'":
            in_string = True
        elif char == "(":
            if depth == 0:
                row_start = i + 1
            depth += 1
        elif char == ")":
            depth -= 1
            if depth == 0 and row_start is not None:
                rows.append(values[row_start:i].strip())
                row_start = None
        i += 1

    return rows


def parse_value(value):
    value = value.strip()

    string_match = re.fullmatch(r"N?'((?:''|[^'])*)'", value, flags=re.DOTALL)
    if string_match:
        return string_match.group(1).replace("''", "'")

    cast_match = re.fullmatch(
        r"CAST\(([-+]?\d+(?:\.\d+)?)\s+AS\s+decimal\(\d+,\d+\)\)",
        value,
        flags=re.IGNORECASE,
    )
    if cast_match:
        return str(Decimal(cast_match.group(1)))

    if re.fullmatch(r"[-+]?\d+", value):
        return int(value)

    raise ValueError(f"Unsupported SQL value: {value}")


def read_rows(input_path):
    sql_text = input_path.read_text(encoding="utf-8-sig")
    rows = []

    for row_text in extract_row_texts(sql_text):
        values = split_top_level(row_text)
        if len(values) != len(BASE_COLUMNS):
            raise ValueError(f"Expected {len(BASE_COLUMNS)} values, got {len(values)}: {row_text}")
        rows.append([parse_value(value) for value in values])

    return sorted(rows, key=lambda row: row[0])


def main():
    parser = argparse.ArgumentParser(
        description="Create a CabinCleaningInfo CSV from insert_CabinCleaningInfo.sql."
    )
    parser.add_argument("--input", type=Path, default=DEFAULT_INPUT)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument(
        "--extra-column",
        action="append",
        default=[],
        help="Add an extra empty column to the CSV. Can be used more than once.",
    )
    args = parser.parse_args()

    rows = read_rows(args.input)
    columns = BASE_COLUMNS + args.extra_column

    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("w", encoding="utf-8-sig", newline="") as csv_file:
        writer = csv.writer(csv_file, delimiter=";")
        writer.writerow(columns)
        for row in rows:
            writer.writerow(row + [""] * len(args.extra_column))

    print(f"Wrote {len(rows)} rows to {args.output}")


if __name__ == "__main__":
    main()
