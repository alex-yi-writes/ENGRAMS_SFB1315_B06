#!/usr/bin/env python
import os
import scipy.io as sio
from nipype import Node, Workflow, IdentityInterface, Function
from nipype.interfaces import spm
from nipype.interfaces.io import SelectFiles, DataSink

res_dir = '/Volumes/korokdorf/ENGRAMS/analyses/'
src_dir = '/Volumes/korokdorf/ENGRAMS/preproc/'
scr_dir = '/Volumes/korokdorf/ENGRAMS/scripts/'

subs = ['sub-107v2s2', 'sub-108v1s2'] # prev subjs done

so_mat = sio.loadmat(os.path.join(scr_dir, 'ENGRAMS_SliceOrder.mat'))
so_arr = so_mat['ENGRAMS_SliceOrder'].flatten().tolist()

tr = 2.0
nsl = 96
rfsl = 0

def decompress(in_gz):
    import gzip, shutil
    out_path = in_gz.replace('.gz', '')
    with gzip.open(in_gz, 'rb') as fin, open(out_path, 'wb') as fout:
        shutil.copyfileobj(fin, fout)
    return out_path

def pick_first(vol_list):
    return vol_list[0]

dfx = Node(Function(input_names=['gz_file'],
                            output_names=['out_file'],
                            function=decompress),
                   name='dfx')
dph = Node(Function(input_names=['gz_file'],
                             output_names=['out_file'],
                             function=decompress),
                    name='dph')
dmg = Node(Function(input_names=['gz_file'],
                           output_names=['out_file'],
                           function=decompress),
                  name='dmg')

sub_src = Node(IdentityInterface(fields=['subject_id']), name='sub_src')
sub_src.iterables = [('subject_id', subs)]

tpl = {
    'func': os.path.join(src_dir, '{subject_id}', 'func', '{subject_id}_task-sale_run-01_bold.nii.gz'),
    'fmap_phase': os.path.join(src_dir, '{subject_id}', 'fmap', '{subject_id}_phasediff.nii.gz'),
    'fmap_magnitude': os.path.join(src_dir, '{subject_id}', 'fmap', '{subject_id}_magnitude1.nii.gz')
}
file_sel = Node(SelectFiles(tpl, base_directory=''), name='file_sel')

r_n = Node(spm.Realign(), name='r_n')
r_n.inputs.register_to_mean = False
r_n.inputs.quality = 0.9
r_n.inputs.separation = 1
r_n.inputs.fwhm = 2
r_n.inputs.interp = 4
r_n.inputs.wrap = [0, 0, 0]

first_vol = Node(Function(input_names=['file_list'],
                          output_names=['first_file'],
                          function=pick_first),
                 name='first_vol')

fm_n = Node(spm.FieldMap(), name='fm_n')
fm_n.inputs.jobtype = 'calculatevdm'
fm_n.inputs.matchvdm = True
fm_n.inputs.sessname = 'session'
fm_n.inputs.matchanat = False
fm_n.inputs.echo_times = (3.06, 4.08)
fm_n.inputs.blip_direction = -1
fm_n.inputs.total_readout_time = 55.2529

u_n = Node(spm.RealignUnwarp(), name='u_n')
u_n.inputs.register_to_mean = True
u_n.inputs.quality = 0.9
u_n.inputs.separation = 1
u_n.inputs.fwhm = 2
u_n.inputs.interp = 4
u_n.inputs.wrap = [0, 0, 0]
u_n.inputs.out_prefix = 'u'

st_n = Node(spm.SliceTiming(), name='st_n')
st_n.inputs.nsl = nsl
st_n.inputs.time_repetition = tr
st_n.inputs.time_acquisition = tr - (tr / nsl)
st_n.inputs.slice_order = so_arr
st_n.inputs.ref_slice = rfsl
st_n.inputs.out_prefix = 'a'

data_sink = Node(DataSink(base_directory=res_dir), name='data_sink')

proc_wf = Workflow(name='proc_wf')
proc_wf.base_dir = os.path.join(res_dir, "workingdir")

proc_wf.connect([
    (sub_src, file_sel, [('subject_id', 'subject_id')]),
    (file_sel, dfx, [('func', 'gz_file')]),
    (dfx, r_n, [('out_file', 'in_files')]),
    (r_n, first_vol, [('realigned_files', 'file_list')]),
    (file_sel, dph, [('fmap_phase', 'gz_file')]),
    (file_sel, dmg, [('fmap_magnitude', 'gz_file')]),
    (dph, fm_n, [('out_file', 'phase_file')]),
    (dmg, fm_n, [('out_file', 'magnitude_file')]),
    (first_vol, fm_n, [('first_file', 'epi_file')]),
    (r_n, u_n, [('realigned_files', 'in_files')]),
    (fm_n, u_n, [('vdm', 'phase_map')]),
    (u_n, st_n, [('realigned_unwarped_files', 'in_files')]),
    (st_n, data_sink, [('timecorrected_files', 'slice_timing.@files')]),
    (r_n, data_sink, [('realigned_files', 'realign.@files')]),
    (fm_n, data_sink, [('vdm', 'fieldmap.@vdm')]),
    (u_n, data_sink, [('realigned_unwarped_files', 'unwarp.@files')]),
])

# wrap the call to run the workflow inside a block
if __name__ == '__main__':
    from multiprocessing import freeze_support
    freeze_support()
    proc_wf.run('MultiProc', plugin_args={'n_procs': 2})
