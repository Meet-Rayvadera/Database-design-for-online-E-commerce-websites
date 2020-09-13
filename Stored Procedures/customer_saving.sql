create or replace function Customer_saving(c_id char(10))
returns numeric as $BODY$
DECLARE
    tmp contains%ROWTYPE;
    tmp2 customerorder%ROWTYPE;
    tuple availability%ROWTYPE;
    de deal%ROWTYPE;
    pro product%ROWTYPE;
    ans numeric:=0;
BEGIN
    select * into tmp2 from customerorder as b where b.customer_id = c_id;
    for tmp in select * from contains as b where b.order_id = tmp2.order_id
    LOOP
        for tuple IN select * from availability AS p where p.product_id = tmp.product_id
        LOOP
            for pro IN select * from product as l where l.product_id = tuple.product_id
            LOOP
                for de IN select * from deal as d where d.deal_id = pro.deal_id
                LOOP
                    ans := ans + (tmp.quantity * tuple.price * de.dis_percentsge)/100;
                END LOOP;
            END LOOP;
        end LOOP;
    end loop;
    return ans;
end $BODY$ language 'plpgsql';