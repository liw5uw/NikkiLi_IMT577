
---1. Give an overall assessment of stores number 10 and 21’s sales.

--- How are they performing compared to target? Will they meet their 2013 target?

create SECURE VIEW "VIEW_STORE_SALE_AMOUNT" as
select Dim_Store.STORENUMBER,Dim_Date.YEAR,sum(SaleAmount) as actual_sale_amount
from Dim_Store,FACT_SALESACTUAL ,Dim_Date
where Dim_Store.STORENUMBER in (10,21)
and FACT_SALESACTUAL.DimStoreID = Dim_Store.DimStoreID
and Dim_Date.DATE_PKEY = FACT_SALESACTUAL.DIMSALEDATEID
group by Dim_Store.STORENUMBER,Dim_Date.YEAR;

select * from VIEW_STORE_SALE_AMOUNT;



create SECURE VIEW "VIEW_STORE_TARGET_SALE_AMOUNT" as
select replace( STAGE_CHANNELRESELLERSTORETARGET.TARGETNAME , 'Store Number ' , '' ) as STORENUMBER,TARGETSALESAMOUNT
from STAGE_CHANNELRESELLERSTORETARGET
where TARGETNAME  in ('Store Number 10','Store Number 21')
and YEAR = 2013;

select * from VIEW_STORE_TARGET_SALE_AMOUNT;


# 2013年 actual 实际sale amount
# 10: 95833894.7
# 21: 65093723.26

# 2013年 target sale amount
# 10: 46932000
# 21: 41528000

--- Should either store be closed? Why or why not?
---- 实际销售amount 都大于目标,所以我认为不需要关闭. 也是用的2013年的数据.


# What should be done in the next year to maximize store profits?

drop view VIEW_STORE_PRODUCT_PROFIT_DETAIL;
create SECURE VIEW "VIEW_STORE_PRODUCT_PROFIT_DETAIL" as
select t.*,rank() over ( partition by t.STORENUMBER order by t.SaleTotalProfit  desc) as rank
from (
select Dim_Store.STORENUMBER ,Dim_product.productName,sum(FACT_SALESACTUAL.SaleTotalProfit) as SaleTotalProfit
from Dim_Store,FACT_SALESACTUAL ,Dim_Date,Dim_product
where Dim_Store.STORENUMBER in (10,21)
and FACT_SALESACTUAL.DimStoreID = Dim_Store.DimStoreID
and Dim_Date.DATE_PKEY = FACT_SALESACTUAL.DIMSALEDATEID
and Dim_product.DimProductID = FACT_SALESACTUAL.DimProductID
group by Dim_Store.STORENUMBER ,Dim_product.productName
) t ;

select * from VIEW_STORE_PRODUCT_PROFIT_DETAIL;



--# 从查询的利润详情可以看出,Store 10  的利润来源top 3 的商品为 Dress,Strapless Dress,Shoes - High-heel
--Store 21  的利润来源top 3 的商品为 Blouse, Skirt,Strapless Dress
--说明这些商品利润比较高,为了提升利润,可以增加这些商品的供应或者宣传.


--2. Recommend 2013 bonus amounts for each store if the total bonus pool is $2,000,000 using a comparison of 2013 actual sales vs.
--2013 sales targets as the basis for the recommendation.   用的2013年的数据


drop view  VIEW_STORE_AMOUNT_ACTUAL_TARGET_RATE;
create SECURE VIEW "VIEW_STORE_AMOUNT_ACTUAL_TARGET_RATE" as
select  VIEW_STORE_SALE_AMOUNT.STORENUMBER,VIEW_STORE_SALE_AMOUNT.ACTUAL_SALE_AMOUNT / VIEW_STORE_TARGET_SALE_AMOUNT.TARGETSALESAMOUNT as actual_target_rate
from VIEW_STORE_SALE_AMOUNT ,VIEW_STORE_TARGET_SALE_AMOUNT
where VIEW_STORE_SALE_AMOUNT.STORENUMBER = VIEW_STORE_TARGET_SALE_AMOUNT.STORENUMBER
and VIEW_STORE_SALE_AMOUNT.YEAR = 2013;


select STORENUMBER,
VIEW_STORE_AMOUNT_ACTUAL_TARGET_RATE.actual_target_rate / (select sum(actual_target_rate) from VIEW_STORE_AMOUNT_ACTUAL_TARGET_RATE) * 2000000  as bonus
from VIEW_STORE_AMOUNT_ACTUAL_TARGET_RATE;

#推荐奖励. 如下.
store 21 ,868537.060536629
store 10,1131462.93965183


--# 数据只有2013年的没有2020年的

----3. Assess product sales by day of the week at stores 10 and 21. What can we learn about sales trends?



create SECURE VIEW "VIEW_WEEKNUM_SALEAMOUNT" as
 select Dim_DATE.DAY_NUM_IN_WEEK,sum(SALEAMOUNT) as TOTAL_SALEAMOUNT
 from FACT_SALESACTUAL ,Dim_DATE
 where Dim_DATE.DATE_PKEY = FACT_SALESACTUAL.DIMSALEDATEID
 group by Dim_DATE.DAY_NUM_IN_WEEK
 order by TOTAL_SALEAMOUNT;

 select * from VIEW_WEEKNUM_SALEAMOUNT;

-- #  从数据可以看出,周六 周日 周一 这几天销量最高,周2到周5销量明显低.应该是工作日销量比较低,休息日销量比较高.

-- 4.
-- Should any new stores be opened? Include all stores in your analysis if necessary.
-- If so, where? Why or why not?

-- # 查看每个店的利润情况.
 create SECURE VIEW "VIEW_STORE_PROFIT" as
select DIM_STORE.STORENUMBER,sum(SALETOTALPROFIT) as profit
from FACT_SALESACTUAL,DIM_STORE
where FACT_SALESACTUAL.DIMSTOREID = DIM_STORE.DIMSTOREID
group by DIM_STORE.STORENUMBER;

select * from VIEW_STORE_PROFIT;

--# 发现每个店都处于盈利状态. 所以是可以开新店的.


















