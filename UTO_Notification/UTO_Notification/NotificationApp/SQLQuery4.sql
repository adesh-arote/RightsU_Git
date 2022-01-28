Select * from NotificationEngine..Notifications

Select * from NotificationEngine..NotificationDetail

select * from NotificationEngine..eventcategory

select API_Status, Service_Response, * from notifications order by Email

select * from Users where Login_Name like '%stef%'

--Update Users set email_id = first_name +'_'+Last_name+'@uto.in'

truncate table notifications

Delete from NotificationEngine..eventcategory where EventCategoryCode in (11,18,19)

truncate table NotificationEngine..Notifications

select * from email_config

UPDATE email_config SET email_type = 'Custom Users Mail' where email_config_code = '26'