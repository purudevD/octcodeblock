import random

products = ['Lenovo Thinkpad T14S', 'Dell Inspiron', 'Apple Macbook Air M2',
'Apple MacBook Pro M2', 'hp Inspiron', 'ASUS Rog Gaming Laptop', 'Acer Business']


years = range(2010, 2024)
months = [1,2,3,4,5,6,7,8,9]
months = [f'0{str(month)}' for month in months ]
months.extend(['11', '12', '10'])
names = ['Lindsay', 'Paris', 'Britney', 'Nicole']
days = range(10, 28)
print(months)

for i in range(20000):
    sales_date = f'{months[random.randint(0, len(months)-1)]}-{days[random.randint(0, len(days)-1)]}'
    sales_date = f'{years[random.randint(0, len(years)-1)]}-{sales_date}'
    sales_value = round(random.random() * random.randint(30, 50), 2)
    person_name = names[random.randint(0, len(names)-1)]
    #print(query)
    buy_price = random.randint(50000, 75000)
    sales_price = random.randint(71000, 88000)
    query = f"INSERT INTO cookie_sales VALUES('{person_name}', {sales_value}, '{sales_date}');"
    print(query)
