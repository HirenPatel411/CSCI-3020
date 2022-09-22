--Hiren Patel, Homework 3 Part 2
SET SERVEROUTPUT ON;

DROP TYPE COST_OBJ_TABLE;
DROP TYPE COST_OBJ;

CREATE OR REPLACE TYPE COST_OBJ AS OBJECT
(
    Manufacturer VARCHAR2(50),
    Model_Number VARCHAR2(50),
    Category VARCHAR2(50),
    Cost MONEY,
    ListPrice MONEY,
    Quantity_On_Hand MONEY,
    Total_Cost MONEY, 
    Total_List_Price MONEY,
    Total_Profit MONEY,
    
    MEMBER PROCEDURE DisplayCSV
);
/

CREATE OR REPLACE TYPE COST_OBJ_TABLE AS TABLE OF COST_OBJ;

/

CREATE OR REPLACE TYPE BODY COST_OBJ AS
MEMBER PROCEDURE DisplayCSV IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('"' || Manufacturer || '", ' || '"' || Model_Number || '", ' || '"' || Category ||
        '", ' || '"' || Cost || '", ' || '"' || ListPrice || '", ' || '"' || Quantity_On_Hand || '", ' || 
        '"' || Total_Cost || '", ' || '"' || Total_List_Price || '", ' || '"' || Total_Profit ||'"'
        );
     END;
 END;
 /
 
 CREATE OR REPLACE PROCEDURE COST_CSV_OBJ IS
    csvLine COST_OBJ := COST_OBJ(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    
TYPE csvTable IS TABLE OF COST_OBJ;
    t csvTable := csvTable();
    
    counter NUMBER := 1;

    CURSOR attribute_table IS
        SELECT 
            man.name,
            itmMod.modelid,
            itmMod.category,
            itmMod.cost,
            itmMod.listprice,
            invent.quantityonhand,
            invent.quantityonhand * itmMod.cost as total_cost,
            invent.quantityonhand * itmMod.listprice as total_price,
            (invent.quantityonhand * itmMod.listprice) - (invent.quantityonhand * itmMod.cost) as total_profit
        FROM
            ALLPOWDER.Manufacturer man
            INNER JOIN ALLPOWDER.itemmodel itmMod ON man.manufacturerid = itmMod.manufacturerid
            INNER JOIN ALLPOWDER.inventory invent ON itmMod.modelid = invent.modelid;
    
        i attributeTable%ROWTYPE;
    
BEGIN
    FOR i IN attributeTable LOOP

        csvLine := COST_OBJ(i.name, i.modelid, i.category, i.cost, i.listprice,
                    i.quantityonhand, i.total_cost, i.total_price, i.total_profit);
        
        t.EXTEND(1);
        t(counter) := csvLine;
        counter := counter + 1;
        csvLine.DisplayCSV;
        
    END LOOP; 
 
END;
/
EXECUTE COST_CSV_OBJ;