#[repr(C)]
#[derive(Clone, Copy, Debug, Default)]
pub struct SlotDev {
    pub sd_ext_dev_id: u8,
    pub sd_partition: u8,
    pub sd_slot_num: u8,
    pub sd_s_rsrc_id: u8,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default)]
pub struct SCSIDev {
    pub sd_reserved1: u8,
    pub sd_reserved2: u8,
    pub sd_ref_num: i16,
}

#[repr(C)]
#[derive(Clone, Copy)]
pub union DefStartRec {
    pub slot_dev: SlotDev,
    pub scsi_dev: SCSIDev,
}

impl Default for DefStartRec {
    fn default() -> Self {
        DefStartRec { slot_dev: SlotDev::default() }
    }
}

pub type DefStartPtr = *mut DefStartRec;

#[repr(C)]
#[derive(Clone, Copy, Debug, Default)]
pub struct DefVideoRec {
    pub sd_slot: u8,
    pub sds_resource: u8,
}

pub type DefVideoPtr = *mut DefVideoRec;

#[repr(C)]
#[derive(Clone, Copy, Debug, Default)]
pub struct DefOSRec {
    pub sd_reserved: u8,
    pub sd_os_type: u8,
}

pub type DefOSPtr = *mut DefOSRec;
