import sys

value_list = [0]
list_pointer = 0


def interpret_code(code: str):
    global value_list, list_pointer

    code_pointer = 0

    while code_pointer < len(code):
        command = code[code_pointer]

        if command == "+":
            value_list[list_pointer] = (value_list[list_pointer] + 1 if
                                        value_list[list_pointer] < 255 else 0)

        if command == "-":
            value_list[list_pointer] = (value_list[list_pointer] - 1 if
                                        value_list[list_pointer] > 0 else 255)

        if command == "<":
            list_pointer = list_pointer - 1 if list_pointer > 0 else 0

        if command == ">":
            list_pointer += 1
            if list_pointer >= len(value_list):
                value_list.append(0)

        if command == "[":
            currently_opened_brackets = 1

            start_pos = code_pointer + 1

            while currently_opened_brackets != 0:
                code_pointer += 1
                if code[code_pointer] == "[":
                    currently_opened_brackets += 1
                if code[code_pointer] == "]":
                    currently_opened_brackets -= 1

            subcode = code[start_pos:code_pointer]
            while value_list[list_pointer] != 0:
                interpret_code(subcode)

        if command == ",":
            value_list[list_pointer] = ord(input())

        if command == ".":
            print(f"{chr(value_list[list_pointer])}", end="")

        code_pointer += 1


if __name__ == "__main__":

    bf_file_path = sys.argv[1]

    with open(bf_file_path, "r") as file:
        bf_code = file.read()

    interpret_code(bf_code)
