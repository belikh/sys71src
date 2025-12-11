#include <Types.h>
#include <Memory.h>
#include <OSUtils.h>

/*
 * VirtualMemoryStub.c
 * Stubs for the Virtual Memory Manager to allow linking.
 */

Boolean gVMInitialized = false;

OSErr _VMInitialize(void) {
    return -1;
}

OSErr _VMDispatch(void) {
    return -1;
}

OSErr LockMemory(Ptr address, long count) {
    return noErr;
}

OSErr UnlockMemory(Ptr address, long count) {
    return noErr;
}

OSErr GetPhysical(LogicalToPhysicalTable *addresses, unsigned long *physicalEntryCount) {
    return -1;
}

void VMSecondaryInitialization(void) {
    gVMInitialized = false;
}
