:-consult(data).
%Question 1
%List all orders of a specific customer (as a list).
biggestOrderNumber(CustomerID,N):-
    order(CustomerID,N,_),
    \+((
        order(CustomerID,M,_),
        M > N )).

list_orders(CustomerName, ListOrders):-
 customer(CustomerID, CustomerName),
 collectItems(CustomerID, 1, ListItems),
 collectOrders(CustomerID,1, ListItems, ListOrders).


collectItems(CustomerID, X, [H|T]) :-
 order(CustomerID, X, H),
 X1 is X + 1,
 collectItems(CustomerID, X1, T).

collectItems(CustomerID, X, []) :-
 biggestOrderNumber(CustomerID,X1),
 X is X1+1.

collectOrders(_,_, [],[]).

collectOrders(CustomerID, X, [H|T], [order(CustomerID, X, H)|T1]):-
	X1 is X + 1,
	collectOrders(CustomerID,X1,T,T1).

%Question 2
%Get the number of orders of a specific customer given customer id.
%
%getCustomerInfo will get customer info either id or user name
%whichever is needed

getCustomerInfo(CustomerName,CustID):-
    customer(CustID,CustomerName).

countOrdersOfCustomer(CustomerID,Count):-
    getCustomerInfo(CustomerName,CustomerID),
    list_orders(CustomerName,L),%laila is on it
    countItems(L,Count).


%Question 3
% List all items in a specific customer order using customer id and order id.
getItemsInOrderById(CustomerID, OrderID, Items) :-
    order(CustomerID, OrderID, Items).

%Question 4
% Get the num of items in a specific customer order given customer Name
% and order id.
countItems([], 0).
countItems([_|T],R):-
    countItems(T,R1),
    R is 1+R1.
getNumOfItems(CustomerName, OrderID, Count) :-
    customer(CustomerID, CustomerName),
    order(CustomerID, OrderID, Items),
    countItems(Items, Count).

%Question 5
%Calculate the price of a given order given Customer Name and order id
countPriceItems([],0).
countPriceItems([S|T],TP):-
    countPriceItems(T,TP1),
    item(S,_,P),
    TP is TP1+P.

calcPriceOfOrder(CustomerName,OrderID,TotalPrice):-
    customer(CustomerID,CustomerName),
    order(CustomerID,OrderID,Items),
    countPriceItems(Items,TotalPrice).

%Question 6
%Given the item name or company name, determine whether to boycott or not.
isBoycott(Company) :- boycott_company(Company,_).
isBoycott(Item) :- item(Item, Company,_) , boycott_company(Company,_).

%Question 7
%Given the company name or an item name, find the justification why you need to boycott this company/item.
whyToBoycott(Item , Justfication) :- item(Item, Company, _) , boycott_company(Company,
Justfication).
whyToBoycott(Company, Justification):- boycott_company(Company, Justification).

%Question 9
%Given an username and order ID, update the order such that all
%boycott items are replaced by an alternative (if exists).
replaceBoycottItemsFromAnOrder(Username, OrderID, NewList) :-
    customer(CustomerID, Username),
    order(CustomerID, OrderID, List),
    replaceBoycottHelper(List, NewList).

replaceBoycottHelper([], []).
replaceBoycottHelper([H|T], [H|NewList]) :- 
    \+ isBoycott(H),
    replaceBoycottHelper(T, NewList).

replaceBoycottHelper([H|T], [NewItem|NewList]):-
    isBoycott(H),
    alternative(H, NewItem),
    replaceBoycottHelper(T, NewList).


%Question 8
%Given an username and order ID, remove all the boycott items from
%this order.

removeBoycott([], []).
removeBoycott([H|T], Result) :-
    isBoycott(H),
    removeBoycott(T, Result).
removeBoycott([H|T], [H|Result]) :-
    \+ isBoycott(H),
    removeBoycott(T, Result).

removeBoycottItemsFromAnOrder(Username, OrderID, ResultList) :-
    getCustomerInfo(Username, CustomerID),
    getItemsInOrderById(CustomerID, OrderID, Items),
    removeBoycott(Items, ResultList).


%Question 11
% calculate the difference in price between the boycott item and its alternative.
getTheDifferenceInPriceBetweenItemAndAlternative(ItemName, A, DiffPrice):-
    item(ItemName, _, Price),
    alternative(ItemName, A),
    item(A, _, AlternativePrice),
    DiffPrice is Price - AlternativePrice.

%Question 12
% Insert/Remove item, alternative and new boycott company to/from the knowledge base. Hint: assert to insert new fact and retract to remove a fact
add_item(ItemName, CompanyName, Price) :-
    assert(item(ItemName, CompanyName, Price)).

remove_item(ItemName, CompanyName,Price) :-
    retract(item(ItemName, CompanyName, Price)).

add_alternative(ItemName, AlternativeName) :-
    assert(alternative(ItemName, AlternativeName)).

remove_alternative(ItemName) :-
    retract(alternative(ItemName, _)).

add_boycott_company(CompanyName, Reason) :-
    assert(boycott_company(CompanyName, Reason)).
    
remove_boycott_company(CompanyName) :-
    retract(boycott_company(CompanyName, _)).
