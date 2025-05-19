# ChildFER

This repository contains data and scripts as part of the following paper: Huang, S., Pollak S.,& Xie, W. (2025). The Contributions of Spontaneous Discrimination and Conceptual Knowledge to Children's Understanding of Emotion. 

# Background

The folders provided here contain shared code, data, and materials demonstrating the data analysis for Study 1, Study 2, Study 3 and RSA outlined in this paper. Each folder includes the essential materials used for its respective study, accompanied by a ReadMe file to assist you in achieving the desired results. For inquiries regarding the code, data, or materials, please reach out to Wanze Xie at wanze.xie@pku.edu.cn or Shuran Huang at 2201110720@stu.pku.edu.cn

# Example usage for Study 1
Download the Study 1 folder. You should see the following files in your folder:

<img width="403" alt="截屏2025-05-19 17 21 26" src="https://github.com/user-attachments/assets/8f06e236-a6d6-4f68-aa1a-f1e3e854a399" />

Go to the "Data and Materials" folder. 
You will find several .xlsx files summarizing children’s SSVEP data under different preprocessing pipelines and conditions.

<img width="654" alt="截屏2025-05-19 17 22 18" src="https://github.com/user-attachments/assets/55795121-75f1-4cf8-8427-9a5766f23318" />

Next, go to the "Codes" folder. 
Note: Before running any code for Study 1, download and install the EEGLAB and Fieldtrip toolboxes, adding them to the Matlab search path. Our programs were tested with the following Fieldtrip and EEGLAB versions:

fieldtrip-20220707

eeglab2022.1

We tested codes in Study 1 folder on a MacBook Pro laptop that has the following system configuration:

