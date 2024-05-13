# InitWizard

![image](https://github.com/ImadIdaliouali/InitWizard/assets/145778347/f97f281b-7873-46c4-b105-2870a9080505)

This Bash script allows you to easily initialize a new project with various options such as project name, programming language, and whether to create a Git repository.

## Usage

1. Make sure the script file (`initWizard.sh`) is executable. If not, you can make it executable using the following command:
   ```bash
   chmod +x initWizard.sh
   ```
2. Run the script by executing the following command:
   ```bash
   sudo ./initWizard.sh
   ```
3. Follow the prompts to provide the necessary information:

   - **Project Name:** Enter the desired name for your project.
   - **Replace Existing Project:** If a project folder with the same name already exists, choose whether to replace it or create a new one with a different name.
   - **Select a Language:** Choose the programming language for your project from the available options.
   - **Create Git Repository:** Decide whether to create a Git repository for your project.

4. After providing all the required information, the script will initialize your project accordingly.

## Options

- **-l**: Enable logging. This option enables logging of information during project initialization.

- **-h (help)**: Display detailed program documentation.

- **-f (fork)**: Enable execution by creating subprocesses with fork. (working on it)

- **-t (thread)**: Enable execution by threads. (working on it)

- **-s (subshell)**: Execute the program in a subshell.

## Notes

- Make sure to run this script with root privileges as it requires certain permissions to create directories and log files.
