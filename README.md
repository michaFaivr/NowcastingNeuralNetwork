# NowcastingNeuralNetwork
Results for a confidential (EU project) nowcating research automated detection for risk areas to commercial flights
Report High IWC detection scheme evaluation against in situ measurements 
Project Number 
ACP2-GA-2012-314314  
Project Title 
High Altitude Ice Crystals 
Abstract1 
To write. 
Due date 
01/01/2014 
Actual submission date 
DD/MM/YYYY 
Nature2 
R + O 
Document identifier 
HAIC_WP33_D33.3_R0.1.doc 

README HAIC Laboratoire d'Etudes du Rayonnement et de la Matière en Astrophysique   (LERMA) de l'Observatoire de Paris-Meudon

# Project Title : Nowcasting tool for automated detection of ice crystal areas

High Altitude Ice Crystals is a large scale 5-year program which aimed at improving aircraft safety when flying in mixed phase and glaciated icing conditions. 

Coordinated by AIRBUS, and partially funded by the European Commission, the HAIC Consortium brings together 34 partners from 11 European countries and 5 International partners from Australia, Canada and the United States.

The total budget of the project is 22.8 M€, partially funded by the European Commission.
Starting from August 2012, the project has been completed up to TRL6 in Spring 2017.

# Purpose of my study :
To Design, Implement and Validate a supervised machine learning model for predicting risk areas from Cloud-top radiometric properties as measured by geostationary satellites to High Ice Water Contents (HIWC). HIWC is indeed associated with freezing conditions which are a potential threat for airplane engines. 
HIWC are hardly detected by on-board 3Ghz radars and sensors. Therefore, this study is an effort for developing research nowcasting tool helping to detect these paches. 


# Data : Darwin (North Australia) January – February 2014
For compliance to confidentiality clause, Datasets are not provided here.

# Inputs :
1) MTSAT 3-VIS (0,65µm), NIR channels (6.8, 10.8 and 12.05 µm) (passive optics)
2) RASTA : airborne radar 95GHz for nadir reflectivity measurements (active optics) of Ice Water Content (IWC, g/m3).

	The radiometric 3-channels data helps to characterize the top part of convective cells, when radar reflectitivity provides vertical profiles in terms of ice/water mixed phases.
In the Data preparation, IWC(Z) are converted into Ice Water Path integrated for altitude Z higher than 9 km, being therefore located in the crusing altitude.

# Outputs : 
1) Maps 30x30° lat-lon on areas located within the overflown region during the Darwin's campaign
Horizontal resolution of the integrated crystal density = MTSAT Horizontal resolution = 1.25 km
2) Heatmaps of IWP vs radiometric Brightness Temperatures for each channel 

# Approach :
One consider Brightness temperature (or radiances) measured by MSAT 3-channel radiometer as proxies or potential explanatory variables associated with (H)IWP which is the response to be predicted.

Data are well suited for Neural Network approach as Data matrix is dense (not sparse) and data are homogeneous in types and ranges.
In addition, non linearities or discontinuities in the radiance-IWP would be likely to be handled by a multi-layer Neural network.  

# Model :
Feedforward Neural Network with K layers ; K being the number of Hidden Layers.
HIWC values are discretized into uniformly distributed ranges and the problem corresponds to a multi-classes classification.

# Algorithm : scaled conjugated gradient (SCG)

Hyperparameter tuning :
K number of → K = 3
Number of neurones : H1:11 ; H2:9 ; H3:7


# Data Preparation/Feature Engineering
radiance (W/m²/sr) → Log10(radiance) : somehow denoise the data
outlier filtering : 


# Model Assessment :
Validation by dataset splitting : 70% training, 15% testing and 15% validation
ROC/AUC
Comparison with visible images for consistency assessment


# Results 
Properly Tuned Model is therefore trained again on the full dataset available.

# Following results were obtained :
15+ examples (not exhaustive here) featuring predicted IWC maps are provided (.eps files)
corresponding visible channel maps

 
