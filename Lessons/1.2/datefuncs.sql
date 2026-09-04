SELECT 
    job_posted_date,
    job_posted_date::DATE AS date,
    job_posted_date::TIME as time,
    job_posted_date::TIMESTAMP AS timestamp,
    job_posted_date::TIMESTAMPTZ AS timestamptz
FROM job_postings_fact
LIMIT 10;

SELECT 
    job_posted_date,
    EXTRACT(YEAR FROM job_posted_date) AS job_posted_year
FROM job_postings_fact;

SELECT 
    '2026-01-01 00:00:00'::TIMESTAMPTZ AT TIME ZONE 'Asia/Dubai';

