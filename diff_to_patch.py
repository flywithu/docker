import re
import subprocess
from pathlib import Path
import sys

def split_and_apply_diff(repo_diff_file_path):
    # Verify the diff file exists
    repo_diff_file = Path(repo_diff_file_path)
    if not repo_diff_file.exists():
        print("Diff file does not exist.")
        return
    
    with open(repo_diff_file, 'r') as file:
        content = file.read()
    
    # Regex to find project blocks and names
    project_blocks = re.split(r'^project\s.*/$', content, flags=re.MULTILINE)
    project_names = re.findall(r'^project\s.*/$', content, flags=re.MULTILINE)
    
    if not project_names:
        print("No project blocks found in the diff file.")
        return

    for i, block in enumerate(project_blocks[1:]):  # Skip the first split as it's before the first project marker
        # Extract project name and create the patch content
        project_name = project_names[i].split()[1].strip('/')
        project_path = Path(project_name)
        diff_content = block.strip()
        if project_path.exists():
            # Create a patch file within the project directory
            diff_file_path = project_path / f"{project_path.name}.patch"
            with open(diff_file_path, 'w') as diff_file:
                diff_file.write(diff_content)
            
            # Apply the patch
            
            print(f"Applying {diff_file_path} patch to: {project_path}")
            subprocess.run(["git", "apply", str(Path(diff_file_path).name)], cwd=project_path)
        else:
            print(f"Project directory {project_path} does not exist.")
    print("Patch application process completed.")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <repo_diff_file>")
        sys.exit(0)

    print(f"Diff file: {sys.argv[1]}")

    repo_diff_path = Path(sys.argv[1])
    split_and_apply_diff(repo_diff_path)
    