# Deployment

This guide explains how to deploy the built system artifacts.

## Build Artifacts
After a successful build, the `Build/` directory will contain:
*   **System:** The main system file (resource suitcase).
*   **Finder:** The Finder application (or MiniFinder if linked).
*   **ROM Images:** (If applicable) ROM builds.

## Deployment Targets

### 1. Macintosh Emulator (Recommended)
You can test the build using emulators like **Mini vMac**, **BasiliskII**, or **MAME**.

**Steps:**
1.  Create a blank HFS disk image using `hfsutils` (or `dd` and `mkfs.hfs`).
    ```bash
    dd if=/dev/zero of=System7.img bs=1M count=10
    /usr/sbin/hformat -l "System 7" System7.img
    ```
2.  Copy the built `System` and `Finder` binaries into the image.
    ```bash
    hmount System7.img
    hmkdir "System Folder"
    hcopy Build/System ":System Folder:System"
    hcopy Build/Finder ":System Folder:Finder"
    # Bless the System Folder
    hattrib -b ":System Folder"
    humount
    ```
3.  Configure your emulator to mount `System7.img` as the boot drive.

### 2. Real Hardware
To deploy to a real Macintosh (e.g., SE/30, IIci):
1.  Write the disk image to a floppy disk or SD card (scsi2sd).
2.  Or, use a bridge machine to copy the files over LocalTalk/Ethernet.

## Publishing Documentation
This documentation site is designed to be published via **GitHub Pages**.

### Setup
1.  Go to the repository **Settings** on GitHub.
2.  Navigate to **Pages**.
3.  Under **Source**, select **Deploy from a branch**.
4.  Select the **main** branch and the **/docs** folder.
5.  Click **Save**.

The site will be available at `https://<username>.github.io/<repo-name>/`.
