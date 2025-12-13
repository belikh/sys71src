
use crate::{OSType};

pub type SelectorFunctionProcPtr = *mut u8; // pascal OSErr (*)(OSType, long*)

#[repr(C)]
#[derive(Clone, Copy, Debug)]
pub struct GestaltEntry {
    pub selector: OSType,
    pub handler: SelectorFunctionProcPtr,
}
