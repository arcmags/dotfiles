#!/usr/bin/env python3

## phrase-gen.py ::
# Generate phrases from lists of words.
# Something I wrote a long long time ago; spaghetti code, I tell you!

import os
import random
import re
import sys
from pathlib import Path

## config ::
SRC = [
    "GENERATE A_FEW HIGHLY RANDOM PHRASES .",
    "GENERATE a HIGHLY RANDOM PHRASE ."
]

A_FEW = [("a few",100), ("some",50), ("",100)]

# adjectives:
ARBITRARY = ["arbitrary", "random"]
RANDOM = [("arbitrary",25), ("random",100)]

# adverbs:
HIGHLY = [("highly",100), ("really",50), ("",100)]

# nouns:
SENTENCE = [("expression",20), ("phrase",20), ("sentence",100)]
SENTENCES = [("expressions",20), ("phrases",20), ("sentences",100)]
PHRASE = ["expression", "phrase", "sentence"]
PHRASES = ["expressions", "phrases", "sentences"]

# verbs:
GENERATE = [("construct",50), ("generate",100), ("make",20)]

WORDS_SAME = [
    ["expression", "phrase"],
]
WORDS_SKIP = [
    "random"
]

## internal ::
A = 1
COUNT = 1
BOOL_EXPAND_ALL = False
BOOL_IGNORE_REPEATED = False
BOOL_PRINT_WORDS = False
FILE = ""
LIST_BASE = []
WORDS_ALL = []
LISTS_ALL = []
LIST_INPUT = None
REGEX_1 = r"^(.*)\(([^/]*/[0-9].*?)\)(.*)$"
REGEX_2 = r"^(.*)\((.*?)\)(.*)$"
REGEX_3 = r"^(.*?)([^ /]+/[0-9]+\|[^ ]+)(.*)$"
REGEX_4 = r"^(.*?)([^ ]+\|[^ ]+)(.*)$"
REGEX_5 = r"^(.*?)([A-Z][A-Z0-9_]+)(.*)$"
REGEX_6 = r"^(.*?)( _S)(.*)$"
REGEX_7 = r"^(.*? |)(a)( [aeiou].*)$"
REGEX_8 = r"^(.*?)( ,)( .*)$"
REGEX_9 = r"^ *(.*?) ([\.\?!])( *( *<br> *)* *)(.*)$"

def w_rand(LIST):
# return a weighted random choice:
    if isinstance(LIST, list) and len(LIST) > 0:
        if isinstance(LIST[0], str):
            return(random.choice(LIST))
        else:
            TOTAL = 0
            for E in LIST:
                TOTAL += E[1]
            RANDOM = random.randint(1,TOTAL)
            TOTAL = 0
            for E in LIST:
                TOTAL += E[1]
                if RANDOM <= TOTAL:
                    return(E[0])
    else:
        return("")

def w_all(LIST):
# return entire list:
    LIST2=[]
    if isinstance(LIST, list) and len(LIST) > 0:
        if isinstance(LIST[0], str):
            for E in LIST:
                LIST2 += [E]
        else:
            for E in LIST:
               LIST2 += [E[0]]
        return(LIST2)
    else:
        return([""])

def w_check(STRING):
# check for repeated words:
    if BOOL_IGNORE_REPEATED is True:
        return True
    for WORD in WORDS_ALL:
        if re.split("[ ']", STRING).count(WORD) > 1:
            return False
    for LIST_2 in WORDS_SAME:
        C = 0
        for WORD in LIST_2:
            C += re.split("[ ']", STRING).count(WORD)
            if C > 1:
                return False
    return True

