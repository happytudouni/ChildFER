# ChildFER

This repository contains data and scripts as part of the following paper: Huang, S. & Xie, W. (under review). From seeing to understanding: Unravealing perceptual and conceptual contributions to children's facial expression recognition. 

# Background

The shared code, data, and materials in the current folders are provided to demonstrate the data analysis processes for Study I, Study II, and Study III in this paper. Each folder contains the necessary materials required for each study, along with a detailed ReadMe file to guide you in achieving the desired outcomes. For any queries regarding the code, data or materials, please contact wanze.xie@pku.edu.cn or 2201110720@stu.pku.edu.cn.

# Example usage for Study I
Download the Study I folder. You should see the following files in your folder:

<img width="404" alt="截屏2024-04-24 14 32 43" src="https://github.com/happytudouni/ChildFER/assets/167507990/c762eedf-c51a-47f5-9ef0-6dd7a2efcd93">

Go to the "Data and Materials" folder. 
You will find preprocessed EEG data for one participant (Expt 6 Participant number 8 SSVEP_BS_*_ODD_*_emotion_ica0.mat), along with selected ROI information (hgsn2clusters_ROI.mat), details of 128 channels (hgsn128chanlocs.mat), information on frequency bins (EEG_freq.mat), and the responses of all participants after preprocessing and segmenting (Info*.mat). Please download these files to your local directory.

<img width="589" alt="截屏2024-04-24 15 58 27" src="https://github.com/happytudouni/ChildFER/assets/167507990/814379d8-4c6e-4ed4-b1ba-05dca9d8fe90">

Next, go to the "Codes" folder. 
Note: Before running any code for Study I, download and install the EEGLAB and Fieldtrip toolboxes, adding them to the Matlab search path. Our programs were tested with the following Fieldtrip and EEGLAB versions:

fieldtrip-20220707

eeglab2022.1

We tested codes in Study I folder on a MacBook Pro laptop that has the following system configuration:

<img width="515" alt="截屏2024-04-24 下午2 56 39" src="https://github.com/happytudouni/ChildFER/assets/167507990/973e8148-33c9-46d4-b596-c58ce5ce726a">

To check the responses of participants at the base frequency, open "CheckSingleTrialBaseResponse.m", update it with your local path and run the script. 

We set the "participantnumbers" to 8, "basetype" as happy, and "oddtype" as fear as an example：

<img width="795" alt="截屏2024-04-24 下午2 56 24" src="https://github.com/happytudouni/ChildFER/assets/167507990/15f51b54-1515-481c-85a7-e08724fcf898">

The output results are as follows:

<img width="267" alt="截屏2024-04-24 下午2 56 05" src="https://github.com/happytudouni/ChildFER/assets/167507990/0814e50a-cea5-4c81-9db6-41438dd13306">

If the first trial data under this condition should be deleted, then the output of the first result will be the “participantnumber”; otherwise, it will be empty. The same applies to the second output. The program's run time is approximately one minute.


To visually inspect the responses of participants at both base and odd frequencies, open "PlotFPVS.m", modify it to your local path and run. 
We set the "participantnumber" to 8, "basetype" as happy, and "oddtype" as fear as an example：

<img width="782" alt="截屏2024-04-24 下午2 59 42" src="https://github.com/happytudouni/ChildFER/assets/167507990/5046a4d8-ebf4-4999-89ae-ea2c495629eb">

The outputs are three figures: 

<img width="1187" alt="截屏2024-04-24 下午3 02 23" src="https://github.com/happytudouni/ChildFER/assets/167507990/131c8ed3-4b58-4b10-a54e-afb1b6be1837">

Figure 1 shows the SNR graph at different frequencies for this participant in this condition; Figure 2 shows the response at the odd frequency; Figure 3 shows the response at the base frequency. The run time is approximately one minute.


To output the SNR values of all participants at the odd frequency, open "OddReaction.m", adjust it to your local path and run. 
We set the "basetype" as happy, and "oddtype" as fear as an example：

<img width="545" alt="截屏2024-04-24 下午4 32 13" src="https://github.com/happytudouni/ChildFER/assets/167507990/7fb95780-a6be-4425-ae8c-af1f82342eea">

the output result is a combined_matrix that includes the SNR responses at different odd frequencies for each participant:

<img width="925" alt="截屏2024-04-24 下午3 06 44" src="https://github.com/happytudouni/ChildFER/assets/167507990/9f87fb21-83f4-410e-b05f-eefa4bc34d92">

The run time is approximately 10 seconds.

