# NPSC: The Matlab Online Bayesian Non-Parametric Stream Classification Package
![Build Status](https://img.shields.io/teamcity/codebetter/bt428.svg)
![License](https://img.shields.io/badge/license-BSD-blue.svg)

NPSC is a Matlab software library for online stream classification. It aims to provide flexible modeling, learning, and inference of general dependent nonparametric models for classifying stream data with non-stationary generating process to capture the concept drift occur in large volume of various stream data arising from social networks, financial trading, etc.

## Prerequisites

- Matlab version R2011a or later
- [lightspeed](http://research.microsoft.com/en-us/downloads/db1653f0-1308-4b45-b358-d8e1011385a0/default.aspx)

## Features

-  A coherent generative model for stream classification

- The model manages its complexity by adapting the size of the latent space and the number of classifiers over time.

- Handling concept drift by adapting data-concept association without unnecessary i.i.d. assumption among data of a batch

- An online algorithm for inference on the non-conjugate non-parametric time-dependent models.

## Running The Code

- Unzip the lightspeed library and put it in the root folder of the project

- Run the install script

- Set the Dataset in the "Main" Script

- Run the Main script


The results will be saved under the folder Results

## Citation 

In case of using the code, please cite the following paper:

Hosseini, S.A., Rabiee, H.R., Hafez, H. and Soltani-Farani, A., 2014, September. Classifying a Stream of Infinite Concepts: A Bayesian Non-parametric Approach. In Joint European Conference on Machine Learning and Knowledge Discovery in Databases (pp. 1-16). Springer Berlin Heidelberg.