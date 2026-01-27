#!/bin/bash

cd /mnt/work/yyi/ENGRAMS/scripts/
for I in sub105_v1s1 sub102_v1s1 sub104_v1s1 sub104_v1s2 sub104_v2s2 sub105_v1s2 sub105_v2s1 sub105_v2s2 sub106_v1s1 sub106_v1s2 sub106_v2s1 sub106_v2s2 sub107_v1s1 sub107_v1s2 sub107_v2s2 
do
	chmod a+x /mnt/work/yyi/ENGRAMS/scripts/ENGRAMS_DWIpreproc_test_vHydra_${I}.sh
	/mnt/work/yyi/ENGRAMS/scripts/ENGRAMS_DWIpreproc_test_vHydra_${I}.sh
	#qsub -l h_rt=168:00:00,h_vmem=8G,mem_free=8G -q work.q -pe smp 1 -N pet${I} -wd /mnt/work/yyi/ -e /mnt/work/yyi/logs/ /mnt/work/yyi/scripts/mrpetsingle${I}.sh
done
