# TenableCat
A script to quickly categorize tenable findings


# Installation:
```git clone github.com/aestone24/TenableCat/TenableCat.git```

# Running the Script
```./TenableCat <Source File>.xlsx```

TenableCat takes an input xlsx file whcih must contain a sheet "Findings". It will check to see if categories have been assigned to each unique finding, then aggregate those which do not have categories, and will prompt you for a category. Simply select one broad category, then a subcategory, and this script will place the category into a CSV file to be imported into the findings section of your xlsx file.
