//Hiren Patel, Lab 8 Sales Queries

//1.  What is the total amount of animal sales by sale price? (Total Price = (Quantity*SalePrice)+SalesTax) 
//              Total amount - $32308.18
db.sales.aggregate
([
    { $match: { "animal.animalid" : { $ne: null } } },
	{ $project: { oneSale: { $add: [{ $multiply: ["$quantity","$saleprice"] }, "$salestax" ] } } },
	{ $group : { _id: null, totalSales: { $sum: "$oneSale" } } }
]);

//2. What category of animal had the most sales by sale price? List the total sales for just that category. 
//              Dog - Total sales of $17941.83
db.sales.aggregate
([
	{ $match: { "animal.animalid" : { $ne: null } } },
	{ $project: { "animal.category" : 1,
	              oneSale: { $add: [{ $multiply: ["$quantity","$saleprice"] }, "$salestax" ] } } },
	{ $group : { _id: "$animal.category", totalSales: { $sum: "$oneSale" } } },
	{ $sort: { totalSales : - 1 } },
	{ $limit: 1 }
]);


//3. What category of animal had the most sales by count? List the number of animals sold. (Count = 
//SUM(Quantity))
//              Dog - Sold 95        
db.sales.aggregate
([
	{ $match: { "animal.animalid" : { $ne: null } } },
	{ $group : { _id: "$animal.category",
	             totalCount: { $sum: "$quantity" } } },
	{ $sort: { totalCount : - 1 } },
	{ $limit: 1 }
]);


//4. Given the top category of animal, what (Customer) State had the most sales of that animal? List the 
//total price for that category of animal, and the total number sold in the state. 
//              Kentucky (KY) - With $2612.63 and 14 total number sold
db.sales.aggregate
([
	{ $match: { "animal.category" : "Dog" } },
	{ $project: { "animal.category" : 1,
	              "customer.state": 1,
	              "quantity": 1,
	              oneSale: { $add: [{ $multiply: ["$quantity","$saleprice"] }, "$salestax" ] } } },
	{ $group : { _id: "$customer.state",
	             totalSales: { $sum: "$oneSale" },
	             totalCount: { $sum: "$quantity" } }
	},
	{ $sort: { totalCount : - 1 } },
	{ $limit: 1 }
]);

//5. What city and state sold the most Cats? Specify the total price and the count. 
//              Chapel Hill, NC - Total price of $614.43 and total count of 3 cats
db.sales.aggregate
([
	{ $match: { "animal.category" : "Cat" } },
	{ $project: { "customer.city" : 1,
	              "customer.state": 1,
	              "quantity": 1,
	              oneSale: { $add: [{ $multiply: ["$quantity","$saleprice"] }, "$salestax" ] } } },
	{ $group : { _id: { city: "$customer.city", state: "$customer.state"},
	             totalSales: { $sum: "$oneSale" },
	             totalCount: { $sum: "$quantity" } }
	},
	{ $sort: { totalSales : - 1 } },
	{ $limit: 1 }
]);

//6. What animal category sold the fewest? Specify the total price and the count.
//              Spiders - Total price of $384.92 and a total count of 3
db.sales.aggregate
([
	{ $match: { "animal.animalid" : { $ne: null } } },
	{ $project: { "animal.category" : 1, "quantity": 1,
	              oneSale: { $add: [{ $multiply: ["$quantity","$saleprice"] }, "$salestax" ] } } },
	{ $group : { _id: "$animal.category",
	             totalSales: { $sum: "$oneSale" },
	             totalCount: { $sum: "$quantity" } }
	},
	{ $sort: { totalSales : 1 } },
	{ $limit: 1 }
]);
      
//---------------------------------------------------------------------------------------------------------
        
//Hiren Patel, Lab 8 Orders Queries        
        
//1. What month had the highest number of orders? Include the total number of orders, and the total cost in 
//your answer.
//              May - With a total number of 4383 and a total cost of $7818.35
db.orders.aggregate
([
	{ $project: { month: { $dateToString: { format: "%m", date: "$orderdate" } },
	  			  quantity: 1,
	              oneCost: { $multiply: [ "$cost", "$quantity" ] } } },
	{ $group: { _id: "$month",
                                totalQuantity: { $sum: "$quantity" },
	  			totalCost : { $sum: "$oneCost"} } },
	{ $sort: { totalQuantity: - 1 } },
	{ $limit: 1 }
]);        
//2. Given the month you just found, what Supplier provided the most merchandise? Include the total 
//number of orders, and the total cost in your answer.
//              Parrish - With a total of 2001 orders and a total cost of $2152.98
db.orders.aggregate
([
	{ $project: { "supplier.name": 1,
				  month: { $dateToString: { format: "%m", date: "$orderdate" } },
	  			  quantity: 1,
	              oneCost: { $multiply: [ "$cost", "$quantity" ] } } },
	{ $match: { month: "05"} },
	{ $group: { _id: "$supplier.name",
                                totalQuantity: { $sum: "$quantity" },
	  			totalCost : { $sum: "$oneCost"} } },
	{ $sort: { totalQuantity: - 1 } },
	{ $limit: 1 }
]);
       
        
//3. Which supplier had the highest average shipping cost? Include the average shipping cost in your 
//answer.
//              Dillard - $55.55
db.orders.aggregate
([
	{ $group: { _id: "$supplier.name",
	  			averageShipping : { $avg: "$shippingcost"} } },
	{ $sort: { averageShipping: - 1 } },
	{ $limit: 1 }
]);
        
//4. Which State (supplier's location) had the highest average shipping cost? Include the average shipping 
//cost in your answer. 
//              South Carolina (SC) - $55.55
db.orders.aggregate
([
	{ $group: { _id: "$supplier.state",
	  			averageShipping : { $avg: "$shippingcost"} } },
	{ $sort: { averageShipping: - 1 } },
	{ $limit: 1 }
]);
       
       
//5. Using the state with the highest shipping cost, which month had the highest average shipping cost? 
//Include the average shipping cost for that month, in that state.
//              March - $58.18
db.orders.aggregate
([
    { $match: { "supplier.state" : "SC" } },
	{ $project: { "supplier.name": 1,
				  month: { $dateToString: { format: "%m", date: "$orderdate" } },
	  			  "shippingcost": 1 } },
	{ $group: { _id: "$month",
	  			averageShipping : { $avg: "$shippingcost"} } },
	{ $sort: { averageShipping: - 1 } },
	{ $limit: 1 }
]);
      
      
//6. What month do you think you should reorder supplies, and what supplier would you prefer using? Why?
//              We should reorder in June and use Harrsion as the supplier
//              due to his pricing at $14.22 as the average shipping cost
db.orders.aggregate
([
	{ $project: { "supplier.name": 1,
				  month: { $dateToString: { format: "%m", date: "$orderdate" } },
	  			  "shippingcost": 1 } },
	{ $group: { _id: { month: "$month", suppliername: "$supplier.name" },
	  			averageShipping : { $avg: "$shippingcost"} } },
	{ $sort: { averageShipping: 1 } },
	{ $limit: 1 }
]);
