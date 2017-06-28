#Capstone - Instacart marketing basket analysis
#Collabourative filtering
#Item - item filtering

import psycopg2
import pandas as pd
import graphlab

try:
    conn = psycopg2.connect("dbname='Capstone' user='postgres' host='localhost' password='annie123'")
except:
    print "Unable to connect"

cur=conn.cursor()
cur.execute("SELECT * FROM aisle;")
rows=cur.fetchall()

# store as data frame
rows=pd.DataFrame(rows)

# to see the total number of tables in the schema
cur.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';")

# to see how to make a matrix for us to work with.
# The important one is "orders_product_prior" which is connected to table "order"
cur.execute("SELECT * FROM orders_product_prior LIMIT 50;")
opp=pd.DataFrame(cur.fetchall(),columns=["order_id","product_id","add_to_chart","reordered"])

# TODO: get info in ascending order.
cur.execute("SELECT * FROM orders ORDER BY order_id ASC LIMIT 100;")
orders=pd.DataFrame(cur.fetchall(),columns=["order_id","user_id","eval_set","order_num", "order_dow","order_hour_of_day","days_since_prior_order"])

# Incase I want to over efficient and try to change product i to product names
# Otherwise this is an unnecessary step.
cur.execute("SELECT * FROM products LIMIT 50;")
products=pd.DataFrame(cur.fetchall(),columns=["product_id","product_name","aisle_id","department_id"])

# Trial 1a: Just run the opp data with graphlab and see what the result looks like.
# Trial 1b: Run target as 'product_id'
# Trial 2: Make a proper dataset and then run graphlab

#Trial 1a:
opp_data=graphlab.SFrame(opp)
popularity_model=graphlab.popularity_recommender.create(opp_data, user_id='order_id', item_id='product_id',target='reordered')
#Get recommendations for first 5 users and print them
#users = range(1,6) specifies user ID of first 5 users
#k=5 specifies top 5 recommendations to be given
popularity_recomm = popularity_model.recommend(users=range(1,6),k=5)
popularity_recomm.print_rows(num_rows=25)

# Pearson's collabourative filtering
item_sim_model = graphlab.item_similarity_recommender.create(opp_data, user_id='order_id', item_id='product_id',target='reordered', similarity_type='pearson')
item_sim_recomm = item_sim_model.recommend()
item_sim_recomm.print_rows()

# Jaccard filtering
j_item_sim_model = graphlab.item_similarity_recommender.create(opp_data, user_id='order_id', item_id='product_id',target='reordered', similarity_type='jaccard')
j_item_sim_recomm = j_item_sim_model.recommend()
j_item_sim_recomm.print_rows()

#cosine filtering
c_item_sim_model = graphlab.item_similarity_recommender.create(opp_data, user_id='order_id', item_id='product_id',target='reordered', similarity_type='cosine')
c_item_sim_recomm = c_item_sim_model.recommend()
c_item_sim_recomm.print_rows()

# cosine and jaccard show the same output while peason and popularity show the same.

#Trial 1b:
popularity_model_1b=graphlab.popularity_recommender.create(opp_data,target='reordered')
#Generates error needs to know user_ids and item_ids
popularity_model_1b=graphlab.popularity_recommender.create(opp_data,user_id='product_id',item_id='order_id',target='reordered')
popularity_recomm_1b = popularity_model_1b.recommend()
popularity_recomm_1b.print_rows()
# this showed me some crazy results but definately interesting.

#Trial 2: Generate dataset similar to http://www.salemmarafi.com/code/collaborative-filtering-with-python/
# TODO: See if you make a dataset with user_id, order_id, product_id and run that through Trial 1 again.
