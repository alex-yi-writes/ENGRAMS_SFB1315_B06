import pydicom
import numpy as np
import matplotlib.pyplot as plt

# where is the PMU dicom?
dicom_file = "/Users/alex/Dropbox/paperwriting/1315/data/QA_new/raw/fpy194/fpy194_x67/scans/53-ep2d_bold_0.8mm_96slc_3x3_BW1374_ghost_reduction_fleet_PMU/resources/secondary/1.3.12.2.1107.5.2.61.251201.30000024111208412390300000007-53-2-xjzy73.dcm"

# load the file
ds = pydicom.dcmread(dicom_file)

# how does the data look?
print("dcm tags and metadata:")
for elem in ds:
    print(f"tag: {elem.tag}, description: {elem.description()}, value: {str(elem.value)[:100]}")

# try to extract all physio data
try:
    physiodata = ds[(0x7FE1, 0x1010)].value

    physio_array = np.frombuffer(physiodata, dtype=np.int16)  # maybe it's int16
    print("data size:", physio_array.size)

    scaling_factor = 1  # i don't know this
    offset = 0          # no apparent offset
    physio_array = physio_array * scaling_factor + offset

    # define the number of channels 
    num_channels = 4  # normally PMU acquires pulse (.puls), respiration (.resp), ecg (.ecg), and trigger (.log)
    trimmed_size = (physio_array.size // num_channels) * num_channels
    trimmed_array = physio_array[:trimmed_size]
    physio_matrix = trimmed_array.reshape(-1, num_channels)

    # plot raw waveforms to inspect the data validity
    plt.figure(figsize=(12, 6))
    plt.plot(physio_array[:100])  # plot first 100 samples for now
    plt.title("raw physio waveform")
    plt.xlabel("sampling points")
    plt.ylabel("amplitude")
    plt.show()

    # separately for all chans
    for i in range(num_channels):
        plt.figure(figsize=(12, 6))
        plt.plot(physio_matrix[:100, i], label=f"Channel {i+1}")
        plt.legend()
        plt.title(f"channel {i+1}")
        plt.xlabel("sampling points")
        plt.ylabel("amplitude")
        plt.show()

    # save each channel to a separate file
    np.savetxt("/Users/alex/Dropbox/paperwriting/1315/data/QA_new/converted/TR2/physio/physio.puls", physio_matrix[:, 0], fmt='%d')  # pulse
    np.savetxt("/Users/alex/Dropbox/paperwriting/1315/data/QA_new/converted/TR2/physio/physio.resp", physio_matrix[:, 1], fmt='%d')  # resp
    np.savetxt("/Users/alex/Dropbox/paperwriting/1315/data/QA_new/converted/TR2/physio/physio.ecg", physio_matrix[:, 2], fmt='%d')   # ecg
    if num_channels > 3:
        np.savetxt("/Users/alex/Dropbox/paperwriting/1315/data/QA_new/converted/TR2/physio/physio.trigger", physio_matrix[:, 3], fmt='%d')  # trig (hopefully)

    print("done")
    
except KeyError:
    print("physio data not found in the specified tag")
except ValueError as ve:
    print(f"error with the data: {ve}")