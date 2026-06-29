import argparse
import csv
from pathlib import Path


BASE_COLUMNS = [
    "BookingItemTypeId",
    "Description",
    "BedsToMake",
    "CleaningMinutes",
    "CleaningWindowHours",
]
BASE_TYPES = {
    "BookingItemTypeId": "int",
    "Description": "nvarchar(100)",
    "BedsToMake": "int",
    "CleaningMinutes": "int",
    "CleaningWindowHours": "decimal(4,1)",
}


def quote_identifier(name):
    return "[" + name.replace("]", "]]") + "]"


def sql_string(value):
    return "N'" + value.replace("'", "''") + "'"


def sql_value(column, value, extra_column_type):
    value = value.strip()
    if value == "":
        return "NULL"

    if column == "Description":
        return sql_string(value)

    if column in ("BookingItemTypeId", "BedsToMake", "CleaningMinutes"):
        return str(int(value))

    if column == "CleaningWindowHours":
        return f"CAST({value.replace(',', '.')} AS decimal(4,1))"

    normalized_type = extra_column_type.strip().lower()
    if normalized_type.startswith(("int", "bigint", "smallint", "tinyint")):
        return str(int(value))
    if normalized_type.startswith(("decimal", "numeric", "float", "real")):
        return value.replace(",", ".")

    return sql_string(value)


def read_csv(csv_path):
    with csv_path.open("r", encoding="utf-8-sig", newline="") as csv_file:
        reader = csv.DictReader(csv_file, delimiter=";")
        if reader.fieldnames is None:
            raise ValueError("CSV file has no header row.")

        missing = [column for column in BASE_COLUMNS if column not in reader.fieldnames]
        if missing:
            raise ValueError("CSV file is missing columns: " + ", ".join(missing))

        rows = list(reader)
        return reader.fieldnames, rows


def build_sql(columns, rows, extra_column_type):
    extra_columns = [column for column in columns if column not in BASE_COLUMNS]
    merge_columns = [column for column in columns if column in BASE_COLUMNS or column in extra_columns]
    insert_columns = ", ".join(quote_identifier(column) for column in merge_columns)
    source_columns = ", ".join(quote_identifier(column) for column in merge_columns)

    value_lines = []
    for row in rows:
        values = ", ".join(
            sql_value(column, row.get(column, ""), extra_column_type)
            for column in merge_columns
        )
        value_lines.append(f"    ({values})")

    update_columns = [column for column in merge_columns if column != "BookingItemTypeId"]
    update_assignments = ",\n        ".join(
        f"target.{quote_identifier(column)} = source.{quote_identifier(column)}"
        for column in update_columns
    )
    insert_values = ", ".join(f"source.{quote_identifier(column)}" for column in merge_columns)

    alter_lines = []
    for column in extra_columns:
        alter_lines.append(
            f"IF COL_LENGTH(N'dbo.CabinCleaningInfo', N'{column.replace("'", "''")}') IS NULL\n"
            f"BEGIN\n"
            f"    ALTER TABLE dbo.CabinCleaningInfo ADD {quote_identifier(column)} {extra_column_type} NULL;\n"
            f"END;\n"
            f"GO\n"
        )

    return (
        "SET XACT_ABORT ON;\n"
        "GO\n\n"
        + "\n".join(alter_lines)
        + "\nBEGIN TRAN;\n\n"
        "MERGE dbo.CabinCleaningInfo AS target\n"
        "USING (VALUES\n"
        + ",\n".join(value_lines)
        + f"\n) AS source ({source_columns})\n"
        "ON target.[BookingItemTypeId] = source.[BookingItemTypeId]\n"
        "WHEN MATCHED THEN\n"
        "    UPDATE SET\n"
        f"        {update_assignments}\n"
        "WHEN NOT MATCHED BY TARGET THEN\n"
        f"    INSERT ({insert_columns})\n"
        f"    VALUES ({insert_values});\n\n"
        "COMMIT;\n\n"
        "SELECT COUNT(*) AS CabinCleaningInfoRows FROM dbo.CabinCleaningInfo;\n"
        "GO\n"
    )


def main():
    parser = argparse.ArgumentParser(
        description="Create a SQL MERGE script from a CabinCleaningInfo CSV."
    )
    parser.add_argument(
        "--csv",
        type=Path,
        default=Path("CabinCleaningInfo_with_extra_column.csv"),
        help="Input CSV file, semicolon-separated and UTF-8 encoded.",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("update_CabinCleaningInfo_from_csv.sql"),
        help="Output SQL file.",
    )
    parser.add_argument(
        "--extra-column-type",
        default="nvarchar(100)",
        help="SQL type to use when adding extra CSV columns to CabinCleaningInfo.",
    )
    args = parser.parse_args()

    columns, rows = read_csv(args.csv)
    sql_text = build_sql(columns, rows, args.extra_column_type)
    args.output.write_text(sql_text, encoding="utf-8-sig")
    print(f"Wrote {len(rows)} rows to {args.output}")


if __name__ == "__main__":
    main()
