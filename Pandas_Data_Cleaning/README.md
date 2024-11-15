# Customer Call List Data Cleaning

### Why Data Cleaning is Important?
Data cleaning and standardization are critical for ensuring accurate results in any analysis. Without clean and consistent data, we may end up with incorrect results, which can lead to poor decision-making.

![4469937](https://github.com/user-attachments/assets/7ee847d7-dd3d-4721-a279-b06e1c916661)

### Data Cleaning Goals:
In this project, I worked with a customer call list dataset to identify and resolve data quality issues. I simplified the data, addressed inconsistencies, and standardized the format to ensure consistency across the dataset.

### Data Cleaning Steps Used:

- Removing Duplicate Rows
- Dropping Irrelevant Columns
- Standardizing Text Format
- Formating Phone Numbers
- Spliting Address Column
- Standardizing Yes/No Columns
- Handling Missing Values
- Filteingr Out Unwanted Rows
- Resetting the DataFrame Index

### From This:
![Unclean Data](https://github.com/user-attachments/assets/d5d6b287-4ad7-484a-8c1c-3f1073df92d0)

### To This:
![Clean Data](https://github.com/user-attachments/assets/c2e6345d-4016-4294-9b8c-5dade22fa6d1)

### Guide to Files:

| File/Folder                          | Description                                                                 |
|--------------------------------------|-----------------------------------------------------------------------------|
| **input_file**                       | Folder containing the raw data file.                                         |
| **customer_call_list.xlsx**          | Input file with the original customer call list data that needs cleaning.    |
| **customer_call_data_cleaning.ipynb**| Jupyter notebook containing the Python script used to clean the data.        |
| **contactable_customer_list.xlsx**   | Output file generated after cleaning, containing the list of contactable customers. |


### Setup Instructions:

1. **Modify File Path**:
   - Open the `customer_call_data_cleaning.ipynb` Jupyter notebook.
   - Update the file path in the script to point to the correct location of the `customer_call_list.xlsx` file in your system.

2. **Run the Jupyter Notebook**:
   - After updating the file path, run the entire Jupyter notebook to clean and standardize the dataset.
   - The cleaned dataset will be saved as `contactable_customer_list.xlsx`.

3. **Check the Output**:
   - Once the notebook has finished running, locate the `contactable_customer_list.xlsx` file in the same directory or the specified output folder.
   - This file contains the cleaned and standardized customer call list.

