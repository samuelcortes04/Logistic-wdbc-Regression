# Breast Cancer Tumor Classification using Logistic Regression (R)

This project implements a **Logistic Regression model in R** to classify breast cancer tumors as **benign** or **malignant** using clinical diagnostic features.

The objective is to apply statistical modeling techniques to a real-world medical dataset and evaluate model performance in a binary classification setting.

---

## Dataset

The dataset used in this project is publicly available on Kaggle:

Breast Cancer Wisconsin Dataset  
https://archive.ics.uci.edu/dataset/17/breast+cancer+wisconsin+diagnostic 

Please download the dataset and place it in the project directory before running the scripts.

---

## Project Structure

breast-cancer-logistic-regression  
├── EDA.R  
├── logistic_model.R  
└── README.md  

- **EDA.R** → Exploratory Data Analysis, data cleaning, summary statistics, and visualizations.  
- **logistic_model.R** → Logistic regression model implementation, assumption checks, interpretation of coefficients, and performance evaluation.  

---

## Exploratory Data Analysis (EDA)

The exploratory analysis includes:

- Summary statistics of predictors
- Missing value verification
- Distribution analysis of features
- Correlation analysis
- Class balance inspection (benign vs malignant tumors)

---

## Logistic Regression Model

The modeling process includes:

- Fitting a binary logistic regression model
- Interpretation of model coefficients
- Statistical significance testing
- Evaluation of model assumptions
- Probability estimation and tumor classification

---

## Model Evaluation

Model performance is evaluated using:

- Confusion Matrix
- Accuracy
- Sensitivity (Recall)
- Specificity
- ROC Curve and AUC

---

## Academic Context

This project was developed as part of academic coursework in statistics and predictive modeling.  
Its purpose is to demonstrate understanding of logistic regression theory, statistical inference, and model evaluation techniques.

---

## Disclaimer

This project is intended for educational and portfolio purposes only.  
It is not designed for real-world medical diagnosis or clinical decision-making
