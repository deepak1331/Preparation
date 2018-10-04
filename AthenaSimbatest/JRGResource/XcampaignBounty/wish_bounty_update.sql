		
update  lucktastic.xcampaign_metrics_new 
set bounty = Modified_CPI
from 
	
	  (select install_date,
		       installs,
		       D0_Revenue,
		       assumed_ROAS,
		       case when Modified_CPI < 2 then 2 else Modified_CPI end  
		 from(
			
		    select b.install_date,
			       b.installs,
			       a.D0_Revenue,
			       a.D0_Revenue*100/(4*b.installs) as assumed_ROAS,
			       case when a.D0_Revenue*100/(4*b.installs) < 10 then a.D0_Revenue/b.installs*10 else 4 end as Modified_CPI
			from 
			     (	select date(dateadd(hour,-5,convert_timezone('UTC', 'America/New_York', event_timestamp::timestamp))),
					       sum(action_value) as D0_Revenue
					       from luckhouse.campaign_postback_fact c
					where datediff(day,date(dateadd(hour,-5,convert_timezone('UTC', 'America/New_York', install_timestamp::timestamp))),date(dateadd(hour,-5,convert_timezone('UTC', 'America/New_York', event_timestamp::timestamp))))=0
					and campaign_id in (select distinct campaign_id 
						 				  from lucktastic.xcampaign_metrics_new 
						 				  where lower(campaign_name) = 'wish' and lower(os) = 'android') 
					group by 1)a
					join 
					(select x.lastupdate as install_date,
					        count(v.bounty) as installs
					from lucktastic.xcampaign_metrics_new  x
					left join lucktastic.vdav v
					on x.campaign_id = v.campaignid
					and x.lastupdate = date(dateadd(hour, -5,TIMESTAMP))
					where campaignid in (select distinct campaign_id 
						 				 from lucktastic.xcampaign_metrics_new 
						 				 where lower(campaign_name) = 'wish' and lower(os) = 'android')
					group by 1
					order by 1 )b
			on a.date = b.install_date
			where b.install_date = current_date - 1
			
		))
where  lower(campaign_name) = 'wish'
and os = 'Android'
and lastupdate = install_date;	
