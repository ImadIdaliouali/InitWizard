# Project Initialization Script

![image](https://github.com/ImadIdaliouali/InitWizard/assets/145778347/0253cfa5-8a0c-4a76-b3cc-115ea0b2eea0)

This Bash script allows you to easily initialize a new project with various options such as project name, programming language, and whether to create a Git repository.

## Usage

1. Make sure the script file (`init_project.sh`) is executable. If not, you can make it executable using the following command:
    ```bash
    chmod +x init_project.sh
    ```
2. Run the script by executing the following command:
    ```bash
    ./init_project.sh
    ```
3. Follow the prompts to provide the necessary information:
    - **Project Name:** Enter the desired name for your project.
    - **Replace Existing Project:** If a project folder with the same name already exists, choose whether to replace it or create a new one with a different name.
    - **Select a Language:** Choose the programming language for your project from the available options.
    - **Create Git Repository:** Decide whether to create a Git repository for your project.

4. After providing all the required information, the script will initialize your project accordingly.

## Options

- **-l**: Enable logging. This option enables logging of information during project initialization.

- **-h (help)**: Affiche une documentation détaillée du programme.

- **-f (fork)**: Permet une exécution par création de sous-processus avec fork. (working on it)

- **-t (thread)**: Permet une exécution par threads. (working on it)

- **-s (subshell)**: Exécute le programme dans un sous-shell.

## Notes

- Make sure to run this script with root privileges as it requires certain permissions to create directories and log files.
