:-consult(data).
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
