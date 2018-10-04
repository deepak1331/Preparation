With events as 
    
(select date(from_unixtime(timestamp/1000) at time zone 'America/New_York' - interval '5' hour) as date,
		lower(platform) as platform,
        opp_id,
        oppdescription,
        json_extract_scalar(other_parameters,'$.ad_network') as ad_network,
        json_extract_scalar(other_parameters,'$.campaign_id') as campaign_id,
        case  when opp_id in (226, 532) then 'Gated Card Walls'
              when opp_id in (146) then 'Standard Wall'
              when opp_id in (238) then 'Premium Wall'
              when opp_id in (554) then 'Button Wall'
              when opp_id in (2727, 2763, 2764, 2765) then 'Hidden Walls'
              when lower(oppdescription) like '%special placement%' then 'Special Placement'
              when lower(oppdescription) like '%special mediation%' then 'Branded Cards'
              when lower(campaign_name) like '%aotd%' then 'App of the Day'
              when event_type like 'modal%' then 'App of the Day'
              when opp_id is null then 'No Opp ID'
              else 'Direct Deal Cards'
        end as revenue_source,  
        date_diff('day',cast(b.lucktastic_day as date),date(from_unixtime(a.timestamp/1000) at time zone 'America/New_York' - interval '5' hour))as dx,
        event_type,
        cast(json_extract_scalar(other_parameters,'$.reward_amount') as decimal(18,4)) as bounty
FROM jrg_datalake_db_prod.datalake_events a
left join profile_created b
on a.user_id =b.user_id
left join oppid_lookup c
on a.opp_id = c.oppid
left join jrg_datalake_db_prod.lucktastic_xcampaign d
on json_extract_scalar(other_parameters,'$.campaign_id') = cast(d.campaign_id as varchar)
where (
        (year = 'startYear' and month = 'startMonth' and  day >= 'startDay') or
        (year = 'endYear' and month = 'endMonth' and  day <= 'endDay')
      )
and app_id='0'
and lower(platform) = 'android'
and event_type in ('revenue_offer_wall_view','revenue_offer_detail','postback','ad_start','modal_app_of_the_day_view','modal_app_of_the_day_click')
and cast(date(from_unixtime(timestamp/1000) at time zone 'America/New_York' - interval '5' hour) as varchar) between 'startDate' and 'endDate'
)
select  date,
		platform,
        revenue_source,
        count(case   when event_type= 'revenue_offer_wall_view' and revenue_source in ('Premium Wall','Gated Card Walls','Standard Wall','Button Wall','Hidden Walls') then 1
                    when event_type= 'ad_start' and lower(ad_network) = 'smartadserver' and revenue_source in ('Special Placement','Branded Cards','Direct Deal Cards') then 1
                    when event_type= 'modal_app_of_the_day_view' and revenue_source = 'App of the Day' then 1
                    end)as impressions,
        count(case  when event_type= 'revenue_offer_wall_view' and dx = 0 and revenue_source in ('Premium Wall','Gated Card Walls','Standard Wall','Button Wall','Hidden Walls') then 1 
                    when event_type= 'ad_start' and lower(ad_network) = 'smartadserver' and dx = 0 and revenue_source in ('Special Placement','Branded Cards','Direct Deal Cards') then 1
                    when event_type= 'modal_app_of_the_day_view' and dx = 0  and revenue_source = 'App of the Day' then 1
                    end)as impressions_d0,
        count(case when event_type= 'revenue_offer_detail' and revenue_source in ('Premium Wall','Gated Card Walls','Standard Wall','Button Wall','Hidden Walls') then 1 
                  when event_type= 'modal_app_of_the_day_click' and revenue_source = 'App of the Day' then 1
                  end) as clicks,
        count(case when event_type= 'postback' then 1 end)as installs,
        count(case when event_type= 'postback' and dx = 0 then 1 end)as installs_d0,
        sum(bounty) as revenue
from events
group by 1,2,3
union
select  date,
		platform,
        'All Walls' as revenue_source,
        count(case  when event_type= 'revenue_offer_wall_view' and revenue_source in ('Premium Wall','Gated Card Walls','Standard Wall','Button Wall','Hidden Walls') then 1 end)as impressions,
        count(case  when event_type= 'revenue_offer_wall_view' and dx = 0 and revenue_source in ('Premium Wall','Gated Card Walls','Standard Wall','Button Wall','Hidden Walls') then 1 end)as impressions_d0,
        count(case when event_type= 'revenue_offer_detail' and revenue_source in ('Premium Wall','Gated Card Walls','Standard Wall','Button Wall','Hidden Walls') then 1 end) as clicks,
        count(case when event_type= 'postback' and revenue_source in ('Premium Wall','Gated Card Walls','Standard Wall','Button Wall','Hidden Walls') then 1 end)as installs,
        count(case when event_type= 'postback' and dx = 0 and revenue_source in ('Premium Wall','Gated Card Walls','Standard Wall','Button Wall','Hidden Walls') then 1 end)as installs_d0,
        sum(case when event_type= 'postback' and revenue_source in ('Premium Wall','Gated Card Walls','Standard Wall','Button Wall','Hidden Walls') then bounty end) as revenue
from events
group by 1,2,3
order by 1,2,3;