#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import requests
import argparse # CLI argument management
import platform # Used for minor OS checks if needed, but not strictly necessary here

# Version Information
VERSION = "1.1.0"
TOOL_NAME = "shortlink"
API_URL = "https://is.gd/api.php"
INFO_LIST = ["-h (Help)", "-v (Version)", "-u <link> (Shorten)", "-i (Info List)"]


def shorten(long_url):
    """
    Shortens the given URL using the is.gd API and returns the result.
    """
    
    parameters = {
        'longurl': long_url,
        'format': 'simple' 
    }

    try:
        # Send HTTP GET request
        response = requests.get(API_URL, params=parameters, timeout=5)
        
        # If request was successful (HTTP 200)
        if response.status_code == 200:
            short_link = response.text.strip()
            
            # Check for API-returned error message (Handles both Turkish and English API errors)
            if short_link.startswith("Hata:") or short_link.startswith("Error:"):
                # Print error message to stderr and exit
                print(f"ERROR: Shortening failed. Detail: {short_link}", file=sys.stderr)
                sys.exit(1)
            else:
                return short_link
        else:
            print(f"ERROR: Server access failed. HTTP Code: {response.status_code}", file=sys.stderr)
            sys.exit(1)
            
    except requests.exceptions.RequestException as e:
        print(f"NETWORK ERROR: Failed to connect to server. Detail: {e}", file=sys.stderr)
        sys.exit(1)

def print_info_list():
    """Prints the information list for the -i flag."""
    print(f"\n{TOOL_NAME} ({VERSION}) Available Arguments:")
    for item in INFO_LIST:
        print(f"  {item}")
    print("\nExtra info: If no argument is used, the first parameter is directly accepted as the URL to be shortened.")

def print_help_text():
    """Prints the usage guide for the -h flag."""
    print(f"""
{TOOL_NAME} v{VERSION} - CLI URL Shortener Tool

Usage:
  {TOOL_NAME} <URL>                  : Performs direct shortening.
  {TOOL_NAME} -u <URL>               : Starts the shortening process.
  {TOOL_NAME} -h                     : Shows this help message.
  {TOOL_NAME} -v                     : Shows version information.
  {TOOL_NAME} -i                     : Lists available arguments.

Examples:
  {TOOL_NAME} https://google.com
  {TOOL_NAME} -u https://google.com

""")

def main():
    parser = argparse.ArgumentParser(
        description="CLI URL shortener using the is.gd API.",
        add_help=False 
    )

    parser.add_argument('url_pos', nargs='?', default=None, help='URL to be shortened (Arg-less usage).')
    parser.add_argument('-h', '--help', action='store_true', help='Show help message.')
    parser.add_argument('-v', '--version', action='store_true', help='Show version information.')
    parser.add_argument('-i', '--info', action='store_true', help='List available arguments.')
    parser.add_argument('-u', type=str, metavar='URL', dest='url_flag', help='URL to be shortened.')

    args = parser.parse_args()

    # Handle Flags
    if args.help:
        print_help_text()
        return

    if args.version:
        print(f"{TOOL_NAME} Version: {VERSION}")
        return

    if args.info:
        print_info_list()
        return
    
    # Determine URL
    url_to_shorten = args.url_flag if args.url_flag else args.url_pos

    # Execute shortening or show error
    if url_to_shorten:
        result = shorten(url_to_shorten)
        if result:
            print(result)
    else:
        print("ERROR: No URL or valid argument provided.", file=sys.stderr)
        print("For more information:", file=sys.stderr)
        print_info_list()
        sys.exit(1)


if __name__ == "__main__":
    try:
        main()
    except SystemExit:
        pass
    except Exception as e:
        print(f"An unexpected error occurred: {e}", file=sys.stderr)
        sys.exit(1)