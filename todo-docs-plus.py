#!/usr/bin/env python3
"""Create markdown todo's and function documentation from shell scripts.
"""

__author__ = "Spencer Butler"
__email__ = "dev@tcos.us"

import os
import re
import argparse


parser = argparse.ArgumentParser()
parser.add_argument(
    'file_name',
    help="A filename to parse.",
)
parser.add_argument(
    '-d',
    '--doc_dir',
    default='Docs',
    help="The diretory to store the markdown.",
)

args = parser.parse_args()

FILE_NAME_PATH = args.file_name
FILE_NAME = os.path.split(args.file_name)[-1]
DOC_DIR = args.doc_dir
TODO_FILE_NAME = f"{DOC_DIR}/TODO_{FILE_NAME}.md"
FUNCTION_FILE_NAME = f"{DOC_DIR}/FUNCTION_{FILE_NAME}.md"

if not os.path.isdir(DOC_DIR):
    print(f"{DOC_DIR} does not exist, creating it.")
    os.mkdir(DOC_DIR)

RE_FIND_comment = re.compile(r'^(\s+)?#(?![\s+]?\bshellcheck\b)[\s#-]+((\w+:?$)|(.*$))')
RE_FIND_function = re.compile(r'^(function )?([aA-zZ]+)\(\)?\s({)$')
RE_FIND_todo = re.compile(r"^.*#[\s+]?(TODO)\((\w+)?\)[\s:]+?(.*)")

todos_list = []
funcs_list = []

with open(FILE_NAME_PATH, 'r') as f:
    lineno = 0
    find_func = True

    for line in f.readlines():
        lineno += 1 

        todos = re.match(RE_FIND_todo, line)
        funcs = re.match(RE_FIND_function, line)
        comments = re.match(RE_FIND_comment, line)

        if todos:
            todos_list.append([lineno,todos.groups()])

        if find_func and funcs:
            funcs_list.append([lineno, funcs.groups(), 'func'])
            find_func = False
            continue

        if comments and not find_func:
            funcs_list.append([lineno, comments.groups(), 'comment'])
        else:
            find_func = True


todo_count = len(todos_list)
def write_todos(file_name: str=TODO_FILE_NAME):
    if todo_count > 0:
        print(f"Writing TODO file {file_name}")

        with open(file_name, 'w') as f:
            f.write(f"# {todo_count} TODOs for [{FILE_NAME}](../{FILE_NAME_PATH})\n\n")

        with open(file_name, 'a') as f:
            for todo in todos_list:
                lineno = todo[0]
                _todo = todo[1][0]
                name = todo[1][1] if todo[1][1] else 'Unassigned'
                message = todo[1][2]

                entry = f"- [L{lineno}: {_todo}](../{FILE_NAME_PATH}#L{lineno}) {name} - {message}\n"
                f.write(entry)
    else:
        print(f"There were {todo_count} TODOs found in {FILE_NAME}, not writing an empty file.")


func_count = len(funcs_list)
def write_funcs(file_name: str=FUNCTION_FILE_NAME):
    if func_count > 0:
        print(f"Writing Functions file {file_name}")

        with open(file_name, 'w') as f:
            f.write(f"# Functions for [{FILE_NAME}](../{FILE_NAME_PATH})\n\n")

        with open(file_name, 'a') as f:
            for func in funcs_list:
                _type = func[-1]
                lineno = func[0]
                name = func[1][1]

                if _type == 'func':
                    entry = f"\n## [L{lineno}: {name}](../{FILE_NAME_PATH}#L{lineno})\n\n"
                    f.write(entry)

                elif _type == 'comment':
                    is_header = func[1][2]

                    if is_header:
                        entry = f"\n### {name}\n\n"
                    else:
                        # TODO(spencer) fix this in the regex
                        if name:
                            entry = f"- {name}\n"
                        else:
                            continue

                    f.write(entry)
    else:
        print(f"There were {func_count} functions found in {FILE_NAME}, not writing an empty file.")



write_todos()
write_funcs()

#if __name__ == '__main__':