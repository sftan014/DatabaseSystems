// Student Number: 7020466
// Name: Tan Shu Fei
// Date Written: 21/11/2021
// Description: A3 BSON

print('Question 1:');
print('List the customer name, address, and the created shopping cart who');
print('purchased product is P1001');

db.shoppingCart.aggregate([
	{$unwind: "$CUSTOMER.creates.SHOPPINGCART"},
	{$match: 
		{$and:
			[ 
			  {"CUSTOMER.creates.SHOPPINGCART.containsProdList.productId" : "P1001"}, 
			  {"CUSTOMER.creates.SHOPPINGCART.dateClosed" : {$ne:null} } 
			] 
		} 
	},
	{$project: {"CUSTOMER.customerName":1,
				   "CUSTOMER.customerAddress":1,
				   "CUSTOMER.creates":1,
				   "_id":0} }
]).pretty()

//-------------------------------------------------------------------

print('Question 2:');
print('List the customer name, address, and the created shopping cart of the');
print('customer who created a shopping cart on 11 Nov 2021');
print("(ISODate('2021-11-11T00:00:00Z'). Please do not show the customers ID.");

db.shoppingCart.aggregate([
	{$unwind: "$CUSTOMER.creates.SHOPPINGCART"},
	{$match : {$and: 
		[{"CUSTOMER.creates.SHOPPINGCART.dateCreated" :
		 	{$gte: ISODate("2021-11-11T00:00:00Z") } }, 	
		 {"CUSTOMER.creates.SHOPPINGCART.dateCreated":
		 	{$lte: ISODate("2021-11-11T23:59:59Z") } 
		}] 
	} },
	{$project: {"CUSTOMER.customerName":1,
			"CUSTOMER.customerAddress":1,
			"CUSTOMER.creates":1,
			"_id":0} }
]).pretty()

//-------------------------------------------------------------------

print('Question 3');
print('Find the total number of shopping cart created by each customer.');
print('For each customer, list his/her email address &'); 
print('the total number of shopping cart created.');

db.shoppingCart.aggregate([
	{$unwind: "$CUSTOMER.creates.SHOPPINGCART"},
	{$group: 
		{_id : {"customerEmail" : "$CUSTOMER.customerEmail"}, 
					count : {$sum:1} 
		}
	}
]).pretty()
//------------------------------------------------------------------
print('Question 4');
print('Find the products that have been included in at least 2 or 3 shopping carts.');

db.shoppingCart.find(
	{'PRODUCT.includedIn.1': {$exists:true} } 
).pretty()
//------------------------------------------------------------------
print('Question 5');
print('For each price base, list the price base and the total number of each price');
print('base.');

db.shoppingCart.aggregate([
	{$unwind: "$PRODUCT.price.base"},
	{$group: {_id: {"Base":"$PRODUCT.price.base"}, 
									Count : {$sum:1} 
				} 
	}
]).pretty()
//------------------------------------------------------------------
print('Question 6');
print('Find the customers who have purchased both the ');
print("products 'P1002' and 'P1003'.");

db.shoppingCart.aggregate([
	{$unwind: "$CUSTOMER.creates.SHOPPINGCART"},
	{$match: 
		{$and: 
			[ {"CUSTOMER.creates.SHOPPINGCART.containsProdList.productId" 
				:"P1002"}, 
		  	  {"CUSTOMER.creates.SHOPPINGCART.containsProdList.productId" 
				:"P1003"} 
			]
		}
	}
]).pretty()
//------------------------------------------------------------------
print('Question 7');
print('Find the products that have not been included');
print('in any of the shopping cart');

db.shoppingCart.aggregate([
	{$unwind: "$PRODUCT.includedIn"},
	{$match: {"PRODUCT.includedIn" : {$eq:null} } },
	{$project: {"PRODUCT":1, "_id":1} }
]).pretty()
//-------------------------------------------------------------------
print('Question 8'); 
print('Find the total number of customers who do not provide his/her telephone ');
print('number');

db.shoppingCart.aggregate([
	{$match: {"CUSTOMER" : {$ne:null} } },
	{$group: 
		{"_id": "$CUSTOMER.customerPhone",
					"Total number of customers do not provide phone"
					:{$sum:1} 
		} 
	},
	{$match: {"_id" : null} },
	{$project: {"_id":0} }
]).pretty()
//------------------------------------------------------------------
print('Question 9'); 
print('Update the closing date (dateClosed) of the cart ‘cart001’ of the customer');
print('‘C12345’ to 15 November 2021. (Hint. You can use the function new');
print('Date(“2021-11-15” to set the date.)');

db.shoppingCart.drop()
load('/home/csci235/csci235/data/customerShoppingcartV2.js')

db.shoppingCart.update(
	{"_id" : "C12345" }, 
	{"$set": {"CUSTOMER.creates.SHOPPINGCART.$[xx].dateClosed"
					:new ISODate("2021-11-15") }
	},
	{"arrayFilters": [ {"xx.cartId":"cart001"} ] }
)

db.shoppingCart.find({"CUSTOMER.creates.SHOPPINGCART.cartId" : "cart001"}).pretty()

//------------------------------------------------------------------
print('Question 10'); 
print('Delete from the collection a shoppingcart (cart005) created by the customer');
print('C12347');


db.shoppingCart.drop()
load('/home/csci235/csci235/data/customerShoppingcartV2.js')

db.shoppingCart.update(
	{ "_id" : "C12347" }, 
	{$pull: {"CUSTOMER.creates.SHOPPINGCART":{cartId:"cart005"} } }
)

db.shoppingCart.find({"_id":"C12347"}).pretty()
// END OF EDITOR
