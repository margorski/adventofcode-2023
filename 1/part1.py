import sys

def get_calibration_value(value: str):
    if not value:
        return 0
    digits = [int(char) for char in value if char.isdigit()]
    return digits[0] * 10 + digits[-1]

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Filename needed. Leaving.")
        exit(1)
    
    filepath = sys.argv[1]
    
    with open(filepath, 'r') as input:
        calibration_sum = sum([get_calibration_value(x) for x in input.readlines()])
        print(calibration_sum)

    