#!/usr/bin/env python3
"""
Python port of the LOTRO Compendium plugin's ImportCompletionFromLotroCompanion.hta.
Supports both Windows and Linux environments.
Minimum Python version is 3.9. Only uses the Python standard library.

Reads the deed/quest completion data produced by LOTRO Companion and writes the files the in-game Compendium plugin loads:
    PluginData/<account>/<server>/<character>/CompendiumDeedProgression_CompanionImport.plugindata
    PluginData/<account>/<server>/<character>/CompendiumQuestProgression_CompanionImport.plugindata

Usage:
    python3 companion_to_compendium.py                                                       # Interactive CLI, autodetects LOTRO Companion and LOTRO game setup.
    python3 companion_to_compendium.py --list-characters (-l)                                # List all compatible LOTRO Companion characters.
    python3 companion_to_compendium.py --dry-run                                             # Only show what would be imported, no changes to disk.
    python3 companion_to_compendium.py --lotro-dir "/path/to/The Lord of the Rings Online"   # LOTRO user data directory, usually found in user documents.
    python3 companion_to_compendium.py --companion-home "/path/to/.lotrocompanion"           # LOTRO Companion home directory (not data directory), usually found in user home.
    python3 companion_to_compendium.py --character CHARACTER_NAME                            # Character name of character to import. Argument can be provided multiple times (--character Name_A --character Name_B).
"""

import argparse
import os
import re
import sys
from pathlib import Path
import xml.etree.ElementTree as ET
from dataclasses import dataclass


# (display name, import file, root tag, entry tag, output file)
IMPORT_SPECS = [
    ("Deed", "deedsStatus.xml", "deedsStatus", "deedStatus", "CompendiumDeedProgression_CompanionImport.plugindata"),
    ("Quest", "questsStatus.xml", "questsStatus", "questStatus", "CompendiumQuestProgression_CompanionImport.plugindata"),
]


@dataclass
class Character:
    directory: Path
    account: str
    server: str
    name: str
    char_class: str
    level: str

    def __str__(self):
        return f"{self.account} / {self.server} / {self.name} (lvl {self.level} {self.char_class})"

def resolve_character_dir(plugin_data_dir: Path, character: Character, output_file: str) -> Path:
    # LOTRO character names are always first letter capitalized and the rest lowercase so no weird case edge cases due to Windows being case-insensitive about directory names.
    return plugin_data_dir / character.account / character.server / character.name / output_file


def autodetect_lotro_dirs() -> list[Path]:
    candidates = [Path(__file__).parent.parent.resolve()]
    home = Path.home()

    if os.name == "nt":
        candidates.append(home / "Documents" / "The Lord of the Rings Online") # default in user Documents
    elif os.name == "posix":
        steam_roots = [
            home / ".steam" / "steam", # .deb archive
            home / ".local" / "share" / "Steam", # alternative .deb archive
            home / ".var" / "app" / "com.valvesoftware.Steam" / "data" / "Steam", # flatpak
            home / "snap" / "steam" / "common" / ".local" / "share" / "Steam", # snap
        ]

        for d in steam_roots:
            candidates.append(d / "steamapps" / "compatdata" / "212500" / "pfx" / "drive_c" / "users" / "steamuser" / "Documents" / "The Lord of the Rings Online")


    return [d for d in candidates if is_valid_lotro_dir(d)]

def is_valid_lotro_dir(lotro_dir: Path) -> bool:
    return (lotro_dir / "PluginData").is_dir()


def autodetect_companion_home_dirs(lotro_dir: Path) -> list[Path]:
    home = Path.home() 
    candidates = [home / ".lotrocompanion"] # default in user home (for Windows and also Linux if run via .sh script)

    if os.name == "posix":
        candidates.append(lotro_dir.parent.parent.resolve() / ".lotrocompanion") # Should return user home in Wine/Proton environment. Something like this: .../steamapps/compatdata/212500/pfx/drive_c/users/steamuser

    return [d for d in dict.fromkeys(candidates) if is_valid_companion_home_dir(d)] # use dict.fromkeys() to only keep unique options

def is_valid_companion_home_dir(companion_dir: Path) -> bool:
    return (companion_dir / "data" / "preferences" / "DataConfiguration.properties").is_file()

