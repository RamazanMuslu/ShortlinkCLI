# shortlink CLI

A minimalist and fast **Command Line Interface (CLI)** tool for shortening URLs directly from your terminal, powered by the **is.gd** API.

Designed for developers and power users who prefer keyboard-driven workflows, this tool supports both Linux (Bash/Zsh/Fish/etc.) and Windows (CMD/PowerShell) environments.

---

## ✨ Features

* **Blazing Fast Shortening:** Utilizes the highly reliable and simple `is.gd` API.
* **Cross-Platform Compatibility:** Dedicated installation scripts for both Linux and Windows.
* **Simple Syntax:** Shorten links with a single, quick command.
* **Lightweight:** Built with Python and only requires the `requests` library.

---

## 🛠️ Installation

The installation scripts permanently add the tool to your system's **PATH**, eliminating the hassle of configuring shell files like `.bashrc` or `.zshrc`.

### Linux Installation (Recommended for CachyOS, Arch, Ubuntu, Debian, etc.)

The installer script automatically handles Python dependencies and places the `shortlink` command into your system's **PATH** (`/usr/local/bin/`) for global access.

1.  **Navigate to the project root directory:**
    ```bash
    cd /path/to/shortlink-cli
    ```

2.  **Run the installation script with root privileges:**
    ```bash
    sudo ./linux_install.sh
    ```
    *The script takes care of Python 3, pip, and the **`requests`** library installation.*

### Windows Installation (CMD/PowerShell)

The installer uses **Winget** (Windows Package Manager) to install Python and permanently adds the tool to your User PATH.

1.  **Navigate to the project root directory:**
    ```batch
    cd C:\path\to\shortlink-cli
    ```

2.  **Run the installation script:**
    ```batch
    windows_install.bat
    ```
    
3.  **You need to restart your terminal (CMD/PowerShell) for the PATH changes to apply.**

---

## 🚀 Usage

Once installed, you can use the **`shortlink`** command globally.

### Basic Shortening

Simply provide the URL as the first argument:

```bash
shortlink [https://google.com](https://google.com)

Output:

[https://is.gd/XXXXXX](https://is.gd/XXXXXX)

Using the Flag

You can also use the -u flag for explicit shortening:
Bash

shortlink -u [https://google.com](https://google.com)

Help and Information

To see all available arguments and help text:
Bash

shortlink -h
# OR
shortlink -i

🧑‍💻 Contributing & Development

The tool uses a platform-specific core file structure (source/linux/shortlink.py and source/windows/shortlink.py) to allow for system-specific optimizations.

Project Structure:

.
├── source/
│   ├── linux/
│   │   └── shortlink.py  # Linux core
│   └── windows/
│       └── shortlink.py  # Windows core
├── linux_install.sh
├── windows_install.bat
└── README.md


Technologies:

    Core: Python 3

    Dependency: requests library

    Platform: Linux (CachyOS) / Windows

⚖️ License
MIT License