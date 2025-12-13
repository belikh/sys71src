use mac_types::{OSErr};
use mac_types::start::{DefStartPtr, DefVideoPtr, DefOSPtr};

pub fn start_system() -> ! {
    // Stub for StartInit
    // In a real system, this would initialize the hardware,
    // load the system file, and jump to the Finder.
    loop {}
}

pub fn get_boot_drive() -> OSErr {
    0
}

pub unsafe fn get_default_startup(param_block: DefStartPtr) {
    if !param_block.is_null() {
        (*param_block).scsi_dev.sd_ref_num = -1; // Default to no drive
    }
}

pub unsafe fn set_default_startup(_param_block: DefStartPtr) {
    // Stub: Write to PRAM
}

pub unsafe fn get_video_default(param_block: DefVideoPtr) {
    if !param_block.is_null() {
        (*param_block).sd_slot = 0;
    }
}

pub unsafe fn set_video_default(_param_block: DefVideoPtr) {
    // Stub: Write to PRAM
}

pub unsafe fn get_os_default(param_block: DefOSPtr) {
    if !param_block.is_null() {
        (*param_block).sd_os_type = 1; // MacOS
    }
}

pub unsafe fn set_os_default(_param_block: DefOSPtr) {
    // Stub: Write to PRAM
}

pub unsafe fn set_timeout(_count: i16) {
    // Stub
}

pub unsafe fn get_timeout(count: *mut i16) {
    if !count.is_null() {
        *count = 0;
    }
}
