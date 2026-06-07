#!/usr/bin/env python3
"""Generate session data matching the ekatimer_sessions.csv format."""

import csv
import uuid
import random
import argparse
from datetime import datetime, timedelta


def generate_session_data(start_year=2015, end_year=None):
    """
    Generate session data from start_year to end_year.
    If end_year is None (not supplied), use today as the cutoff.
    Each duration is between 10 minutes (600s) and 3 hours (10800s).
    """
    rows = []
    current = datetime(start_year, 1, 1, 0, 0, 0)
    if end_year is None:
        end = datetime.now()
    else:
        end = datetime(end_year, 12, 31, 23, 59, 59)

    if current >= end:
        print("Error: start_year must be before end_year.")
        return rows

    while current < end:
        # Random duration: 10 min (600s) to 3 hours (10800s)
        duration = random.randint(600, 10800)

        # Ensure duration is never 0
        assert duration > 0, f"Generated invalid duration: {duration}"

        start_time = current
        end_time = current + timedelta(seconds=duration)

        # Advance time by a random gap (30 min to 6 hours) before next session
        gap = random.randint(1800, 21600)
        current = end_time + timedelta(seconds=gap)

        rows.append({
            "id": str(uuid.uuid4()),
            "startTime": start_time.strftime("%Y-%m-%dT%H:%M:%S.") + f"{start_time.microsecond:06d}",
            "endTime": end_time.strftime("%Y-%m-%dT%H:%M:%S.") + f"{end_time.microsecond:06d}",
            "durationSeconds": duration,
            "targetDurationSeconds": duration,
            "timerMode": "timed",
            "completed": 1,
            "notes": "",
        })

    return rows


def write_csv(rows, output_path):
    fieldnames = [
        "id", "startTime", "endTime", "durationSeconds",
        "targetDurationSeconds", "timerMode", "completed", "notes"
    ]
    with open(output_path, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Generate ekatimer test session data over a date range."
    )
    parser.add_argument(
        "--start-year", "-s",
        type=int,
        default=2015,
        help="Start year (default: 2015)"
    )
    parser.add_argument(
        "--end-year", "-e",
        type=int,
        default=None,
        help="End year (default: today's date if not supplied)"
    )
    args = parser.parse_args()

    end_label = args.end_year if args.end_year is not None else datetime.now().strftime("%Y%m%d")
    output_path = f"ekatimer_sessions_{args.start_year}-{end_label}.csv"
    rows = generate_session_data(args.start_year, args.end_year)

    if not rows:
        print("No data generated. Check your year range.")
    else:
        write_csv(rows, output_path)
        print(f"Generated {len(rows)} session rows -> {output_path}")
        print(f"Date range: {rows[0]['startTime']} to {rows[-1]['endTime']}")