For more detailed instructions and required toolboxes, refer to the README.txt file in the Study I folder.

# Example usage for Study II

Download the Study II folder. You should see the following files in your folder:

<img width="404" alt="截屏2024-04-24 14 33 14" src="https://github.com/happytudouni/ChildFER/assets/167507990/6ea89270-8f79-41ad-8c20-ff93bead087b">

Go to the "Data and Materials" folder. 
You will find the raw MT data for one participant (raw__imageChoice_0941.csv) and the correlation values between every pair of emotions from all participants' rating tasks (rating.sav).

<img width="400" alt="截屏2024-04-24 16 10 41" src="https://github.com/happytudouni/ChildFER/assets/167507990/3437a7e7-113b-4cc5-b913-f5c81a6e8f84">

Next, go to the "Codes" folder. 
Note: Before running any code for Study II, download and install the MatMouse toolboxes and add them to the Matlab search path. 
We tested codes in Study II folder on a MacBook Pro laptop that has the following system configuration:

<img width="515" alt="截屏2024-04-24 下午2 56 39" src="https://github.com/happytudouni/ChildFER/assets/167507990/344a6af9-eaea-4e7b-bbe8-25475f3c95cd">

To calculate the maximum deviation (MD) of the mouse tracking trajectories, open "MTAnalysis_conditionHA_FE.m", adjust it to your local path and run. 
We set the "participantnumber" to 0941 as an example：

<img width="288" alt="截屏2024-04-24 下午3 10 20" src="https://github.com/happytudouni/ChildFER/assets/167507990/9b74a79a-47f2-40a0-8f75-f0a261b0c83a">

The output is MD_error, representing the maximum deviation of the mouse trajectory for this participant under the current condition. The run time is approximately 10 seconds.

<img width="243" alt="截屏2024-04-24 下午3 11 06" src="https://github.com/happytudouni/ChildFER/assets/167507990/13ad5546-4de0-4549-a94a-e99e23de59ff">

For more detailed instructions and required toolboxes, refer to the README.txt file in the Study II folder.

# Example usage for Study III

Download the Study III folder.You should see the following files in your folder:

<img width="404" alt="截屏2024-04-24 14 33 43" src="https://github.com/happytudouni/ChildFER/assets/167507990/ab1ac790-ab4e-4505-ad45-5269587244e4">

Go to the "Data and Materials" folder. 
You will find all the organized data from various tasks needed to construct GEE models (GEE_final(children)_ROIall.xlsx), as well as the similarity values between every pair of emotions from all participants' sorting & mouse tracking tasks (sorting & MT.sav).

<img width="400" alt="截屏2024-04-24 16 15 10" src="https://github.com/happytudouni/ChildFER/assets/167507990/f8ab8eab-98c7-453d-bfa1-1d141c8e2fff">

Next, go to the "Codes" folder. 
Note: Before running any code for Study III, download and install RStudio. Our programs were tested with the following RStudio version: 

RStudio 2023.06

We tested codes in Study III folder on a MacBook Pro laptop that has the following system configuration:

<img width="223" alt="截屏2024-04-24 15 13 53" src="https://github.com/happytudouni/ChildFER/assets/167507990/ce93352c-c45d-4451-a563-ce824e43968e">

To construct GEE models, open "GEE_emotionRSA.R", modify it to your local path and run. 
We set the parameters related to the predictive effect of different variables on sorting as an example:

<img width="401" alt="截屏2024-04-24 15 20 16" src="https://github.com/happytudouni/ChildFER/assets/167507990/558497fc-fdc2-460b-ad5e-b02290168794">

The output provides the predictive effect of different variables on sorting. The run time is approximately 10 seconds.

<img width="464" alt="截屏2024-04-24 15 20 35" src="https://github.com/happytudouni/ChildFER/assets/167507990/2045efc2-b61d-4547-9e84-ed8d4a47da42">

We set the interaction between FPVS and age as a parameter example to predict sorting:

<img width="400" alt="截屏2024-04-24 16 16 03" src="https://github.com/happytudouni/ChildFER/assets/167507990/c5ced45a-9bd8-4521-aa41-27e42f090b74">

The output provides the predictive effect of FPVS on sorting across different age groups. The run time is approximately 10 seconds.

<img width="575" alt="截屏2024-04-24 15 22 43" src="https://github.com/happytudouni/ChildFER/assets/167507990/40d1156e-517d-4567-98b7-8aefc0d1a5a7">

For more detailed instructions and required toolboxes, refer to the README.txt file in the Study III folder.


