Background
============
The "Data and Materials" folder contains the raw MT data for one participant (raw__imageChoice_0941.csv), as well as the accuracy (MT_acc.xlsx) and similarity scores (MT_similarity_matrix.xlsx) of each participant. The "Codes" directory includes files for calculating the maximum deviation of the participant's mouse trajectories under the happy vs. fear condition(MTAnalysis_conditionHA_FE.m).

Required Software
=============
Below is a list of software required to run the files in the "Codes" directory, along with links to their download pages and user guides:

- Matlab R2020a: https://www.mathworks.com/help/install
- MatMouse: https://github.com/krasvas/MatMouse
- SPSS 26.0: https://www.ibm.com/products/spss-statistics

Example Usage
=============
- MTAnalysis_conditionHA_FE.m: This program calculates the maximum deviation (MD) of the mouse tracking trajectories for the current participant under the happy vs. fear condition. You need to modify 'folderBase' as needed to run. 'participantnumber' is the suffix of the data name in the "raw__imageChoice_0941.csv". The program outputs 'MD_error', which is the value of the MD. If you need to calculate the MD under other contrast conditions, simply modify the corresponding conditions accordingly.

- Additionally, the process for analyzing the MT task in SPSS is not provided here. This analysis does not require coding and can be completed by navigating through the SPSS menu to “Analyze - General Linear Model - Repeated Measures”.

