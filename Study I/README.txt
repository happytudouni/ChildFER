Background
============
The "Data and Materials" folder contains preprocessed EEG data for one participant (Expt 6 Participant number 8 SSVEP_BS_*_ODD_*_emotion_ica0.mat), along with selected ROI information (hgsn2clusters_ROI.mat), details of 128 channels (hgsn128chanlocs.mat), information of frequency bins(EEG_freq.mat), as well as the responses of all participants after preprocessing and segmenting(Info*.mat). The "Codes" directory includes files for checking responses at the base frequency (CheckSingleTrialBaseResponse.m), for plotting the reactions of each participant under different conditions(PlotFPVS.m), as well as calculating the snr response values of all participants at the odd frequency (OddReaction.m).

Required Software
=============
Below is a list of software required to run the files in the "Codes" directory, along with links to their download pages and user guides:

- Matlab R2020a: https://www.mathworks.com/help/install
- Psychotoolbox-3: http://psychtoolbox.org/download.html
- EEGLAB: https://sccn.ucsd.edu/eeglab/download.php
- ERPLAB: https://github.com/lucklab/erplab

Example Usage
=============
- CheckSingleTrialBaseResponse.m: This file is used to check the responses of participants at the base frequency. It provides the response of each participant at the base frequencies (6Hz, 12Hz, 18Hz, 24Hz) for every trial. To run this program, you need to modify the 'folderbase' and 'SegmentAverageFiles' paths, in addition to adjusting the experimental conditions (i.e., 'Basetype' and 'Oddtype'). The output of this program indicates whether the data from the two trials for the current condition of the participant should be deleted.

- PlotFPVS.m: This file is for visually inspecting the responses of participants at both base and odd frequencies. Before running, you need to modify the path of folderBase. You can also modify basetype and oddtype as needed.

- OddReaction.m: This program imports all "Info*.mat" files and outputs the snr values of all participants at the odd frequency. Before running, you need to modify the path of folderBase. You can also modify basetype and oddtype as needed.



