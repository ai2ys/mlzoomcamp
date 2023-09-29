import pandas as pd
import numpy as np
import urllib.request
import os
from pathlib import Path

def question_1():
    print("Question 1: What's the version of Pandas that you installed?")
    print(f"Answer: {pd.__version__}")

def getting_the_data() -> str:
    """Downloading the required data CSV file if not already downloaded.
    Returns:
        str: The local file path
    """
    current_script_dir = os.path.dirname(os.path.abspath(__file__))
    url_data = "https://raw.githubusercontent.com/alexeygrigorev/datasets/master/housing.csv"
    output_path = os.path.join(current_script_dir, Path(url_data).name)
    # only download if neccessary
    if not os.path.exists(output_path):
        urllib.request.urlretrieve(
            url_data,
            output_path
        )
    return output_path

def question_2(df:pd.DataFrame):
    print("Question2: How many columns are in the dataset?")
    
    n_columns = df.columns.size
    print(f"Answer: {n_columns}")

def question_3(df:pd.DataFrame):
    print("Question 3: Which columns in the dataset have missing values?")

    columns_with_missing_values = df.columns[df.isnull().any()].values
    print(f"Answer: {columns_with_missing_values}")
    
def question_4(df:pd.DataFrame):
    print("Question 4: How many unique values does the ocean_proximity column have?")
    print(f"Ocean proximity values: {df['ocean_proximity'].unique()}")
    num_unique_values = df['ocean_proximity'].unique().size
    print(f"Answer: {num_unique_values}")
    
def question_5(df:pd.DataFrame):
    print("Question 5: What's the average value of the median_house_value for the houses located near the bay?")
    indices_near_bay = df['ocean_proximity'] == 'NEAR BAY'
    average_value = df.loc[indices_near_bay, 'median_house_value'].mean()
    print(f"Answer: {average_value:.0f}")

def question_6(df:pd.DataFrame):
    print("Question 6")
    print("\t6.1: Calculate the average of total_bedrooms column in the dataset.")
    avg_total_bedrooms = df['total_bedrooms'].mean()
    print(f"\tAnswer: {avg_total_bedrooms}")

    print("\t6.2: Use the fillna method to fill the missing values in total_bedrooms with the mean value from the previous step.")
    #print(f"Any null values: {df['total_bedrooms'].isnull().values.any()}")
    df.fillna(value={'total_bedrooms': avg_total_bedrooms}, inplace=True)
    print(f"\tFilling missing values using: {avg_total_bedrooms}")

    print("\t6.3: Now, calculate the average of total_bedrooms again.")
    avg_total_bedrooms_fillna = df['total_bedrooms'].mean()
    print(f"\tAnswer: {avg_total_bedrooms_fillna}")
    
    print("\t6.4: Has it changed? Hint: take into account only 3 digits after the decimal point.")
    diff = int((avg_total_bedrooms - avg_total_bedrooms_fillna)*1e3)
    print(f"\tAnswer: {'yes' if diff != 0 else 'no'}")
    
def question_7(df:pd.DataFrame):
    print("Question 7")
    print("\t7.1 Select all the options located on islands.")
    indices_location_island = df['ocean_proximity'] == 'ISLAND'
    df_select = df.loc[indices_location_island, :]
    print(f"\tNum selected rows: {len(df_select)}")

    print("\t7.2 Select only columns housing_median_age, total_rooms, total_bedrooms.")
    df_select = df_select[['housing_median_age', 'total_rooms', 'total_bedrooms']]
    print(f"\tShape of selection: {df_select.shape}")

    print("\t7.3 Get the underlying NumPy array. Let's call it X.")
    x = df_select.to_numpy()
    x_str = np.array2string(x, separator=' ', prefix='            ')
    print(f"\tX = {x_str}")

    print("\t7.4 Compute matrix-matrix multiplication between the transpose of X and X. To get the transpose, use X.T. Let's call the result XTX.")
    xtx = x.T @ x
    xtx_str = np.array2string(xtx, separator=' ', prefix='            ')
    print(f"\tX = {xtx_str}")

    print("\t7.5 Compute the inverse of XTX.")
    xtx_inv = np.linalg.inv(xtx)
    xtx_inv_str = np.array2string(xtx_inv, separator=' ', prefix='            ')
    print(f"\tX = {xtx_inv_str}")

    print("\t7.6 Create an array y with values [950, 1300, 800, 1000, 1300].")
    y = np.array([950, 1300, 800, 1000, 1300])
    y_str = np.array2string(y, separator=' ', prefix='')
    print(f"\ty = {y_str}")

    print("\t7.7 Multiply the inverse of XTX with the transpose of X, and then multiply the result by y. Call the result w.")
    w = (xtx_inv @ x.T).dot(y)
    w_str = np.array2string(w, separator=' ', prefix='            ')
    print(f"\tw = {w_str}")

    print("\t7.8 What's the value of the last element of w?")
    print(f"\t{w[-1]}")

if __name__ == '__main__':
    str_sep = "----------------"
    print("Homework 01-intro")
    
    print(str_sep)
    question_1()

    data_file_path = getting_the_data()
    df = pd.read_csv(data_file_path)

    print(str_sep)
    question_2(df)
    
    print(str_sep)
    question_3(df)

    print(str_sep)
    question_4(df)

    print(str_sep)
    question_5(df)

    print(str_sep)
    question_6(df)

    print(str_sep)
    question_7(df)

    