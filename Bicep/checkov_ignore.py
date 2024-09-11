import yaml
import os
import subprocess
from datetime import datetime

def is_expired(expiry_date):
    current_date = datetime.now().date()
    expiry_date = datetime.strptime(expiry_date, "%Y-%m-%d").date()
    return current_date > expiry_date

try:
    # Navigate to the Bicep directory
    os.chdir('Bicep')

    # Load the YAML content from the .checkovignore file
    with open('.checkovignore', 'r') as file:
        data = yaml.safe_load(file)

    # Extract the 'id' values from the ignore list that are not expired
    ids = [rule['id'] for rule in data['ignore'] if not is_expired(rule['expiry'])]

    if ids:
        # Join the ids into a comma-separated string
        skip_checks = ','.join(ids)
    else:
        skip_checks = "null"

    # Get the total number of ids
    total_ids = len(ids)

    # Print the results for debugging purposes
    print(f"SKIP_CHECKS: {skip_checks}")
    print(f"TOTAL_SKIPPED: {total_ids}")

    # List files for debugging
    subprocess.run(['pwd'])
    subprocess.run(['ls', '-lR'])

    # Run the Checkov scan using subprocess
    checkov_command = [
        'checkov',
        '--directory', '.',
        '--file', 'main.bicep',
        '--framework', 'bicep',
        '--soft-fail',
        '--quiet',
        '--compact',
        '--output', 'junitxml',
        '--skip-check', skip_checks
    ]

    # Redirect the output to the file
    with open('results_checkov.xml', 'w') as result_file:
        subprocess.run(checkov_command, stdout=result_file)

    # Set the environment variable in GitHub Actions
    with open(os.getenv('GITHUB_ENV'), 'a') as env_file:
        env_file.write(f"SKIP_CHECKS={skip_checks}\n")

except FileNotFoundError:
    # Handle the case where the file is not found
    skip_checks = "null"
    print("[INFO], Checkov ignore file not found, assign SKIP_CHECKS as null, for error handling when running checkov scan...")

    # Run the Checkov scan with 'null' skip checks
    checkov_command = [
        'checkov',
        '--directory', '.',
        '--file', 'main.bicep',
        '--framework', 'bicep',
        '--soft-fail
