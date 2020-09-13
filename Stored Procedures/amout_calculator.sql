create or replace function amount_cal() returns trigger AS $Trig_amount_cal$
DECLARE
	orderid char(20);
	amount integer;
	deal project.deal%rowtype;
	prod project.product%rowtype;
	aval project.availability%rowtype;
	cont project.contains%rowtype;
	pay project.payment%rowtype;
	corder project.customerorder%rowtype;
	
	prodid project.product.product_id%type;
	selid project.seller.seller_id%type;
	locid project.location.pincode%type;
	
	total integer;
	per integer;
	p integer;
BEGIN
	total := 0;
	per := 0;
	p := 0;
	orderid := NEW.order_id;
	
	select * into corder from project.customerorder as cc where cc.order_id = orderid;
	
	for cont in select * from project.contains as c where c.order_id = orderid loop
		prodid = cont.product_id;
		select * into prod from project.product as p where p.product_id = prodid;
		select dis_percentage into per from project.deal as d where d.deal_id = prod.deal_id;
		
		select * into aval from project.availability as aa where aa.seller_id = cont.seller_id and aa.product_id = cont.product_id and aa.location_id = cont.location_id;
		
		p := aval.price;
		p := p*(1 - per/100);
		p := p*cont.quantity;
		
		total := total + p;
	end loop;

	update project.payment set amount = total where project.payment.payment_id = corder.payment_id;
	return null;
	
end $Trig_amount_cal$ language 'plpgsql';