def w_expand(MASTER_LIST, COUNT):
# return COUNT random statements from MASTER_LIST:
    STATEMENTS = []
    STRING = w_rand(MASTER_LIST)
    STRING_2 = ""
    DONE = False
    T = 0
    C = 0
    while DONE is False:
        #print(str(C) + "-" + str(T) + "-> " + STRING)
        DONE = True
        REMATCH_1 = re.match(REGEX_1, STRING)
        REMATCH_2 = re.match(REGEX_2, STRING)
        REMATCH_3 = re.match(REGEX_3, STRING)
        REMATCH_4 = re.match(REGEX_4, STRING)
        REMATCH_5 = re.match(REGEX_5, STRING)
        REMATCH_6 = re.match(REGEX_6, STRING)
        REMATCH_7 = re.match(REGEX_7, STRING)
        REMATCH_8 = re.match(REGEX_8, STRING)
        REMATCH_9 = re.match(REGEX_9, STRING)
        if REMATCH_1 is not None:
            TMP = []
            for STR in REMATCH_1.group(2).split("|"):
                TMP += [(STR.split("/")[0], int(STR.split("/")[1]))]
            STRING_2 = REMATCH_1.group(1) + w_rand(TMP) + \
                REMATCH_1.group(3)
            DONE = False
        elif REMATCH_2 is not None:
            STRING_2 = REMATCH_2.group(1) + \
            random.choice(REMATCH_2.group(2).split("|")) + \
                REMATCH_2.group(3)
            DONE = False
        elif REMATCH_3 is not None:
            TMP = []
            for STR in REMATCH_3.group(2).split("|"):
                TMP += [(STR.split("/")[0], int(STR.split("/")[1]))]
            STRING_2 = REMATCH_3.group(1) + w_rand(TMP) + \
                REMATCH_3.group(3)
            DONE = False
        elif REMATCH_4 is not None:
            STRING_2 = REMATCH_4.group(1) + \
                random.choice(REMATCH_4.group(2).split("|")) + \
                REMATCH_4.group(3)
            DONE = False
        elif REMATCH_5 is not None:
            if eval("'" + REMATCH_5.group(2) + \
            "' in globals() and isinstance(" + \
            REMATCH_5.group(2) +", list)"):
                STRING_2 = REMATCH_5.group(1) + \
                    w_rand(eval(REMATCH_5.group(2))) + REMATCH_5.group(3)
            elif REMATCH_5.group(2) == "NULL" and \
            (REMATCH_5.group(1) != "" or REMATCH_5.group(3) != ""):
                if len(REMATCH_5.group(1)) > 0 and \
                REMATCH_5.group(1)[-1] == " " and \
                REMATCH_5.group(3)[0] == " ":
                    STRING_2 = REMATCH_5.group(1) + \
                        REMATCH_5.group(3)[1:]
                else:
                    STRING_2 = REMATCH_5.group(1) + REMATCH_5.group(3)
            else:
                STRING_2 = REMATCH_5.group(1) + \
                    REMATCH_5.group(2).lower() + REMATCH_5.group(3)
            DONE = False
        elif w_check(STRING_2) is True or T > 128:
            if REMATCH_6 is not None:
                STRING_2 = REMATCH_6.group(1)
                if REMATCH_6.group(1)[-1] == "s":
                    STRING_2 += "'" + REMATCH_6.group(3)
                else:
                    STRING_2 += "'s" + REMATCH_6.group(3)
                DONE = False
            elif REMATCH_7 is not None:
                STRING_2 = REMATCH_7.group(1) + "an" + \
                    REMATCH_7.group(3)
                DONE = False
            elif REMATCH_8 is not None:
                STRING_2 = REMATCH_8.group(1) + "," + REMATCH_8.group(3)
                DONE = False
            elif REMATCH_9 is not None:
                STRING_2 = REMATCH_9.group(1)[0].capitalize() + \
                    REMATCH_9.group(1)[1:] + REMATCH_9.group(2)
                if len(REMATCH_9.group(5)) > 0:
                    STRING_2 += " " + REMATCH_9.group(3) + " " + \
                        REMATCH_9.group(5)[0].\
                        capitalize() + REMATCH_9.group(5)[1:]
                DONE = False
            else:
                if STRING_2 == "":
                    STATEMENTS += [re.sub(r' +', ' ', STRING)]
                else:
                    STATEMENTS += [re.sub(r' +', ' ', STRING_2)]
                STRING_2 = w_rand(MASTER_LIST)
                C = 0
                T = 0
        else:
            T += 1
        if len(STATEMENTS) < COUNT:
            DONE = False
        STRING = STRING_2
        C += 1
    return(STATEMENTS)

