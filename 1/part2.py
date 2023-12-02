import sys
import unittest

digit_strings = {
    'one': '1', 'two': '2', 'three': '3', 'four': '4', 'five': '5', 'six': '6', 'seven': '7', 'eight': '8', 'nine': '9'
}


def get_calibration_value(value: str):
    if not value:
        return 0
    
    # special cases with overlapping digits
    value = value.replace('oneight', '18')
    value = value.replace('threeight', '38')
    value = value.replace('fiveight', '58')
    value = value.replace('nineight', '98')
    value = value.replace('twone', '21')
    value = value.replace('sevenine', '79')
    value = value.replace('eightwo', '82')
    value = value.replace('eighthree', '83')

    for digit_string, digit in digit_strings.items():
        value = value.replace(digit_string, digit)
    digits = [int(char) for char in value if char.isdigit()]
    result = digits[0] * 10 + digits[-1]
    return result

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Filename needed. Leaving.")
        exit(1)
    
    filepath = sys.argv[1]
    
    with open(filepath, 'r') as file_content:
        calibration_sum = sum([get_calibration_value(x) for x in file_content.readlines()])
        print(calibration_sum)
