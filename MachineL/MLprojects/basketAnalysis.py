## This is to explore and analize the data and answer some business questions
# TODO: Make graphs pretty!
import psycopg2
import pandas as pd
import graphlab
from scipy.spatial.distance import cosine
import numpy as np
import matplotlib.pyplot as plt

try:
    conn = psycopg2.connect("dbname='Capstone' user='postgres' host='localhost' password='annie123'")
except:
    print "Unable to connect"

cur.execute("SELECT * FROM orders_product_prior;")
opp=pd.DataFrame(cur.fetchall(),columns=["order_id","product_id","add_to_chart","reordered"])

cur.execute("SELECT * FROM orders ORDER BY order_id ASC;")
orders=pd.DataFrame(cur.fetchall(),columns=["order_id","user_id","eval_set","order_num", "order_dow","order_hour_of_day","days_since_prior_order"])

cur.execute("SELECT * FROM products;")
products=pd.DataFrame(cur.fetchall(),columns=["product_id","product_name","aisle_id","department_id"])

cur.execute("SELECT * FROM aisle;")
aisle=pd.DataFrame(cur.fetchall(),columns=["aisle_id","aisle"])

cur.execute("SELECT * FROM departments;")
departments=pd.DataFrame(cur.fetchall(),columns=["department_id","department"])

#
# Plot number of hours when purchases were made
#
plt.hist(orders.order_hour_of_day, bins=range(min(orders.order_hour_of_day), max(orders.order_hour_of_day) + binwidth, binwidth))

orders_per_hour=orders.order_hour_of_day.value_counts()
orders_per_hour=orders_per_hour[orders_per_hour.index.sort_values()]

plt.hist(orders.order_hour_of_day, bins=range(0,24))

plt.show()

#
# Plot to compare on which day were the most puchases made.
#
orders_per_day=orders.order_dow.value_counts()
orders_per_day=orders_per_day[orders_per_day.index.sort_values()]

#
#Plot hour of frequency for each day.
#
day0=orders.loc[orders["order_dow"]==0]
plt.hist(day0.order_hour_of_day)
plt.show()
# Plot all of them for all days. probably give plotly a shot.
day1=orders.loc[orders["order_dow"]==1]

day2=orders.loc[orders["order_dow"]==2]

day3=orders.loc[orders["order_dow"]==3]

day4=orders.loc[orders["order_dow"]==4]

day5=orders.loc[orders["order_dow"]==5]

day6=orders.loc[orders["order_dow"]==6]

#
# How often to they shop?
#
days_order=orders.days_since_prior_order.value_counts()
days_order=days_order[days_order.index.sort_values()]

#TODO: Make tree map and plots
