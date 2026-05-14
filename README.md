# Healthcare RAG Pipeline Dataset

## Project Overview

This project implements a Retrieval-Augmented Generation (RAG) healthcare question-answering dataset using structured relational data and semantic embeddings.

The system simulates:
- healthcare document storage
- chunk-based retrieval
- semantic embeddings
- AI-generated responses
- reliability evaluation

The dataset is designed for Track A requirements.




# Dataset Structure

## Tables

### source.csv
Stores healthcare organizations and information sources.

### document.csv
Stores healthcare documents and reports.

### section.csv
Stores sections belonging to documents.

### chunk.csv
Stores text chunks generated from healthcare documents.

### embedding.csv
Stores semantic vector embeddings generated using sentence-transformers.

### topic.csv
Stores healthcare topics.

### chunk_topic.csv
Maps chunks to topics.

### query.csv
Stores simulated user healthcare queries.

### response.csv
Stores generated AI responses.

### retrieved_chunk.csv
Stores retrieved chunks associated with queries.

### evaluation.csv
Stores factuality and consistency evaluation scores.




# Embedding Model

Embeddings were generated using:

- sentence-transformers
- all-MiniLM-L6-v2




# Dataset Statistics

- Total chunks: 1183+
- Total embeddings: 1183+
- Healthcare topics included:
  - dengue
  - malaria
  - diabetes
  - hypertension
  - asthma
  - nutrition
  - mental health
  - cardiovascular diseases




# Data Sources

Healthcare information was collected from publicly available trusted sources including:

- WHO
- CDC
- Mayo Clinic
- NIH / MedlinePlus




# Query Coverage

The SQL queries include:

- aggregation queries
- join queries
- subqueries
- CTE queries
- window function queries




# Import Instructions

## Step 1: Create PostgreSQL Database

CREATE DATABASE healthcare_rag;

Connect to the database:

\c healthcare_rag




## Step 2: Execute Schema

\i queries/schema.sql




## Step 3: Import CSV Files

COPY source
FROM 'data/source.csv'
DELIMITER ','
CSV HEADER;

COPY document
FROM 'data/document.csv'
DELIMITER ','
CSV HEADER;

COPY section
FROM 'data/section.csv'
DELIMITER ','
CSV HEADER;

COPY chunk
FROM 'data/chunk.csv'
DELIMITER ','
CSV HEADER;

COPY embedding
FROM 'data/embedding.csv'
DELIMITER ','
CSV HEADER;

COPY topic
FROM 'data/topic.csv'
DELIMITER ','
CSV HEADER;

COPY chunk_topic
FROM 'data/chunk_topic.csv'
DELIMITER ','
CSV HEADER;

COPY query
FROM 'data/query.csv'
DELIMITER ','
CSV HEADER;

COPY retrieved_chunk
FROM 'data/retrieved_chunk.csv'
DELIMITER ','
CSV HEADER;

COPY response
FROM 'data/response.csv'
DELIMITER ','
CSV HEADER;

COPY evaluation
FROM 'data/evaluation.csv'
DELIMITER ','
CSV HEADER;




## Step 4: Execute SQL Queries

\i queries/queries.sql




# AI Usage Disclosure

AI assistance was used for:
- dataset planning
- SQL query drafting
- documentation support
- embedding workflow guidance

All generated data and project structure were reviewed and validated manually.
