#!/usr/bin/env python
# coding: utf-8

# # Regression Week 2: Multiple Regression (Interpretation)

# In[2]:


import turicreate


# # Load in house sales data
# 
# Dataset is from house sales in King County, the region where the city of Seattle, WA is located.

# In[5]:


sales = turicreate.SFrame('m_1ce96d9d245ca490.frame_idx')


# # Split data into training and testing.
# We use seed=0 so that everyone running this notebook gets the same results.  In practice, you may set a random seed (or let Turi Create pick a random seed for you).  

# In[6]:


train_data,test_data = sales.random_split(.8,seed=0)


# # Learning a multiple regression model

# In[7]:


example_features = ['sqft_living', 'bedrooms', 'bathrooms']
example_model = turicreate.linear_regression.create(train_data, target = 'price', features = example_features, 
                                                    validation_set = None)


# Now that we have fitted the model we can extract the regression weights (coefficients) as an SFrame as follows:

# In[9]:


example_weight_summary = example_model.coefficients
print(example_weight_summary)


# # Making Predictions
# 
# 

# In[11]:


example_predictions = example_model.predict(train_data)
print(example_predictions[0])


# # Compute RSS

# Now that we can make predictions given the model, let's write a function to compute the RSS of the model. Complete the function below to calculate RSS given the model, data, and the outcome.

# In[12]:


def get_residual_sum_of_squares(model, data, outcome):
    # First get the predictions
    predictions = model.predict(data)
    # Then compute the residuals/errors
    residuals = outcome - predictions
    # Then square and add them up
    RSS = (residuals * residuals).sum()
    return(RSS)    


# Test your function by computing the RSS on TEST data for the example model:

# In[13]:


rss_example_train = get_residual_sum_of_squares(example_model, test_data, test_data['price'])
print(rss_example_train)


# # Create some new features

# Although we often think of multiple regression as including multiple different features (e.g. # of bedrooms, squarefeet, and # of bathrooms) but we can also consider transformations of existing features e.g. the log of the squarefeet or even "interaction" features such as the product of bedrooms and bathrooms.

# In[19]:


from math import log


# Next create the following 4 new features as column in both TEST and TRAIN data:
# * bedrooms_squared = bedrooms\*bedrooms
# * bed_bath_rooms = bedrooms\*bathrooms
# * log_sqft_living = log(sqft_living)
# * lat_plus_long = lat + long 
# As an example here's the first one:

# In[21]:


train_data['bedrooms_squared'] = train_data['bedrooms'].apply(lambda x: x**2)
test_data['bedrooms_squared'] = test_data['bedrooms'].apply(lambda x: x**2)


# In[25]:


# create the remaining 3 features in both TEST and TRAIN data

train_data['bed_bath_rooms'] = train_data['bedrooms'] * train_data['bathrooms']
test_data['bed_bath_rooms'] = test_data['bedrooms'] * test_data['bathrooms']

train_data['log_sqft_living'] = train_data['sqft_living'].apply(lambda x: log(x))
test_data['log_sqft_living'] = test_data['sqft_living'].apply(lambda x: log(x))

train_data['lat_plus_long'] = train_data['lat'] + train_data['long']
test_data['lat_plus_long'] = test_data['lat'] + test_data['long']


# * Squaring bedrooms will increase the separation between not many bedrooms (e.g. 1) and lots of bedrooms (e.g. 4) since 1^2 = 1 but 4^2 = 16. Consequently this feature will mostly affect houses with many bedrooms.
# * bedrooms times bathrooms gives what's called an "interaction" feature. It is large when *both* of them are large.
# * Taking the log of squarefeet has the effect of bringing large values closer together and spreading out small values.
# * Adding latitude to longitude is totally non-sensical but we will do it anyway (you'll see why)

# **Quiz Question: What is the mean (arithmetic average) value of your 4 new features on TEST data? (round to 2 digits)**

# In[29]:


print(test_data['bedrooms_squared'].mean())
print(test_data['bed_bath_rooms'].mean())
print(test_data['log_sqft_living'].mean())
print(test_data['lat_plus_long'].mean())


# #  Multiple Models

# In[32]:


model_1_features = ['sqft_living', 'bedrooms', 'bathrooms', 'lat', 'long']
model_2_features = model_1_features + ['bed_bath_rooms']
model_3_features = model_2_features + ['bedrooms_squared', 'log_sqft_living', 'lat_plus_long']


# Now that you have the features, learn the weights for the three different models for predicting target = 'price' using turicreate.linear_regression.create() and look at the value of the weights/coefficients:

# In[33]:


# Learn the three models: (don't forget to set validation_set = None)
model_1 = turicreate.linear_regression.create(train_data, target = 'price', features = model_1_features, 
                                                  validation_set = None)
model_2 = turicreate.linear_regression.create(train_data, target = 'price', features = model_2_features, 
                                                  validation_set = None)
model_3 = turicreate.linear_regression.create(train_data, target = 'price', features = model_3_features, 
                                                  validation_set = None)


# In[35]:


# Examine/extract each model's coefficients:
model_1_weight_summary = model_1.coefficients
model_2_weight_summary = model_2.coefficients
model_3_weight_summary = model_3.coefficients
print(model_1_weight_summary)
print(model_2_weight_summary)
print(model_3_weight_summary)


# # Comparing multiple models
# 
# Now that you've learned three models and extracted the model weights we want to evaluate which model is best.

# First use your functions from earlier to compute the RSS on TRAINING Data for each of the three models.

# In[36]:


# Compute the RSS on TRAINING data for each of the three models and record the values:
rss_model_1_train = get_residual_sum_of_squares(model_1, train_data, train_data['price'])
rss_model_2_train = get_residual_sum_of_squares(model_2, train_data, train_data['price'])
rss_model_3_train = get_residual_sum_of_squares(model_3, train_data, train_data['price'])
print(rss_model_1_train)
print(rss_model_2_train)
print(rss_model_3_train)


# Now compute the RSS on on TEST data for each of the three models.

# In[37]:


# Compute the RSS on TESTING data for each of the three models and record the values:
rss_model_1_test = get_residual_sum_of_squares(model_1, test_data, test_data['price'])
rss_model_2_test = get_residual_sum_of_squares(model_2, test_data, test_data['price'])
rss_model_3_test = get_residual_sum_of_squares(model_3, test_data, test_data['price'])
print(rss_model_1_test)
print(rss_model_2_test)
print(rss_model_3_test)