def get_companion_data_dir(companion_home: Path, lotro_dir: Path) -> Path:
    prop = companion_home / "data" / "preferences" / "DataConfiguration.properties"

    # Read properties config file for LOTRO Companion data directory
    try:
        with prop.open(encoding="utf-8", errors="replace") as f:
            for line in f:
                if line.startswith("RootPath="):
                    data_path = line.removeprefix("RootPath=").strip()

                    # .properties files from Java escape all values before writing to disk so we must first unescape the path.
                    # Doesn't allow for backslash line continuations but that doesn't matter for paths
                    # Regex to properly treat any backslash escapes. It does the following:
                    # \\ -> \
                    # \uXXXX -> unicode char
                    # \[escaped char] -> char
                    def repl(m: re.Match):
                        tok = m.group(1)
                        if tok == '\\':
                            return '\\'
                        if len(tok) == 5 and tok[0] == 'u':
                            return chr(int(tok[1:], 16))
                        return tok
                    data_path = re.sub(r'\\(u[0-9a-fA-F]{4}|\\|.)', repl, data_path, flags=re.DOTALL)
                    break
            else:
                sys.exit(f"Failed to find LOTRO Companion data directory path in: {prop}") # catches RootPath not present
    except OSError:
        sys.exit(f"Failed to read: {prop}")
    if not data_path:
        sys.exit(f"Failed to find LOTRO Companion data directory path in: {prop}") # catches RootPath empty
    
    # Convert Windows style path to Unix path if Windows path is given in Linux
    if os.name == "posix" and re.match(r"[A-Za-z]:.*", data_path):
        data_path = data_path.replace("\\", "/")
        drive, path = data_path.split(":/", maxsplit=1) # Breaks with drive-relative paths. Should not occur.
        # The .parent chain should return Wine/Proton prefix directory. Something like this: .../steamapps/compatdata/212500/pfx/
        # dosdevices drive letters are always lowercase
        data_path = (lotro_dir.parent.parent.parent.parent.parent / "dosdevices" / f"{drive.lower()}:" / path).resolve()

    # Convert to Path and validate
    data_path = Path(data_path)
    if not is_valid_companion_data_dir(data_path):
        sys.exit(f"Data path \"{data_path}\" found in \"{prop}\" doesn't contain character data.\nExtract at least one character with LOTRO Companion to continue.")
    
    return data_path

def is_valid_companion_data_dir(companion_dir: Path) -> bool:
    return (companion_dir / "characters").is_dir()


def get_companion_characters(companion_dir: Path) -> tuple[list[Character], list[tuple[Character, str]]]:
    characters = []
    skipped = []

    for d in (companion_dir / "characters").iterdir():
        summary_p = d / "summary.xml"
        if not d.is_dir() or not d.name.startswith("toon-") or not summary_p.is_file():
            continue

        try:
            root = ET.parse(summary_p).getroot()
        except (ET.ParseError, OSError) as e:
            print(f"  ! Could not parse {summary_p}: {e}")
            continue
        node = root if root.tag == "character" else root.find(".//character") # is this still needed? Backwards compatibility maybe?
        if node is None:
            continue

        UNKNOWN = "<UNKNOWN>"
        char = Character(
            d,
            node.get("account", UNKNOWN).removesuffix("."), # why remove a dot at the end? Seems weird but the .HTA does it
            node.get("server", UNKNOWN), # full_server_name no longer needed, PluginData no longer(?) includes the language tag (ex: [EN]) in the server name
            node.get("name", UNKNOWN),
            node.get("class", UNKNOWN),
            node.get("level", UNKNOWN)
        )

        if not char.account or char.account == UNKNOWN:
            skipped.append((char, "Found no associated account name"))
        elif not char.server or char.server == UNKNOWN:
            skipped.append((char, "Found no associated server name"))
        elif not char.name or char.name == UNKNOWN:
            skipped.append((char, "Found no associated character name"))
        elif not (d / "deedsStatus.xml").is_file():
            skipped.append((char, "Found no associated deeds status file (deedsStatus.xml)"))
        elif not (d / "questsStatus.xml").is_file():
            skipped.append((char, "Found no associated quests status file (questsStatus.xml)"))
        else:
            characters.append(char)

    return characters, skipped