![22121714028328_ pic](https://github.com/happytudouni/ChildFER/assets/167507990/ba030d7d-ecc8-4fa1-bb53-22ef08d4e36c)

To check the responses of participants at the base frequency, open "CheckSingleTrialBaseResponse.m", update it with your local path and run the script. 

We set the "participantnumbers" to 8, "basetype" as happy, and "oddtype" as fear as an example：

<img width="795" alt="截屏2024-04-24 下午2 56 24" src="https://github.com/happytudouni/ChildFER/assets/167507990/15f51b54-1515-481c-85a7-e08724fcf898">

The output results are as follows:

<img width="267" alt="截屏2024-04-24 下午2 56 05" src="https://github.com/happytudouni/ChildFER/assets/167507990/0814e50a-cea5-4c81-9db6-41438dd13306">

The first output is the result of whether the participant's data of first trial in the current condition should be deleted. If the first trial datashould be deleted, then the output of the first result will be the “participantnumber”; otherwise, it will be empty. The same applies to the second output. The program's run time is approximately one minute.


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

# Example usage for Study 2

Download the Study 2 folder. You should see the following files in your folder:

<img width="400" alt="截屏2025-05-19 17 24 17" src="https://github.com/user-attachments/assets/252123e6-12d9-40a2-adcc-9f7dfc5256d2" />

Go to the "Data and Materials" folder. 
The "Data and Materials" directory contains files related to participants’ conceptual representations of emotion words, based on similarity judgments and comparisons with adult reference data.
	•	MDS.sav: SPSS data file containing multidimensional scaling (MDS) results used to derive similarity-based representations of each participant’s conceptual space for emotion words.
	•	average_rating.xlsx: Contains correlation values between each child’s average ratings and the adult reference ratings for each emotion word.
	•	rating_similarity_matrix.xlsx: Includes conceptual similarity scores for each participant, calculated for each emotion pair based on their individual rating patterns.

<img width="628" alt="截屏2025-05-19 17 25 19" src="https://github.com/user-attachments/assets/6fbb39a8-a592-44a1-9ff0-7071cc25badd" />


# Example usage for Study 3

Download the Study 3 folder.You should see the following files in your folder:

<img width="399" alt="截屏2025-05-19 17 26 00" src="https://github.com/user-attachments/assets/280af62a-1a18-44d0-9068-cf1cc8af791a" />

<img width="601" alt="截屏2025-05-19 17 26 09" src="https://github.com/user-attachments/assets/6fbb562e-3fe1-4090-b83e-4162a84be05c" />

<img width="601" alt="截屏2025-05-19 17 26 16" src="https://github.com/user-attachments/assets/77ea6d60-2250-4efb-99f2-e5248a47cd70" />

Go to the "Matching/Data and Materials" folder. The "Data and Materials" folder contains the raw MT data for one participant (raw__imageChoice_0941.csv), as well as the accuracy (MT_acc.xlsx) and similarity scores (MT_similarity_matrix.xlsx) of each participant. 

<img width="843" alt="截屏2025-05-19 17 27 26" src="https://github.com/user-attachments/assets/18e68f1d-b544-4d6a-920f-aab4f5e23f4c" />

Go to the "Sorting/Data and Materials" folder. The “Data and Materials” directory contains files related to participants’ emotion understanding assessed through a sorting task. It includes each participant’s accuracy scores (MT_acc.xlsx) and conceptual similarity scores (MT_similarity_matrix.xlsx).

<img width="843" alt="截屏2025-05-19 17 28 22" src="https://github.com/user-attachments/assets/a1d40fee-d15a-44b0-bff4-d3a3efc64aa3" />

Next, go to the "Matching/Codes" folder. 
Note: Before running any code for Study 3, download and install the MatMouse toolboxes and add them to the Matlab search path. 
We tested codes in Study 3 folder on a MacBook Pro laptop that has the following system configuration:

![22121714028328_ pic](https://github.com/happytudouni/ChildFER/assets/167507990/a398fcea-3b3e-484e-8c91-84e9c2d5a38d)

To calculate the maximum deviation (MD) of the mouse tracking trajectories, open "MTAnalysis_conditionHA_FE.m", adjust it to your local path and run. 
We set the "participantnumber" to 0941 as an example：

<img width="288" alt="截屏2024-04-24 下午3 10 20" src="https://github.com/happytudouni/ChildFER/assets/167507990/9b74a79a-47f2-40a0-8f75-f0a261b0c83a">

The output is MD_error, representing the maximum deviation of the mouse trajectory for this participant under the current condition. The run time is approximately 10 seconds.

<img width="243" alt="截屏2024-04-24 下午3 11 06" src="https://github.com/happytudouni/ChildFER/assets/167507990/13ad5546-4de0-4549-a94a-e99e23de59ff">

For more detailed instructions and required toolboxes, refer to the README.txt file in the Study 3 folder.

# Example usage for RSA

Download the RSA folder.You should see the following files in your folder:

<img width="401" alt="截屏2025-05-19 17 29 37" src="https://github.com/user-attachments/assets/df55248d-6e83-4f5f-81f8-ca5094770f1e" />

Go to the "Data and Materials" folder. 
You will find all the organized data from various tasks needed to construct GEE models.

<img width="647" alt="截屏2025-05-19 17 30 03" src="https://github.com/user-attachments/assets/273105d8-c0bd-41c6-b91a-2fef8868df27" />

Next, go to the "Codes" folder. 
Note: Before running any code for RSA, download and install RStudio. Our programs were tested with the following RStudio version: 

RStudio 2023.06

We tested codes in RSA folder on a MacBook Air laptop that has the following system configuration:

![22111714028328_ pic](https://github.com/happytudouni/ChildFER/assets/167507990/d3b5827f-2a5f-4bee-936c-3999090ed7f1)

To construct GEE models, open "GEE_emotionRSA.R", modify it to your local path and run. 
We set the parameters related to the predictive effect of different variables on sorting as an example:

<img width="401" alt="截屏2024-04-24 15 20 16" src="https://github.com/happytudouni/ChildFER/assets/167507990/558497fc-fdc2-460b-ad5e-b02290168794">

The output provides the predictive effect of different variables on sorting. The run time is approximately 10 seconds.

<img width="464" alt="截屏2024-04-24 15 20 35" src="https://github.com/happytudouni/ChildFER/assets/167507990/2045efc2-b61d-4547-9e84-ed8d4a47da42">

We set the interaction between FPVS and age as a parameter example to predict sorting:

<img width="400" alt="截屏2024-04-24 16 16 03" src="https://github.com/happytudouni/ChildFER/assets/167507990/c5ced45a-9bd8-4521-aa41-27e42f090b74">

The output provides the predictive effect of FPVS on sorting across different age groups. The run time is approximately 10 seconds.

<img width="575" alt="截屏2024-04-24 15 22 43" src="https://github.com/happytudouni/ChildFER/assets/167507990/40d1156e-517d-4567-98b7-8aefc0d1a5a7">

For more detailed instructions and required toolboxes, refer to the README.txt file in the RSA folder.


