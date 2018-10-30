---
title: "CodeBook - Getting and Cleaning Data"
output: html_document
---

<br/>
This code book provides an overview of the variables analyzed for the 'Getting and Cleaning Data' course assignment.
<br/>
<br/>
The resulting data can be found in the `tidydata.txt` file.


---

## Identifiers

These identifiers are used to refer to the subject number, the training or test set and the activity.

* `SubjNr` - The subject specific number
* `Set` - Identifies the training or test data
* `Activity` - Describes the kind of activity performed by the subject

## Measurement Variables

These variables were used to identify different kinds of measurements.
Every measurement is specific with regard to its unit, axis (x, y, z) and statistic (mean & std).
The field `Measurement_Type` containts all the following measurements:

* `FrequencyBodyAccelerometer-mean()-X`           
* `FrequencyBodyAccelerometer-mean()-Y`           
* `FrequencyBodyAccelerometer-mean()-Z`         
* `FrequencyBodyAccelerometer-std()-X`            
* `FrequencyBodyAccelerometer-std()-Y`            
* `FrequencyBodyAccelerometer-std()-Z`            
* `FrequencyBodyAccelerometerJerk-mean()-X`       
* `FrequencyBodyAccelerometerJerk-mean()-Y`      
* `FrequencyBodyAccelerometerJerk-mean()-Z`       
* `FrequencyBodyAccelerometerJerk-std()-X`        
* `FrequencyBodyAccelerometerJerk-std()-Y`       
* `FrequencyBodyAccelerometerJerk-std()-Z`        
* `FrequencyBodyAccelerometerJerkMagnitude-mean()`
* `FrequencyBodyAccelerometerJerkMagnitude-std()` 
* `FrequencyBodyAccelerometerMagnitude-mean()`   
* `FrequencyBodyAccelerometerMagnitude-std()`     
* `FrequencyBodyGyroscope-mean()-X`               
* `FrequencyBodyGyroscope-mean()-Y`              
* `FrequencyBodyGyroscope-mean()-Z`              
* `FrequencyBodyGyroscope-std()-X`               
* `FrequencyBodyGyroscope-std()-Y`              
* `FrequencyBodyGyroscope-std()-Z`               
* `FrequencyBodyGyroscopeJerkMagnitude-mean()`   
* `FrequencyBodyGyroscopeJerkMagnitude-std()`    
* `FrequencyBodyGyroscopeMagnitude-mean()`        
* `FrequencyBodyGyroscopeMagnitude-std()`         
* `TimeBodyAccelerometer-mean()-X`                
* `TimeBodyAccelerometer-mean()-Y`                
* `TimeBodyAccelerometer-mean()-Z`               
* `TimeBodyAccelerometer-std()-X`                 
* `TimeBodyAccelerometer-std()-Y`                
* `TimeBodyAccelerometer-std()-Z`                 
* `TimeBodyAccelerometerJerk-mean()-X`            
* `TimeBodyAccelerometerJerk-mean()-Y`            
* `TimeBodyAccelerometerJerk-mean()-Z`            
* `TimeBodyAccelerometerJerk-std()-X`             
* `TimeBodyAccelerometerJerk-std()-Y`            
* `TimeBodyAccelerometerJerk-std()-Z`             
* `TimeBodyAccelerometerJerkMagnitude-mean()`     
* `TimeBodyAccelerometerJerkMagnitude-std()`     
* `TimeBodyAccelerometerMagnitude-mean()`         
* `TimeBodyAccelerometerMagnitude-std()`          
* `TimeBodyGyroscope-mean()-X`                    
* `TimeBodyGyroscope-mean()-Y`                    
* `TimeBodyGyroscope-mean()-Z`                    
* `TimeBodyGyroscope-std()-X`                    
* `TimeBodyGyroscope-std()-Y`                     
* `TimeBodyGyroscope-std()-Z`                     
* `TimeBodyGyroscopeJerk-mean()-X`                
* `TimeBodyGyroscopeJerk-mean()-Y`                
* `TimeBodyGyroscopeJerk-mean()-Z`                
* `TimeBodyGyroscopeJerk-std()-X`                 
* `TimeBodyGyroscopeJerk-std()-Y`                 
* `TimeBodyGyroscopeJerk-std()-Z`                
* `TimeBodyGyroscopeJerkMagnitude-mean()`         
* `TimeBodyGyroscopeJerkMagnitude-std()`          
* `TimeBodyGyroscopeMagnitude-mean()`             
* `TimeBodyGyroscopeMagnitude-std()`              
* `TimeGravityAccelerometer-mean()-X`             
* `TimeGravityAccelerometer-mean()-Y`            
* `TimeGravityAccelerometer-mean()-Z`             
* `TimeGravityAccelerometer-std()-X`              
* `TimeGravityAccelerometer-std()-Y`              
* `TimeGravityAccelerometer-std()-Z`              
* `TimeGravityAccelerometerMagnitude-mean()`      
* `TimeGravityAccelerometerMagnitude-std()`

## Activity Labels

The following activities were involded for each measurement and can be found in the field `Activity`.
The activity names are self-descriptive. 

* `LAYING` 
* `SITTING` 
* `STANDING`
* `WALKING`
* `WALKING_DOWNSTAIRS`
* `WALKING_UPSTAIRS`

## Measurement Result

The result of each unique combination of measurements is indicated by the field `Measurement_Mean` and 
reflects either the average of means or standard deviations.