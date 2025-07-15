--- Advanced SQL Project -  Spotify

--- EDA ---

select count(*) FROM spotify;

select distinct album_type from spotify;

select distinct album from spotify;

select max(duration_min) from spotify;
select min(duration_min) from spotify;

select * from spotify
where duration_min = 0;

delete from spotify
where duration_min = 0;

select count(distinct channel) from spotify;

select distinct most_played_on from spotify;


------Data Analysis------

select track from spotify
where stream > 1000000000;

select distinct album, Artist
from spotify
order by 1;

select sum(Comments) as Total_comments from spotify
where Licensed = True;

select track from spotify
where album_type = 'single';

select 	Artist,count(track) as count_of_track from spotify
group by Artist
order by 2 desc;

select avg(Danceability) as Avg_Danceability, album
from spotify
group by album
order by 1 desc;

select distinct track, max(Energy) from spotify
group by 1
order by 2 desc
limit 5;

select track,sum(Views) as total_views,sum(Likes) as total_likes from spotify
where official_video = True
group by 1
order by 2 desc
limit 5;

select track,album , sum(views) as total_views from spotify
group by album,track
order by 3 desc;

select *
from
(select track,
coalesce(sum(case when most_played_on = 'Youtube' Then stream End),0) as streamed_on_youtube,
coalesce(sum(case when most_played_on = 'Spotify' Then stream End),0) as streamed_on_spotify
from spotify
group by 1) as sub
where streamed_on_spotify > streamed_on_youtube
and
streamed_on_youtube <> 0;


select artist,track,views
from
(select artist, track , views ,dense_rank() over(partition by artist order by views desc) as rowno
from spotify
) as sub
where rowno in (1,2,3)
;


select track,artist,liveness
from spotify
where liveness > (Select avg(liveness) from spotify)
;



with cte as
(
select
album,(max(energy) - min(energy)) as diff
from spotify
group by 1
)
select *
from cte
order by diff desc;

select distinct album, track, (energy / liveness) as energy_to_live_ratio
from spotify
where (energy / liveness) > 1.2;

select artist,track,views,likes,
sum(likes) over (order by views desc) as cumulative_likes
from spotify
order by Views desc;