def import_status_file(char: Character, plugin_data_dir: Path, dry_run: bool) -> bool:
    print(f"Importing {char.name}...")
    ok = True
    for display, import_file, root_tag, entry_tag, output_file in IMPORT_SPECS:
        src = char.directory / import_file
        try:
            root = ET.parse(src).getroot()
        except (ET.ParseError, OSError) as e:
            print(f"  ! {char.name}: could not read {src}: {e}")
            ok = False
            continue
        if root.tag == root_tag:
            nodes = root.findall(entry_tag)
        else:
            nodes = root.findall(f"{root_tag}/{entry_tag}")

        lines = []
        outdated = False
        for n in nodes:
            state = n.get("state")
            if state is None:
                outdated = True
                break
            lines.append((n.get("key", ""), state))
        if outdated:
            print(f"  ! {char.name}: {import_file} uses the outdated 'completed' format. Re-import this character in LOTRO Companion, then run this script again. Skipped.")
            ok = False
            continue

        out_path = resolve_character_dir(plugin_data_dir, char, output_file)
        if dry_run:
            print(f"  [dry-run] {char.name}: {len(lines)} {display.lower()} entries -> {out_path}")
            continue

        if not out_path.parent.is_dir():
            out_path.parent.mkdir(parents=True, exist_ok=True) # make parent (character) directory
            print(f"  Created character directory at: {out_path.parent}")
    
        body = ",\n".join(f'\t["{key}"] = "{state}"' for (key, state) in lines)
        with open(out_path, "w", encoding="utf-8") as f:
            f.write("return \n{\n" + body + "\n}\n") # space after return and newline at the end might not be needed but .HTA does this
        print(f"  {char.name}: wrote {len(lines)} {display.lower()} entries -> {out_path}")
    return ok