def w_expand_all(MASTER_LIST):
# return every valid statement from MASTER_LIST:
    STATEMENTS = w_all(MASTER_LIST)
    DONE = False
    while DONE is False:
        DONE = True
        STATEMENTS_2 = []
        for STRING in STATEMENTS:
            REMATCH_1 = re.match(REGEX_1, STRING)
            REMATCH_2 = re.match(REGEX_2, STRING)
            REMATCH_3 = re.match(REGEX_3, STRING)
            REMATCH_4 = re.match(REGEX_4, STRING)
            REMATCH_5 = re.match(REGEX_5, STRING)
            REMATCH_6 = re.match(REGEX_6, STRING)
            REMATCH_7 = re.match(REGEX_7, STRING)
            REMATCH_8 = re.match(REGEX_8, STRING)
            REMATCH_9 = re.match(REGEX_9, STRING)
            if REMATCH_1 is not None:
                STRINGS = []
                for STR in REMATCH_1.group(2).split("|"):
                    STRINGS += [STR.split("/")[0]]
                for S in STRINGS:
                    STATEMENTS_2 += [REMATCH_1.group(1) + S + \
                        REMATCH_1.group(3)]
                DONE = False
            elif REMATCH_2 is not None:
                STRINGS = REMATCH_2.group(2).split("|")
                for S in STRINGS:
                    STATEMENTS_2 += [REMATCH_2.group(1) + S + \
                            REMATCH_2.group(3)]
                DONE = False
            elif REMATCH_3 is not None:
                STRINGS = []
                for STR in REMATCH_3.group(2).split("|"):
                    STRINGS += [STR.split("/")[0]]
                for S in STRINGS:
                    STATEMENTS_2 += [REMATCH_3.group(1) + S + \
                    REMATCH_3.group(3)]
                DONE = False
            elif REMATCH_4 is not None:
                STRINGS = REMATCH_4.group(2).split("|")
                for S in STRINGS:
                    STATEMENTS_2 += [REMATCH_4.group(1) + S + \
                        REMATCH_4.group(3)]
                DONE = False
            elif REMATCH_5 is not None:
                if eval("'" + REMATCH_5.group(2) + \
                "' in globals() and isinstance(" + \
                REMATCH_5.group(2) +", list)"):
                    STRINGS = w_all(eval(REMATCH_5.group(2)))
                    for S in STRINGS:
                        STATEMENTS_2 += [REMATCH_5.group(1) + S + \
                            REMATCH_5.group(3)]
                elif REMATCH_5.group(2) == "NULL" and \
                (REMATCH_5.group(1) != "" or REMATCH_5.group(3) != ""):
                    if len(REMATCH_5.group(1)) > 0 and \
                    REMATCH_5.group(1)[-1] == " " and \
                    REMATCH_5.group(3)[0] == " ":
                        STATEMENTS_2 += [REMATCH_5.group(1) + \
                            REMATCH_5.group(3)[1:]]
                    else:
                        STATEMENTS_2 += [REMATCH_5.group(1) + \
                            REMATCH_5.group(3)]
                else:
                    STATEMENTS_2 += [REMATCH_5.group(1) + \
                        REMATCH_5.group(2).lower() + REMATCH_5.group(3)]
                DONE = False
            elif w_check(STRING) is True:
                if REMATCH_6 is not None:
                    if REMATCH_6.group(1)[-1] == "s":
                        STATEMENTS_2 += [REMATCH_6.group(1) + "'" + \
                            REMATCH_6.group(3)]
                    else:
                        STATEMENTS_2 += [REMATCH_6.group(1) + "'s" + \
                            REMATCH_6.group(3)]
                    DONE = False
                elif REMATCH_7 is not None:
                    STATEMENTS_2 += [REMATCH_7.group(1) + "an" + \
                        REMATCH_7.group(3)]
                    DONE = False
                elif REMATCH_8 is not None:
                    STATEMENTS_2 += [REMATCH_8.group(1) + "," + \
                        REMATCH_8.group(3)]
                    DONE = False
                elif REMATCH_9 is not None:
                    STRING_2 = REMATCH_9.group(1)[0].capitalize() + \
                        REMATCH_9.group(1)[1:] + REMATCH_9.group(2)
                    if len(REMATCH_9.group(5)) > 0:
                        STRING_2 += " " + REMATCH_9.group(3) + " " + \
                            REMATCH_9.group(5)[0].\
                            capitalize() + REMATCH_9.group(5)[1:]
                    else:
                        STATEMENTS_2 += [REMATCH_9.group(1)[0]\
                            .capitalize() + REMATCH_9.group(1)[1:] + \
                            REMATCH_9.group(2)]
                    DONE = False
                else:
                    STATEMENTS_2 += [re.sub(r' +', ' ', STRING)]
        STATEMENTS = STATEMENTS_2.copy()
    return(STATEMENTS)

