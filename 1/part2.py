import sys
import unittest

digit_strings = {
    'one': '1', 'two': '2', 'three': '3', 'four': '4', 'five': '5', 'six': '6', 'seven': '7', 'eight': '8', 'nine': '9'
}

class TestGetCalibrationValue(unittest.TestCase):
    def test_function(self):
        test_data = [['two1nine', 29],
                    ['eightwothree', 83],
                    ['abcone2threexyz', 13],
                    ['xtwone3four', 24],
                    ['4nineeightseven2',42],
                    ['zoneight234', 14],
                    ['7pqrstsixteen', 76],
                    ['oneight', 18],
                    ['threeight', 38],
                    ['oneight', 18],
                    ['fiveight', 58],
                    ['nineight', 98],
                    ['twone', 21],
                    ['sevenine', 79],
                    ['eightwo', 82],
                    ['eighthree', 83]                 
                    ]
        for test_item in test_data:
            self.assertEqual(get_calibration_value(test_item[0]), test_item[1])
        
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