def main():
    parser = argparse.ArgumentParser(description="Import LOTRO Companion quest and deed completion into the LOTRO Compendium plugin. Python port of the plugin's ImportCompletionFromLotroCompanion.hta with Windows and Linux support.")
    parser.add_argument("-l", "--list-characters", action="store_true",
                help="List all compatible characters to import from LOTRO Companion.")
    parser.add_argument("--dry-run", action="store_true",
                help="Show what would be imported without writing files to disk.")
    parser.add_argument("--lotro-dir",
                    help="The \"The Lord of the Rings Online\" user data directory (the one containing \"PluginData\"). Usually found in user documents for Windows or Proton user documents for Linux. Interactive CLI if omitted.")
    parser.add_argument("--companion-home",
                    help="The \".lotrocompanion\" home directory (the one containing \"data/preferences\"). Usually found in user home for Windows or in Proton user home for Linux. Interactive CLI if omitted.")
    parser.add_argument("--character", action="append",
                    help="Which characters to import. Either use character name or \"ALL\" for all characters. Argument can be provided multiple times. Interactive CLI if omitted.")
    args = parser.parse_args()

    try:
        ### Get LOTRO data dirs
        lotro_dir_str = args.lotro_dir
        if not lotro_dir_str:
            options = autodetect_lotro_dirs()
            options_str = ("\n".join(f"{i+1}) {d}" for i, d in enumerate(options)) if len(options) > 0 else "No LOTRO data directories found, please enter path manually.") + "\n\n" 

            in_str = input(options_str + "Please select the number of a LOTRO data directory or enter a path: ")
            print("\n")
            lotro_dir_str = options[int(in_str)-1] if in_str.isdecimal() and (0 <= int(in_str)-1 < len(options)) else in_str.strip()

        lotro_dir = Path(lotro_dir_str).expanduser()
        if not is_valid_lotro_dir(lotro_dir):
            sys.exit(f"Selected directory \"{lotro_dir}\" is not a valid LOTRO data directory (does not contain a PluginData directory).\nEither select directory via dialogue or pass --lotro-dir \"/path/to/The Lord of the Rings Online\".\nNote: The Compendium plugin must have been loaded in game at least once so that PluginData exists.")
        plugin_data_dir = lotro_dir / "PluginData"


        ### Get LOTRO Companion dirs
        companion_home_dir_str = args.companion_home
        if not companion_home_dir_str:
            options = autodetect_companion_home_dirs(lotro_dir)
            options_str = ("\n".join(f"{i+1}) {d}" for i, d in enumerate(options)) if len(options) > 0 else "No LOTRO Companion home (.lotrocompanion) directories found, please enter path manually.") + "\n\n" 

            in_str = input(options_str + "Please select the number of a LOTRO Companion home directory or enter a path: ")
            print("\n")
            companion_home_dir_str = options[int(in_str)-1] if in_str.isdigit() and (0 <= int(in_str)-1 < len(options)) else in_str.strip()

        companion_home_dir = Path(companion_home_dir_str).expanduser()
        if not is_valid_companion_home_dir(companion_home_dir):
            sys.exit(f"Selected directory \"{companion_home_dir}\" is not a valid LOTRO Companion home directory (doesn't contain \"data/preferences/DataConfiguration.properties\" file).\nEither select directory via dialogue or pass --companion-home \"/path/to/.lotrocompanion\".\nNote: The LOTRO Companion program must have run and extracted at least one character.")
        companion_data_dir = get_companion_data_dir(companion_home_dir, lotro_dir)

        
        ### Get Companion characters
        characters, skipped = get_companion_characters(companion_data_dir)

        if skipped:
            print("Cannot load the following characters from LOTRO Companion for the following reasons:")
            print("\n".join(f"{c} - {s}" for c, s in skipped))
        if not characters:
            sys.exit("No valid character found to import. Please import a character with LOTRO Companion first.")


        ### List characters if requested.
        if args.list_characters:
            print("Available characters:\n" + "\n".join(f"{c}" for c in characters))
            sys.exit()


        # Loop until person chooses to exit
        while True:
            ### select which characters to import
            selected_characters = [*dict.fromkeys(args.character or [])] # dict.fromkeys to only keep unique names while preserving order
            if not selected_characters:
                options = ["ALL"] + characters
                options_str = ("\n".join(f"{i+1}) {d}" for i, d in enumerate(options))) + "\n\n"

                in_str = input(options_str + "Please select the number of a character to import or enter a character name: ")
                print("\n")
                selected_characters = options[int(in_str)-1] if in_str.isdigit() and (0 <= int(in_str)-1 < len(options)) else in_str.strip()

            to_import = []
            if (isinstance(selected_characters, str) and selected_characters.upper() == "ALL") or (isinstance(selected_characters, list) and any([sc.upper() == "ALL" for sc in selected_characters])): # not efficient but doesn't matter
                to_import = characters
            elif isinstance(selected_characters, Character):
                to_import.append(selected_characters)
            elif isinstance(selected_characters, str):
                to_import = [c for c in characters if c.name == selected_characters]
            elif isinstance(selected_characters, list):
                for sc in selected_characters:
                    to_import += [c for c in characters if c.name == sc]
                
            if not to_import:
                sys.exit(f"No character found to import with name(s): {selected_characters}\nPass characters with --character argument or select via dialogue.")


            ### Import
            print("-=-=-=- STARTING IMPORT -=-=-=-")
            all_ok = all(import_status_file(c, plugin_data_dir, args.dry_run) for c in to_import)
            print()
            if all_ok:
                if not args.dry_run:
                    print("Import process complete!\n\nIn game: log in the character or reload plugin. Finalize import by opening Compendium plugin's quest and/or deed tab.")
                else:
                    print("Import process complete (dry run, nothing written).")
            else:
                print("Import finished with warnings, see the messages above.")


            ### Next import or quit
            # If character was provided, quit
            if args.character:
                sys.exit()

            print("\n")
            while True:
                in_str = input("Type 'q' to exit the program or type 'c' to import another character: ")
                if in_str in ["1", "q", "Q", "quit", "exit"]:
                    sys.exit()
                elif in_str in ["2", "c", "C", "continue", "import"]:
                    print("\n")
                    break # starts another character selection
                else:
                    print(f"Unknown command {in_str}")
    except (EOFError, KeyboardInterrupt):
        sys.exit("\nAborting program")


if __name__ == "__main__":
    main()
