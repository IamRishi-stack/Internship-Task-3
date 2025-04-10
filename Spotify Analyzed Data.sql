CREATE DATABASE spotify;
USE spotify;

CREATE TABLE spotify_data (
    country VARCHAR(50),
    artist VARCHAR(100),
    album VARCHAR(100),
    genre VARCHAR(50),
    release_year INT,
    monthly_listeners_millions DECIMAL(10,2),
    total_streams_millions DECIMAL(10,2),
    total_hours_streamed_millions DECIMAL(10,2),
    avg_stream_duration_min DECIMAL(5,2),
    platform_type VARCHAR(20),
    streams_last_30_days_millions DECIMAL(10,2),
    skip_rate DECIMAL(5,2)
);
#1. Top-Performing Artists
SELECT 
    artist,
    SUM(total_streams_millions) AS total_streams,
    ROUND(SUM(total_hours_streamed_millions), 2) AS total_hours,
    AVG(skip_rate) AS avg_skip_rate
FROM spotify_data
GROUP BY artist
ORDER BY total_streams DESC
LIMIT 10;

#Genre Popularity by Country
SELECT 
    country,
    genre,
    SUM(streams_last_30_days_millions) AS recent_streams,
    ROUND(SUM(total_hours_streamed_millions) / SUM(total_streams_millions) * 60, 2) AS avg_duration_min
FROM spotify_data
GROUP BY country, genre
ORDER BY country, recent_streams DESC;

#3. Platform Engagement Analysis
SELECT 
    platform_type,
    AVG(avg_stream_duration_min) AS avg_duration,
    AVG(skip_rate) AS avg_skip_rate,
    SUM(streams_last_30_days_millions) AS monthly_activity
FROM spotify_data
GROUP BY platform_type
ORDER BY monthly_activity DESC;

#4. Album Performance Metrics
SELECT 
    artist,
    album,
    release_year,
    total_streams_millions,
    ROUND(total_streams_millions/monthly_listeners_millions, 2) AS streams_per_listener,
    skip_rate
FROM spotify_data
WHERE release_year >= 2020
ORDER BY streams_per_listener DESC
LIMIT 15;

#5. Skip Rate Analysis
SELECT 
    genre,
    AVG(skip_rate) AS avg_skip_rate,
    COUNT(*) AS track_count,
    AVG(avg_stream_duration_min) AS avg_duration
FROM spotify_data
GROUP BY genre
HAVING COUNT(*) > 5
ORDER BY avg_skip_rate DESC;