## main ::
while A < len(sys.argv):
    # -n:
    if re.match(r"^\-n[0-9]+$", str(sys.argv[A])) is not None or \
    str(sys.argv[A]) == "-n":
        if re.match(r"^\-n[0-9]+$", str(sys.argv[A])) is not None:
            COUNT = int(str(sys.argv[A])[2:])
        elif str(sys.argv[A]) == "-n":
            A += 1
            if A < len(sys.argv):
                if re.match(r"^[1-9]+[0-9]*$", str(sys.argv[A])) \
                is not None:
                    COUNT = int(sys.argv[A])
    # -f, --file:
    elif re.match(r"^\-f.+$", str(sys.argv[A])) is not None or \
    str(sys.argv[A]) == "-f" or str(sys.argv[A]) == "--file":
        if re.match(r"^\-f.+$", str(sys.argv[A])) is not None:
            FILE = str(sys.argv[A])[2:]
        elif str(sys.argv[A]) == "-f" or str(sys.argv[A]) == "--file":
            A += 1
            if A < len(sys.argv):
                FILE = str(sys.argv[A])
        FILE_PATH = Path(FILE)
        if FILE_PATH.is_file():
            #exec(open(FILE).read())
            with FILE_PATH.open() as f:
                exec("\n".join(f.readlines()))
    # -m, --src:
    elif re.match(r"^\-m.+$", str(sys.argv[A])) is not None or \
    str(sys.argv[A]) == "-m" or str(sys.argv[A]) == "--src":
        if re.match(r"^\-m.+$", str(sys.argv[A])) is not None:
            if str(sys.argv[A])[2:1] == "[":
                exec("LIST_BASE = [" + str(sys.argv[A])[2:] + "]")
            else:
                LIST_BASE = [str(sys.argv[A])[2:]]
        elif str(sys.argv[A]) == "-m" or str(sys.argv[A]) == "--src":
            A += 1
            if A < len(sys.argv):
                if str(sys.argv[A])[0:1] == "[":
                    exec("LIST_BASE = [" + str(sys.argv[A]) + "]")
                else:
                    LIST_BASE = [str(sys.argv[A])]
    # -s, --set:
    elif re.match(r"^\-s.+$", str(sys.argv[A])) is not None or \
    str(sys.argv[A]) == "-s" or str(sys.argv[A]) == "--set":
        if re.match(r"^\-s.+$", str(sys.argv[A])) is not None:
            exec(str(sys.argv[A])[2:])
        elif str(sys.argv[A]) == "-s" or str(sys.argv[A]) == "--set":
            A += 1
            if A < len(sys.argv):
                exec(str(sys.argv[A]))
    # -I, --ignore, --ignore-repeated:
    elif str(sys.argv[A]) in ["--ignore", "--ignore-repeated", "-I"]:
        #BOOL_IGNORE_REPEATED = True
        BOOL_IGNORE_REPEATED = not BOOL_IGNORE_REPEATED
    # -W, --words:
    elif str(sys.argv[A]) in ["--words", "-W"]:
        BOOL_PRINT_WORDS = True
    # -A, --all:
    elif str(sys.argv[A]) in ["--all", "-A"]:
        BOOL_EXPAND_ALL = True
    A += 1
LIST_INPUT = SRC

# run setup_words() function if it exists:
if "setup_words" in list(globals()):
    setup_words()

# build WORDS_ALL list:
for LIST in list(globals().keys()):
    if LIST not in ["LISTS_ALL", "LIST_BASE", "LIST_INPUT", "SRC",
    "WORDS_ALL", "WORDS_SAME", "WORDS_SKIP"] and \
    re.match(r"^[A-Z0-9_]+$", LIST) is not None and \
    re.match(r"^REGEX.+$", LIST) is None and \
    eval("isinstance(" + LIST +", list)"):
        for WORD in eval(LIST):
            if isinstance(WORD, tuple):
                WORD = WORD[0]
            if re.match(r".+ .+", WORD) is None and \
            re.match(r".*_.*", LIST) is None and \
            WORD not in ["", "NULL"]:
                WORDS_ALL += [WORD]
            LISTS_ALL += [LIST]
WORDS_ALL = sorted(set(WORDS_ALL).difference(set(WORDS_SKIP)))
LISTS_ALL = sorted(set(LISTS_ALL))

# print WORDS_ALL:
if BOOL_PRINT_WORDS is True:
    for LIST in LISTS_ALL:
        print(LIST.ljust(16) + str(eval(LIST)))
    print("WORDS_ALL".ljust(16) + str(sorted(set(WORDS_ALL))))
    sys.exit()

# generate and print STATEMENTS:
#if LIST_BASE is not None and LIST_BASE in list(globals().keys()):
if len(LIST_BASE) > 0:
    LIST_INPUT = LIST_BASE
if len(LIST_INPUT) > 0:
    # generate every possible statement:
    if BOOL_EXPAND_ALL is True:
        STATEMENTS = w_expand_all(LIST_INPUT)
    else:
    # generate fixed number of statements:
        STATEMENTS = w_expand(LIST_INPUT, COUNT)
        random.shuffle(STATEMENTS)
    for STATEMENT in STATEMENTS:
        #print(re.sub(r' *<br> *', '\n', STATEMENT))
        print(re.sub(r' *([:;])', r'\1',
            re.sub(r' *<br> *', '\n', STATEMENT)))
