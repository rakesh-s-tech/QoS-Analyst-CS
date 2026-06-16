
-- incident_log 
-- sla_targets




SELECT COUNT(*) AS total_metrics FROM performance_metrics;
SELECT COUNT(*) AS total_incidents FROM incident_log;
SELECT COUNT(*) AS total_sla_targets FROM sla_targets;

SELECT service_name, COUNT(*) AS records FROM performance_metrics GROUP BY service_name;
SELECT DATE(timestamp) AS date, COUNT(*) AS records FROM performance_metrics GROUP BY DATE(timestamp);

select * from performance_metrics;
select * from incident_log;
select * from sla_targets;

select service_name, timestamp, avg(response_time_ms), avg(api_latency_ms), avg(error_rate_percent) , avg(uptime_percent) from performance_metrics
group by service_name,timestamp
order by service_name;


-- ============================================================
-- QoS Analyst Case Study — Analysis Queries (run AFTER raw.sql)
-- ============================================================

-- 1) Service performance summary vs SLA targets

SELECT p.service_name,
       ROUND(AVG(p.response_time_ms),1)   AS avg_response_ms, s.max_response_time_ms,
       ROUND(AVG(p.api_latency_ms),1)     AS avg_latency_ms,  s.max_api_latency_ms,
       ROUND(AVG(p.error_rate_percent),3) AS avg_error_pct,   s.max_error_rate_percent,
       ROUND(AVG(p.uptime_percent),3)     AS avg_uptime_pct,  s.min_uptime_percent,
       ROUND(MAX(p.response_time_ms),1)   AS peak_response_ms,
       ROUND(MIN(p.uptime_percent),2)     AS min_uptime_pct,
       SUM(p.requests_count)              AS total_requests,
       SUM(CASE WHEN p.response_time_ms>s.max_response_time_ms OR p.api_latency_ms>s.max_api_latency_ms
        OR p.error_rate_percent>s.max_error_rate_percent OR p.uptime_percent<s.min_uptime_percent
      THEN 1 ELSE 0 END) AS breach_hours
FROM performance_metrics p
JOIN sla_targets s 
ON s.service_name = p.service_name
GROUP BY p.service_name;

-- 2) a. SLA breach hours per metric per service

SELECT p.service_name,
  SUM(CASE WHEN p.response_time_ms  > s.max_response_time_ms   THEN 1 ELSE 0 END) AS response_breach_hrs,
  SUM(CASE WHEN p.api_latency_ms    > s.max_api_latency_ms     THEN 1 ELSE 0 END) AS latency_breach_hrs,
  SUM(CASE WHEN p.error_rate_percent> s.max_error_rate_percent THEN 1 ELSE 0 END) AS error_breach_hrs,
  SUM(CASE WHEN p.uptime_percent    < s.min_uptime_percent     THEN 1 ELSE 0 END) AS uptime_breach_hrs
FROM performance_metrics p
JOIN sla_targets s ON s.service_name = p.service_name
GROUP BY p.service_name;

-- b. SLA breach hours per metric per service and timestamp

SELECT p.service_name, p.timestamp,
  SUM(CASE WHEN p.response_time_ms  > s.max_response_time_ms   THEN 1 ELSE 0 END) AS response_breach_hrs,
  SUM(CASE WHEN p.api_latency_ms    > s.max_api_latency_ms     THEN 1 ELSE 0 END) AS latency_breach_hrs,
  SUM(CASE WHEN p.error_rate_percent> s.max_error_rate_percent THEN 1 ELSE 0 END) AS error_breach_hrs,
  SUM(CASE WHEN p.uptime_percent    < s.min_uptime_percent     THEN 1 ELSE 0 END) AS uptime_breach_hrs
FROM performance_metrics p
JOIN sla_targets s ON s.service_name = p.service_name
GROUP BY p.service_name, p.timestamp ;

-- 3) Hourly breach detail - based on SLA metric breached

SELECT p.timestamp, p.service_name, p.response_time_ms, p.api_latency_ms,
       p.error_rate_percent, p.uptime_percent
FROM performance_metrics p
JOIN sla_targets s ON s.service_name = p.service_name
WHERE p.response_time_ms  > s.max_response_time_ms
   OR p.api_latency_ms    > s.max_api_latency_ms
   OR p.error_rate_percent> s.max_error_rate_percent
   OR p.uptime_percent    < s.min_uptime_percent
ORDER BY p.timestamp, p.service_name;


-- 4) Incident durations

SELECT
    incident_id,
    severity,
    service_affected,
    incident_start,
    incident_end,
    TIMESTAMPDIFF(minute, incident_start, incident_end) AS duration_minutes
FROM incident_log
ORDER BY incident_start;

-- 5) Resource saturation during incident window

SELECT service_name, timestamp, cpu_utilization_percent, memory_utilization_percent,
       response_time_ms, error_rate_percent
FROM performance_metrics
WHERE timestamp BETWEEN '2025-01-21 09:00:00' AND '2025-01-21 16:00:00'
ORDER BY timestamp, service_name;

-- 6) Daily breach-hour rollup

SELECT p.service_name, substr(p.timestamp,1,10) AS day,
  SUM(CASE WHEN p.response_time_ms>s.max_response_time_ms OR p.api_latency_ms>s.max_api_latency_ms
        OR p.error_rate_percent>s.max_error_rate_percent OR p.uptime_percent<s.min_uptime_percent
      THEN 1 ELSE 0 END) AS breach_hours
FROM performance_metrics p JOIN sla_targets s ON s.service_name=p.service_name
GROUP BY p.service_name, day ORDER BY p.service_name, day;



-- ----------------------------------------------------------------------------------------------


SELECT count(*)
FROM performance_metrics p
JOIN sla_targets s ON s.service_name = p.service_name
WHERE p.response_time_ms  > s.max_response_time_ms
   OR p.api_latency_ms    > s.max_api_latency_ms
   OR p.error_rate_percent> s.max_error_rate_percent
   OR p.uptime_percent    < s.min_uptime_percent
ORDER BY p.timestamp, p.service_name;

