# Explore E-Commerce Dataset
Used Google BigQuery to solve problems such as joining data, data manipulation from the E-commerce dataset.

Author: Nguyen Anh Huy

Date: 19/02/2025

Tools used: SQL (Google BigQuery)

## Table of Contents
[I. Background & Overview](https://github.com/yuhanguyen/Explore-E-Commerce-Dataset/blob/main/README.md#i-background--overview)

[II. Requirement](https://github.com/yuhanguyen/Explore-E-Commerce-Dataset/blob/main/README.md#ii-requirement)

[III. Dataset Access](https://github.com/yuhanguyen/Explore-E-Commerce-Dataset/blob/main/README.md#iii-dataset-access)

[IV. Main Process](https://github.com/yuhanguyen/Explore-E-Commerce-Dataset/blob/main/README.md#iv-main-process)


## I. Background & Overview

Objective:

This project uses Google BigQuery SQL platform to explore ecommerce dataset from Google Analytics to:

✔️ Analyze the traffic of the ecommerce website.

✔️ Identify the behavior in customers who visit the website.

👤 Who is this project for?

✔️ Data analysts & business analysts

✔️ Decision-makers & stakeholders

## II. Requirement
+ Google Cloud Platform account
+ Project on Google Cloud Platform
+ Google BigQuery API enabled
+ SQL query editor

## III. Dataset Access
The E-Commerce dataset is stored in a public Google BigQuery Dataset. To access the dataset, follow the steps below:
+ Log in to Google Cloud Platform account and create a new project.
+ Navigate to the BigQuery console and select your newly created dataset.
+ In the navigation panel, select "Add data" and then "Search a project".
+ Enter the project ID 'bigquery-public-data.google_analytics_sample.ga_sessions" and click "Enter"
+ Click on "ga_sessions_" table to open it.

## IV. Main Process
In this project, i will write 08 queries based on the E-Commerce Dataset

### -- Query 01: calculate total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)

![image](https://github.com/user-attachments/assets/357bb660-e7a0-4b0c-9b2a-83a43394e36e)

Result:

![image](https://github.com/user-attachments/assets/60fac2ca-cc39-4b37-8584-86f710f298d4)


### -- Query 02: Bounce rate per traffic source in July 2017 (Bounce_rate = num_bounce/total_visit) (order by total_visit DESC)

![image](https://github.com/user-attachments/assets/687a5b03-a949-4d56-bac2-a440cf36075c)

Result:

![image](https://github.com/user-attachments/assets/32830887-8d91-4aec-9a57-aee822faa71e)


### -- Query 03: Revenue by traffic source by week, by month in June 2017

![image](https://github.com/user-attachments/assets/3747cae5-687c-4205-9b37-ec713fc90c75)

Result:

![image](https://github.com/user-attachments/assets/18135301-947d-482f-ad00-6597c96943e0)


### -- Query 04: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017

![image](https://github.com/user-attachments/assets/13a0458b-bcd3-4e47-a113-e588eff1bc59)

Result:

![image](https://github.com/user-attachments/assets/07f8b001-e606-4837-8bba-2a39e829eb5e)


### -- Query 05: Average number of transactions per user that made a purchase in July 2017

![image](https://github.com/user-attachments/assets/1d919c7f-3378-4030-b0c0-9651e1b4461d)

Result:

![image](https://github.com/user-attachments/assets/f1271ac3-4a68-417a-baac-be917827bc74)


### -- Query 06: Average amount of money spent per session. Only include purchaser data in July 2017

![image](https://github.com/user-attachments/assets/d70c7e78-f26e-4be8-b2f9-d4749a41303f)

Result:

![image](https://github.com/user-attachments/assets/cc3a14ad-cf86-46d0-a409-e3a3b7face30)


### -- Query 07: Other products purchased by customers who purchased the product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.

![image](https://github.com/user-attachments/assets/ad28ecc9-4f09-466f-9228-f3c559275295)

Result:

![image](https://github.com/user-attachments/assets/36c85c20-6053-4063-99ae-30f3030c2a84)


### -- Query 08: Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017. For example, 100% product view then 40% add_to_cart and 10% purchase.

![image](https://github.com/user-attachments/assets/a0504743-6469-458c-905a-77e1bd2037bb)

![image](https://github.com/user-attachments/assets/aef15c37-f830-425d-8618-dd9fc1075cf7)

Result:

![image](https://github.com/user-attachments/assets/e4764ad9-a403-4897-8871-3fba4a1a0b54)










