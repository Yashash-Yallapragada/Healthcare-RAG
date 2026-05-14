-- =========================================================
-- HEALTHCARE RAG DATABASE SCHEMA
-- =========================================================
--
-- Project:
-- Retrieval-Augmented Generation (RAG) Healthcare Dataset
--
-- Description:
-- This schema models a healthcare-focused RAG pipeline
-- including:
--   - healthcare document storage
--   - semantic chunking
--   - vector embeddings
--   - topic classification
--   - semantic retrieval
--   - AI-generated responses
--   - reliability evaluation
--
-- Database:
-- Microsoft SQL Server
--
-- Embedding Model:
-- sentence-transformers/all-MiniLM-L6-v2
--
-- =========================================================


-- =========================================================
-- 1. SOURCE
-- Stores trusted healthcare organizations
-- =========================================================

CREATE TABLE source (
    source_id INT PRIMARY KEY,
    source_name VARCHAR(255) NOT NULL,
    organization_type VARCHAR(100) NOT NULL,
    source_url VARCHAR(500),
    source_reliability VARCHAR(100)
);


-- =========================================================
-- 2. DOCUMENT
-- Stores healthcare documents and reports
-- =========================================================

CREATE TABLE document (
    document_id INT PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    publication_date VARCHAR(50),
    source_id INT,
    document_type VARCHAR(100),
    medical_speciality VARCHAR(255),

    CONSTRAINT FK_document_source
    FOREIGN KEY (source_id)
    REFERENCES source(source_id)
);


-- =========================================================
-- 3. SECTION
-- Stores document sections
-- =========================================================

CREATE TABLE section (
    section_id INT PRIMARY KEY,
    document_id INT,
    section_title VARCHAR(255) NOT NULL,

    CONSTRAINT FK_section_document
    FOREIGN KEY (document_id)
    REFERENCES document(document_id)
);


-- =========================================================
-- 4. CHUNK
-- Stores semantic text chunks
-- =========================================================

CREATE TABLE chunk (
    chunk_id SMALLINT PRIMARY KEY,
    chunk_text VARCHAR(MAX) NOT NULL,
    chunk_index INT,
    section_id INT,

    CONSTRAINT FK_chunk_section
    FOREIGN KEY (section_id)
    REFERENCES section(section_id)
);


-- =========================================================
-- 5. EMBEDDING
-- Stores vector embeddings for semantic retrieval
-- =========================================================

CREATE TABLE embedding (
    embedding_id INT PRIMARY KEY,
    chunk_id SMALLINT,
    embedding_model VARCHAR(255),
    embedding_vector VARCHAR(MAX) NOT NULL,

    CONSTRAINT FK_embedding_chunk
    FOREIGN KEY (chunk_id)
    REFERENCES chunk(chunk_id)
);


-- =========================================================
-- 6. TOPIC
-- Stores healthcare topics/categories
-- =========================================================

CREATE TABLE topic (
    topic_id SMALLINT PRIMARY KEY,
    topic_name VARCHAR(255) NOT NULL,
    topic_category VARCHAR(100)
);


-- =========================================================
-- 7. CHUNK_TOPIC
-- Many-to-many mapping between chunks and topics
-- =========================================================

CREATE TABLE chunk_topic (
    chunk_id SMALLINT NOT NULL,
    topic_id SMALLINT NOT NULL,

    CONSTRAINT PK_chunk_topic
    PRIMARY KEY (chunk_id, topic_id),

    CONSTRAINT FK_chunktopic_chunk
    FOREIGN KEY (chunk_id)
    REFERENCES chunk(chunk_id),

    CONSTRAINT FK_chunktopic_topic
    FOREIGN KEY (topic_id)
    REFERENCES topic(topic_id)
);


-- =========================================================
-- 8. USER_QUERY
-- Stores healthcare-related user questions
-- =========================================================

CREATE TABLE user_query (
    query_id INT PRIMARY KEY,
    query_text VARCHAR(MAX) NOT NULL,
    query_timestamp DATETIME
);


-- =========================================================
-- 9. RETRIEVED_CHUNK
-- Stores semantic retrieval mappings
-- =========================================================

CREATE TABLE retrieved_chunk (
    query_id INT NOT NULL,
    chunk_id SMALLINT NOT NULL,
    relevance_score DECIMAL(4,3),

    CONSTRAINT PK_retrieved_chunk
    PRIMARY KEY (query_id, chunk_id),

    CONSTRAINT FK_retrieved_query
    FOREIGN KEY (query_id)
    REFERENCES user_query(query_id),

    CONSTRAINT FK_retrieved_chunk
    FOREIGN KEY (chunk_id)
    REFERENCES chunk(chunk_id)
);


-- =========================================================
-- 10. RESPONSE
-- Stores AI-generated responses
-- =========================================================

CREATE TABLE response (
    response_id INT PRIMARY KEY,
    query_id INT,
    generated_answer NVARCHAR(MAX) NOT NULL,

    confidence_score DECIMAL(4,3)
    CHECK (confidence_score BETWEEN 0 AND 1),

    CONSTRAINT FK_response_query
    FOREIGN KEY (query_id)
    REFERENCES user_query(query_id)
);


-- =========================================================
-- 11. EVALUATION
-- Stores response reliability metrics
-- =========================================================

CREATE TABLE evaluation (
    evaluation_id INT PRIMARY KEY,
    response_id INT,

    factuality_score DECIMAL(4,3)
    CHECK (factuality_score BETWEEN 0 AND 1),

    consistency_score DECIMAL(4,3)
    CHECK (consistency_score BETWEEN 0 AND 1),

    notes VARCHAR(MAX),
    response_timestamp DATETIME,

    CONSTRAINT FK_evaluation_response
    FOREIGN KEY (response_id)
    REFERENCES response(response_id)
);


-- =========================================================
-- INDEXES FOR PERFORMANCE OPTIMIZATION
-- =========================================================

CREATE INDEX idx_chunk_section
ON chunk(section_id);

CREATE INDEX idx_embedding_chunk
ON embedding(chunk_id);

CREATE INDEX idx_retrieved_query
ON retrieved_chunk(query_id);

CREATE INDEX idx_response_query
ON response(query_id);