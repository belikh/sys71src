import struct
import os
import sys

def extract_resources(rsrc_path, output_dir):
    with open(rsrc_path, 'rb') as f:
        data = f.read()

    data_offset = struct.unpack('>I', data[0:4])[0]
    map_offset = struct.unpack('>I', data[4:8])[0]

    map_base = map_offset
    type_list_offset = struct.unpack('>H', data[map_base+24:map_base+26])[0]
    type_list_abs = map_base + type_list_offset

    num_types = struct.unpack('>H', data[type_list_abs:type_list_abs+2])[0] + 1
    current_type_ptr = type_list_abs + 2

    for i in range(num_types):
        r_type = data[current_type_ptr:current_type_ptr+4].decode('macroman', errors='ignore')
        num_rsrcs = struct.unpack('>H', data[current_type_ptr+4:current_type_ptr+6])[0] + 1
        ref_list_offset = struct.unpack('>H', data[current_type_ptr+6:current_type_ptr+8])[0]

        if r_type == 'CODE':
            print(f"Extracting {num_rsrcs} CODE segments...")
            ref_list_abs = type_list_abs + ref_list_offset
            for j in range(num_rsrcs):
                ref_ptr = ref_list_abs + (j * 12)
                r_id = struct.unpack('>h', data[ref_ptr:ref_ptr+2])[0]
                d_offset_raw = struct.unpack('>I', b'\0' + data[ref_ptr+5:ref_ptr+8])[0]
                abs_data_loc = data_offset + d_offset_raw
                r_len = struct.unpack('>I', data[abs_data_loc:abs_data_loc+4])[0]
                r_data = data[abs_data_loc+4 : abs_data_loc+4+r_len]

                # Only extract CODE 1 (Main) or CODE 0 (Jump Table) to avoid file limit/spam
                if r_id in [0, 1]:
                    out_name = f"CODE_{r_id}.bin"
                    out_path = os.path.join(output_dir, out_name)
                    with open(out_path, 'wb') as out_f:
                        out_f.write(r_data)
                    print(f"  Extracted CODE {r_id} ({r_len} bytes)")

        current_type_ptr += 8

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: extract_code.py <rsrc_file> <output_dir>")
        sys.exit(1)

    extract_resources(sys.argv[1], sys.argv[2])
