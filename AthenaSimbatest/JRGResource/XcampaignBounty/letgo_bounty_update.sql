update  lucktastic.xcampaign_metrics_new_test
set bounty = CPI
from 

		(select *,cpi*installs as modified_rev,
		       (cpi*installs)/event_count as CPA
		from
		(		
			select lastupdate as date_a,
			       event_count,
			       installs,
			       random_cpa,
			       (random_cpa*event_count) as revenue,
			       case when (random_cpa*event_count)/(installs)<1.5 then 1.5 else (random_cpa*event_count)/(installs) end as CPI 
			from      
			   (select lastupdate,
			          lower(campaign_name) as campaign_name,
			          sum(event_count)as event_count,
			          sum(installs) as installs,
			         20 + random() * 2 as random_cpa
			        from 
						(select x.lastupdate,
			             lower(x.campaign_name) as campaign_name,
			             count(*)as event_count,
			             0 as installs
			             from lucktastic.xcampaign_metrics_new_test x
						left join luckhouse.campaign_postback_fact c
						on c.campaign_id = x.campaign_id
						and date(dateadd(hour,-5,convert_timezone('UTC', 'America/New_York', event_timestamp::timestamp)))= x.lastupdate
						where x.campaign_id in 
						   (select distinct campaign_id 
			 				from lucktastic.xcampaign_metrics_new_test
			 				where lower(campaign_name) = 'letgo' and lower(os) = 'android')
			 				and c.action_name = 'product-sell-complete-24h'
			 				group by 1,2 
			         union
			 		select x.lastupdate,
			       	lower(x.campaign_name)as campaign_name,
			       	0 as event_count,
			       	sum(installs) as installs
			       	from lucktastic.xcampaign_metrics_new_test x
					left join luckhouse.campaign_postback_fact c
					on c.campaign_id = x.campaign_id
					and date(dateadd(hour,-5,convert_timezone('UTC', 'America/New_York', install_timestamp::timestamp)))= x.lastupdate
					where x.campaign_id in 
							(select distinct campaign_id 
							 from lucktastic.xcampaign_metrics_new_test
			 				where lower(campaign_name) = 'letgo' and lower(os) = 'android')
			 				group by 1,2)
			 	 group by 1,2)
			 where lastupdate = current_date - 1
			 order by 1)
			 )
where  lower(campaign_name) = 'letgo'
and os = 'Android'
and lastupdate = date_a;	