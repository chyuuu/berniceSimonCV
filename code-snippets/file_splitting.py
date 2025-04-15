import pandas as pd

#SPLIT

# load the large CSV file with UTF-16 encoding
# reading in the file_name should be dynamic, though
df = pd.read_csv('file_name', sep='\t', encoding='utf-16')

# find the midpoint
midpoint = len(df) // 2

# split the data into two parts
df1 = df.iloc[:midpoint]
df2 = df.iloc[midpoint:]

# save each part to a new CSV file with UTF-16 encoding
df1.to_csv('split_file_1.csv', index=False, encoding='utf-16')
df2.to_csv('split_file_2.csv', index=False, encoding='utf-16')

#CONVERT

# load the CSV files with specified options
df1 = pd.read_csv("split_file_1.csv", sep=',', encoding='utf-16', low_memory=False)
df2 = pd.read_csv("split_file_2.csv", sep=',', encoding='utf-16', low_memory=False)

# save each part to a new Excel file
print("converting first file from csv to xlsx")
df1.to_excel('split_file_1.xlsx', index=False)
print("converting second file from csv to xlsx")
df2.to_excel('split_file_2.xlsx', index=False)

#MERGE

# read the first and second Excel files
print("reading first file")
file1 = pd.read_excel("split_file_1.xlsx")
print("done reading")
print("reading second file")
file2 = pd.read_excel("split_file_2.xlsx")
print("done reading")

# merge them (stack rows)
print("merging")
merged_data = pd.concat([file1, file2], ignore_index=True)

# define the maximum number of rows allowed in a single excel sheet
max_rows = 1048575  # excel's maximum row limit

# split the merged data into chunks
chunks = [merged_data.iloc[i:i + max_rows] for i in range(0, len(merged_data), max_rows)]

# save each chunk as a separate sheet in the Excel file
with pd.ExcelWriter("merged.xlsx", engine="openpyxl") as writer:
    for idx, chunk in enumerate(chunks):
        chunk.to_excel(writer, sheet_name=f"Sheet{idx + 1}", index=False)
        
print("done merging")
print("Data successfully saved across multiple sheets!")  