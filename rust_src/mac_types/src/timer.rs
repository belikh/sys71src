
use crate::{ProcPtr};

#[repr(C)]
#[derive(Clone, Copy, Debug)]
pub struct QElem {
    pub q_link: *mut QElem,
    pub q_type: i16,
    pub q_data: [i16; 1],
}

pub type QElemPtr = *mut QElem;

pub type TimerUPP = ProcPtr; // pascal void (*)(TMTaskPtr)

#[repr(C)]
#[derive(Clone, Copy, Debug)]
pub struct TMTask {
    pub q_link: QElemPtr,
    pub q_type: i16,
    pub tm_addr: TimerUPP,
    pub tm_count: i32,
    pub tm_wake_up: i32,
    pub tm_reserved: i32,
}

pub type TMTaskPtr = *mut TMTask;

pub const K_TMTASK_ACTIVE: i16 = 1 << 15;
