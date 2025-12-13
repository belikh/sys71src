#![no_std]

pub type OSErr = i16;
pub type OSType = u32;
pub type ResType = OSType;
pub type Boolean = u8;
pub type Size = u32; // In 32-bit world, Size is long
pub type Ptr = *mut u8;
pub type Handle = *mut Ptr;
pub type ProcPtr = *mut u8; // Generic function pointer
pub type GrowZoneProcPtr = *mut u8; // Specific function pointer

pub mod start;

#[repr(C)]
#[derive(Clone, Copy, Debug, Default)]
pub struct Point {
    pub v: i16,
    pub h: i16,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default)]
pub struct Rect {
    pub top: i16,
    pub left: i16,
    pub bottom: i16,
    pub right: i16,
}

impl Rect {
    pub fn new(top: i16, left: i16, bottom: i16, right: i16) -> Self {
        Rect { top, left, bottom, right }
    }
}

#[repr(C)]
pub struct EventRecord {
    pub what: u16,
    pub message: u32,
    pub when: u32,
    pub where_: Point,
    pub modifiers: u16,
}

// Event codes
pub const NULL_EVENT: u16 = 0;
pub const MOUSE_DOWN: u16 = 1;
pub const MOUSE_UP: u16 = 2;
pub const KEY_DOWN: u16 = 3;
pub const KEY_UP: u16 = 4;
pub const AUTO_KEY: u16 = 5;
pub const UPDATE_EVT: u16 = 6;
pub const DISK_EVT: u16 = 7;
pub const ACTIVATE_EVT: u16 = 8;
pub const OS_EVT: u16 = 15;

pub const EVERY_EVENT: u16 = 0xFFFF;

// Pascal String helper
#[repr(C, packed)]
pub struct Str255 {
    pub len: u8,
    pub data: [u8; 255],
}

impl Str255 {
    pub fn from_str(s: &str) -> Self {
        let mut data = [0u8; 255];
        let len = s.len().min(255);
        data[..len].copy_from_slice(&s.as_bytes()[..len]);
        Str255 {
            len: len as u8,
            data,
        }
    }
}
