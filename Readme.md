
# QoS Analyst Case Study - MySQL Analysis

## Overview

This project demonstrates Quality of Service (QoS) analysis using MySQL and DBeaver. The analysis focuses on service performance monitoring, SLA compliance, incident management, anomaly detection, and infrastructure resource utilization.

The dataset consists of three primary tables:

* `performance_metrics` - Service performance metrics collected at hourly intervals
* `sla_targets` - SLA thresholds and target values for each service
* `incident_log` - Service incident records with severity and duration information

---

# Technology Stack

| Component     | Tool      |
| ------------- | --------- |
| Database      | MySQL 8.x |
| SQL Client    | DBeaver   |
| Language      | SQL       |

---

# Database Tables

## performance_metrics

Stores service performance metrics collected over time.

### Key Metrics

* Response Time (ms)
* API Latency (ms)
* Error Rate (%)
* Uptime (%)
* CPU Utilization (%)
* Memory Utilization (%)
* Request Count

---

## sla_targets

Defines SLA thresholds for each service.

### SLA Parameters

* Maximum Response Time
* Maximum API Latency
* Maximum Error Rate
* Minimum Uptime

---

## incident_log

Stores service outage and degradation incidents.

### Incident Information

* Incident ID
* Severity
* Affected Service
* Start Time
* End Time

---

# Data Validation Queries

## Total Records Validation

Used to validate successful data loading.

```sql
SELECT COUNT(*) AS total_metrics FROM performance_metrics;

SELECT COUNT(*) AS total_incidents FROM incident_log;

SELECT COUNT(*) AS total_sla_targets FROM sla_targets;
```

---

## Service Distribution

Checks record distribution across services.

```sql
SELECT service_name,
       COUNT(*) AS records
FROM performance_metrics
GROUP BY service_name;
```

---

## Daily Record Distribution

Verifies data availability by date.

```sql
SELECT DATE(timestamp) AS date,
       COUNT(*) AS records
FROM performance_metrics
GROUP BY DATE(timestamp);
```

---

# Analysis Queries

## 1. Service Performance Summary vs SLA Targets

### Objective

Generate a high-level service performance summary and compare actual metrics against SLA targets.

### Metrics Calculated

* Average Response Time
* Average API Latency
* Average Error Rate
* Average Uptime
* Peak Response Time
* Minimum Uptime
* Total Requests
* Total SLA Breach Hours

### Business Value

Provides a consolidated service health report and highlights services that are consistently violating SLA commitments.

---

## 2. SLA Breach Analysis

### 2A. SLA Breach Hours by Service

### Objective

Determine the number of SLA violations per service.

### Breach Categories

* Response Time Breaches
* API Latency Breaches
* Error Rate Breaches
* Uptime Breaches

### Business Value

Identifies recurring service reliability issues and helps prioritize remediation efforts.

---

### 2B. SLA Breach Hours by Service and Timestamp

### Objective

Track SLA violations at an hourly level.

### Business Value

Enables trend analysis and helps identify specific time windows where performance degradation occurred.

---

## 3. Hourly Breach Details

### Objective

Retrieve detailed records where any SLA threshold was violated.

### SLA Conditions

A record is classified as a breach if:

* Response Time exceeds SLA limit
* API Latency exceeds SLA limit
* Error Rate exceeds SLA limit
* Uptime falls below SLA target

### Business Value

Provides detailed evidence for root cause analysis and operational investigations.

---

## 4. Incident Duration Analysis

### Objective

Calculate incident durations using incident start and end timestamps.

### Calculation

```sql
TIMESTAMPDIFF(MINUTE, incident_start, incident_end)
```

### Output

* Incident Duration (Minutes)
* Severity Level
* Affected Service

### Business Value

Measures Mean Time to Recovery (MTTR) and evaluates incident response effectiveness.

---

## 5. Resource Saturation Analysis

### Objective

Analyze infrastructure resource utilization during known incident periods.

### Metrics Analyzed

* CPU Utilization
* Memory Utilization
* Response Time
* Error Rate

### Incident Window

```text
2025-01-21 09:00:00
to
2025-01-21 16:00:00
```

### Business Value

Determines whether performance degradation was caused by resource exhaustion.

---

## 6. Daily SLA Breach Rollup

### Objective

Aggregate SLA breach counts by service and day.

### Output

* Service Name
* Date
* Breach Hours

### Business Value

Supports daily operational reporting and trend analysis.

---

# Key Analytical Objectives

The analysis aims to answer the following questions:

### Service Performance

* Which service performs best against SLA targets?
* Which service experiences the highest latency?

### SLA Compliance

* How many SLA breaches occurred?
* Which metrics are most frequently violated?

### Incident Analysis

* What is the duration of each incident?
* Which services are most affected by incidents?

### Infrastructure Analysis

* Were incidents correlated with CPU or memory saturation?
* Did resource constraints impact response times?

### Operational Monitoring

* Which hours experienced SLA violations?
* Are there recurring performance degradation patterns?

---

# Expected Deliverables

The outputs from these queries can be used to build:

* QoS Dashboard
* SLA Compliance Dashboard
* Incident Monitoring Dashboard
* Service Performance Dashboard
* Infrastructure Utilization Dashboard
* Executive KPI Dashboard

---

# Repository Structure

```text
.
├── raw.sql
├── analysis.sql
├── README.md

```

---

# Author

QoS Analyst Case Study implemented using MySQL and DBeaver for service reliability, SLA compliance, and incident analysis.
