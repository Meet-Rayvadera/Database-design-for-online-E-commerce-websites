CREATE or replace function update_payment_data() returns trigger as $Trig_update_payment_data$
declare
	pdate project.payment.payment_date%TYPE;
begin
	select payment_date into pdate from project.payment where payment_id=NEW.payment_id;
	if (pdate - NEW.order_date) < 0 or (pdate - NEW.order_date) > 50 then
		update project.payment set payment_type = 'FAIL' where project.payment.payment_id = NEW.payment_id;
	end if;
	return null;
end $Trig_update_payment_data$ language 'plpgsql'