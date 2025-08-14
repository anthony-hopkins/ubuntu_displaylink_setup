# Ubuntu DisplayLink Setup

> *"Because manually setting up DisplayLink on Ubuntu is like trying to teach a cat to do calculus while juggling flaming chainsaws... and the cat is on fire."* 🔥🐱

A comprehensive solution for installing and configuring DisplayLink drivers on Ubuntu systems to enable multi-monitor support through USB-connected displays.

## 🤬 Why This Script Exists

Let's be honest - setting up DisplayLink on Ubuntu manually is a special kind of hell that involves:
- Reading through 47 different forum posts from 2012
- Praying to the Linux gods that your kernel version is compatible
- Wrestling with Secure Boot like it's a greased pig
- Trying to remember if you need to sacrifice a goat to DKMS
- Wondering why the universe hates you and your multi-monitor dreams

This script automates all that pain away. No more Googling "ubuntu displaylink evdi module not found" at 2 AM. No more crying into your coffee when your third monitor refuses to cooperate. Just run the script and get back to actually using your computer like a civilized human being.

*Disclaimer: This script may not solve all your life problems, but it will definitely solve your DisplayLink problems. Results may vary.*

## 🖥️ Overview

This project provides an automated script that handles the complete setup process for DisplayLink drivers on Ubuntu, making it easy to connect additional monitors via USB docks, adapters, or similar DisplayLink-enabled devices.

## ✨ Features

- **Automated Driver Installation**: Streamlined installation of DisplayLink drivers
- **Secure Boot Compatibility**: MOK key generation and kernel module signing
- **DKMS Integration**: Proper kernel module management and updates
- **Multi-Monitor Support**: Enable USB-connected displays for extended desktop
- **Ubuntu Compatibility**: Tested and optimized for Ubuntu systems

## 🚀 Quick Start

### Prerequisites

- Ubuntu system with sudo privileges
- DisplayLink-enabled USB device (dock, adapter, etc.)
- DisplayLink driver installer (.run file)

### Installation

1. **Clone or download this repository:**
   ```bash
   git clone <repository-url>
   cd Ubuntu_DisplayLink_Setup
   ```

2. **Place your DisplayLink installer in the project directory:**
   - Download the latest DisplayLink driver from [DisplayLink Downloads](https://www.synaptics.com/products/displaylink-graphics/downloads/ubuntu)
   - Place the `.run` file in the same directory as `displaylink_fix.sh`
   - Update the filename in the script if needed (line 25)

3. **Run the setup script:**
   ```bash
   chmod +x displaylink_fix.sh
   ./displaylink_fix.sh
   ```

4. **Follow the prompts:**
   - The script will install dependencies
   - Generate MOK keys for Secure Boot
   - Install the DisplayLink driver
   - Sign the kernel module
   - Configure the system

5. **Reboot when prompted** to enroll the MOK key in the MOK manager

6. **After reboot, rerun the script** from the exact same directory to complete the setup

## 📋 What the Script Does

The `displaylink_fix.sh` script automates these steps:

1. **System Dependencies**: Installs required packages (dkms, build tools, etc.)
2. **MOK Key Generation**: Creates Secure Boot compatible keys
3. **Driver Installation**: Installs the DisplayLink driver package
4. **Module Signing**: Signs the evdi kernel module for Secure Boot
5. **Configuration**: Loads and configures the DisplayLink module
6. **Post-Reboot Setup**: Provides clear instructions for completing the setup after MOK key enrollment

## 🔧 Configuration

### Customizing the Script

The script now uses environment variables for sensitive configuration. You can set these before running the script:

```bash
# DisplayLink driver version
export DISPLAYLINK_VERSION="5.8.0-59"

# MOK certificate settings
export MOK_CERT_CN="MyCompany DisplayLink"
export MOK_CERT_DAYS="730"
export MOK_KEY_SIZE="4096"

# Custom key file paths
export MOK_KEY="/path/to/custom/mok.key"
export MOK_CRT="/path/to/custom/mok.crt"
```

Or create a `.env` file based on `env.example` and source it before running the script.

### Supported DisplayLink Versions

- Tested with DisplayLink driver 5.8.0-59
- Compatible with most recent Ubuntu LTS releases
- Supports both Secure Boot enabled and disabled systems

## 🐛 Troubleshooting

### Common Issues

**Driver not found error:**
- Ensure the DisplayLink installer is in the same directory
- Check that the filename matches the script configuration

**Module signing fails:**
- Verify MOK keys were properly enrolled after reboot
- Check that the script is run from the same directory after reboot

**Display not detected:**
- Ensure the evdi module is loaded: `lsmod | grep evdi`
- Check system logs: `dmesg | grep -i evdi`

### Getting Help

- Check the [DisplayLink Ubuntu Support](https://support.displaylink.com/knowledgebase/articles/1181624-ubuntu-20-04-18-04-16-04-14-04-12-04)
- Review system logs for error messages
- Verify Secure Boot settings in BIOS/UEFI

## 📁 Project Structure

```
Ubuntu_DisplayLink_Setup/
├── README.md                 # This file
├── displaylink_fix.sh        # Main setup script
├── mok.key                   # Generated MOK private key
├── mok.crt                   # Generated MOK certificate
└── displaylink-driver-*.run  # DisplayLink installer (user-provided)
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests to improve this project.

## 📄 License

This project is open source. Please check the license file for details.

## 🙏 Acknowledgments

- DisplayLink for providing the driver technology
- Ubuntu community for kernel module support
- Open source contributors for DKMS and signing tools

## 📞 Support

If you encounter issues or have questions:

1. Check the troubleshooting section above
2. Review the script output for error messages
3. Ensure all prerequisites are met
4. Consider opening an issue with detailed system information

---

**Note**: This script modifies system-level components and requires sudo privileges. Always review the script before running and ensure you have a backup of important data.
