# Transaction Blocking Schema

## Overview

This schema supports the functionality required for blocking and unblocking transactions for clients based on various reasons. It consists of tables for managing clients, client types, transaction blocks, and blocking reasons.

## Tables

### 1. ClientTypes
Stores the types of clients.

| Column        | Type         | Description                  |
|---------------|--------------|------------------------------|
| clientTypeId  | INT          | Primary key, auto-increment  |
| clientTypeName| VARCHAR(50)  | Unique client type name      |

### 2. BlockingReasons
Stores the reasons for blocking transactions.

| Column          | Type         | Description                       |
|-----------------|--------------|-----------------------------------|
| reasonId        | INT          | Primary key, auto-increment       |
| reasonDescription | VARCHAR(255)| Unique reason description         |

### 3. Clients
Stores the client information.

| Column        | Type         | Description                             |
|---------------|--------------|-----------------------------------------|
| clientId      | INT          | Primary key, auto-increment             |
| clientTypeId  | INT          | Foreign key referencing ClientTypes     |

### 4. TransactionBlocks
Stores information about transaction blocks.

| Column      | Type        | Description                             |
|-------------|-------------|-----------------------------------------|
| blockId     | INT         | Primary key, auto-increment             |
| clientId    | INT         | Foreign key referencing Clients         |
| isBlocked   | BOOLEAN     | Indicates if the client is blocked      |
| reasonId    | INT         | Foreign key referencing BlockingReasons |
| blockedAt   | TIMESTAMP   | Timestamp when the block was applied    |

## Relationships

- `Clients.clientTypeId` → `ClientTypes.clientTypeId`
- `TransactionBlocks.clientId` → `Clients.clientId`
- `TransactionBlocks.reasonId` → `BlockingReasons.reasonId`

## Example Queries

### Block a Client
```sql
INSERT INTO transaction_blocking.TransactionBlocks (clientId, isBlocked, reasonId)
VALUES (1, TRUE, (SELECT reasonId FROM transaction_blocking.BlockingReasons WHERE reasonDescription = 'Fraudulent activity detected'));
```