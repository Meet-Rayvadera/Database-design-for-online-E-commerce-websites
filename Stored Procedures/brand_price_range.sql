create TYPE rangeresults AS (
	pname varchar(20),
	productid char(10),
	categoryid char(5),
	sellername varchar(20),
	areaname varchar(20),
	price integer
);


create or replace function brand_price_range(min integer, max integer, brandname varchar(20)) returns SETOF rangeresults AS $BODY$
DECLARE
	ans rangeresults%rowtype;
	tuple product%rowtype;
	aval availability%rowtype;
	brandid product.brand_id%TYPE;
	discount deal.dis_percentage%TYPE;
	p availability.price%TYPE;
	sname seller.s_name%TYPE;
	area location.area_name%TYPE;
	
BEGIN
	select brand_id into brandid from brand as b where b.b_name = brandname;
	for tuple IN select * from product AS p where p.brand_id = brandid
	LOOP
		RAISE NOTICE 'Product id: %', tuple.product_id;
		
		select dis_percentage into discount from deal as d where d.deal_id = tuple.deal_id;
		
		
		for aval IN select * from availability as a where a.product_id = tuple.product_id
		LOOP
			p := aval.price;
			p := p*(1 - discount/100);
			
			select s_name into sname from seller as s where s.seller_id = aval.seller_id;
			select area_name into area from location as ll where ll.pincode = aval.location_id;
			ans.pname := tuple.p_name;
			ans.productid := tuple.product_id;
			ans.categoryid := tuple.category_id;
			ans.sellername := sname;
			ans.areaname := area;
			ans.price := p;
			
			if p >= min AND p <= max then
				return next ans;
			END IF;
		END LOOP;
	
	END LOOP;
	return;
end $BODY$ language 'plpgsql';