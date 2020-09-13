create TYPE result_cat_brand_price_range AS (
	pname varchar(20),
	productid char(10),
	sellername varchar(20),
	areaname varchar(20),
	price integer
);


create or replace function cat_brand_price_range(min integer, max integer, catname varchar(20), brandname varchar(20)) returns SETOF result_cat_brand_price_range AS $BODY$
DECLARE
	ans result_cat_brand_price_range%rowtype;
	tuple result_cat_price_range%rowtype;
	aval availability%rowtype;
	categoryid product.category_id%TYPE;
	discount deal.dis_percentage%TYPE;
	p availability.price%TYPE;
	sname seller.s_name%TYPE;
	area location.area_name%TYPE;
	bname brand.b_name%TYPE;
	
BEGIN

	select category_id into categoryid from category as c where c.c_name = catname;
	for tuple IN select * from cat_price_range(min, max, catname)
	LOOP
		RAISE NOTICE 'Product id: %', tuple.productid;
		
		IF tuple.brandname = brandname THEN
			ans.pname = tuple.pname;
			ans.productid = tuple.productid;
			ans.sellername = tuple.sellername;
			ans.areaname = tuple.areaname;
			ans.price = tuple.price;
			return next ans;
		END IF;
		
	END LOOP;
	return;
end $BODY$ language 'plpgsql';