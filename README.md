# 🚫 Payment Blocking API

This API allows you to manage transaction blocks for payment delivery to businesses, ensuring secure and fraud-free transactions. 

`payment_block.yaml` contains OpenAPI specs for payment blocking feature
`database/schema.sql` contains script for [database schema](#-database-schema)

<i><b>Notice</b>: it is just an OpenAPI specification made as an assignment<br>Acual service isn't developed yet</i>

## 📜 Table of Contents
- [Overview](#-overview)
- [API Endpoints](#-api-endpoints)
  - [Block Transactions](#-block-transactions)
  - [Unblock Transactions](#-unblock-transactions)
  - [Check Block Status](#-check-block-status)
  - [Distinguish Client Type](#-distinguish-client-type)
- [Schemas](#-schemas)
- [Example Usage](#-example-usage)
- [Database schema](#-database-schema)

## 📝 Overview

This API provides functionalities to:
1. **Block transactions** for a particular client.
2. **Unlock transactions** for a particular client.
3. **Check if a client is blocked**.
4. **Distinguish fraudsters** from ordinary clients.

## 🔌 API Endpoints

### 🚫 Block Transactions

#### `POST /clients/{clientId}/block`

Block transactions for a specific client due to suspicious activity.

**Parameters:**
- `clientId` (string, required): The ID of the client to block.

**Responses:**
- `200 OK`: Client transactions blocked successfully.
- `400 Bad Request`: Invalid client ID.
- `404 Not Found`: Client not found.

### ✅ Unblock Transactions

#### `POST /clients/{clientId}/unblock`

Unblock transactions for a specific client after verification.

**Parameters:**
- `clientId` (string, required): The ID of the client to unblock.

**Responses:**
- `200 OK`: Client transactions unblocked successfully.
- `400 Bad Request`: Invalid client ID.
- `404 Not Found`: Client not found.

### ❓ Check Block Status

#### `GET /clients/{clientId}/status`

Check the blocking status of a client.

**Parameters:**
- `clientId` (string, required): The ID of the client to check.

**Responses:**
- `200 OK`: Blocking status retrieved successfully.
- `400 Bad Request`: Invalid client ID.
- `404 Not Found`: Client not found.

### 👤 Get Client Type

#### `GET /clients/{clientId}/type`

Check if a client is flagged as a fraudster or an ordinary client.

**Parameters:**
- `clientId` (string, required): The ID of the client to check.

**Responses:**
- `200 OK`: Client type retrieved successfully.
- `400 Bad Request`: Invalid client ID.
- `404 Not Found`: Client not found.

## 📂 Schemas

### Client

```yaml
type: object
properties:
  clientId:
    type: string
  isBlocked:
    type: boolean
  reason:
    type: string
  clientType:
    type: string
    enum: [fraudster, ordinary]
```

## 📘 Example Usage
**Block a Client**
```shell
curl -X POST "https://api.paymentdeliveryservice.com/v1/clients/client123/block"
```

**Unblock a Client**
```shell
curl -X POST "https://api.paymentdeliveryservice.com/v1/clients/client123/unblock"
```

**Check if a Client is Blocked**
```shell
curl -X GET "https://api.paymentdeliveryservice.com/v1/clients/client123/status"
```
**Get Client Type**
```shell
curl -X GET "https://api.paymentdeliveryservice.com/v1/clients/client123/type"
```


## 🗄 Database Schema

### Overview

This schema supports the functionality required for blocking and unblocking transactions for clients based on various reasons. It consists of tables for managing clients, client types, transaction blocks, and blocking reasons.

### Tables

#### 1. ClientTypes
Stores the types of clients.

| Column        | Type         | Description                  |
|---------------|--------------|------------------------------|
| clientTypeId  | INT          | Primary key, auto-increment  |
| clientTypeName| VARCHAR(50)  | Unique client type name      |

#### 2. BlockingReasons
Stores the reasons for blocking transactions.

| Column          | Type         | Description                       |
|-----------------|--------------|-----------------------------------|
| reasonId        | INT          | Primary key, auto-increment       |
| reasonDescription | VARCHAR(255)| Unique reason description         |

#### 3. Clients
Stores the client information.

| Column        | Type         | Description                             |
|---------------|--------------|-----------------------------------------|
| clientId      | INT          | Primary key, auto-increment             |
| clientTypeId  | INT          | Foreign key referencing ClientTypes     |

#### 4. TransactionBlocks
Stores information about transaction blocks.

| Column      | Type        | Description                             |
|-------------|-------------|-----------------------------------------|
| blockId     | INT         | Primary key, auto-increment             |
| clientId    | INT         | Foreign key referencing Clients         |
| isBlocked   | BOOLEAN     | Indicates if the client is blocked      |
| reasonId    | INT         | Foreign key referencing BlockingReasons |
| blockedAt   | TIMESTAMP   | Timestamp when the block was applied    |

#### Relationships

- `Clients.clientTypeId` → `ClientTypes.clientTypeId`
- `TransactionBlocks.clientId` → `Clients.clientId`
- `TransactionBlocks.reasonId` → `BlockingReasons.reasonId`

### Example Queries

#### Block a Client
```sql
INSERT INTO transaction_blocking.TransactionBlocks (clientId, isBlocked, reasonId)
VALUES (1, TRUE, (SELECT reasonId FROM transaction_blocking.BlockingReasons WHERE reasonDescription = 'Fraudulent activity detected'));
```

#### Unblock a Client
```sql
UPDATE transaction_blocking.TransactionBlocks
SET isBlocked = FALSE
WHERE clientId = 1 AND isBlocked = TRUE;
```

#### Check if a Client is Blocked
```sql
SELECT isBlocked, (SELECT reasonDescription FROM transaction_blocking.BlockingReasons WHERE reasonId = tb.reasonId) AS reason, blockedAt
FROM transaction_blocking.TransactionBlocks tb
WHERE clientId = 1
ORDER BY blockedAt DESC
LIMIT 1;
```

#### Distinguish Client Type
```sql
SELECT (SELECT clientTypeName FROM transaction_blocking.ClientTypes WHERE clientTypeId = c.clientTypeId) AS clientType
FROM transaction_blocking.Clients c
WHERE clientId = 1;
```

### Example Scenarios
**Scenario 1: Transaction Blocked Due to Fraudulent Activity**
Transaction Attempt: Client with clientId = 1 attempts a transaction.
Fraud Detection: System detects suspicious activity and flags it as potentially fraudulent.

#### Block Transaction:
```sql
INSERT INTO transaction_blocking.TransactionBlocks (clientId, isBlocked, reasonId)
VALUES (1, TRUE, (SELECT reasonId FROM transaction_blocking.BlockingReasons WHERE reasonDescription = 'Fraudulent activity detected'));
```

**Scenario 2: Unblocking After Security Check**
Security Check: After a manual review, the client is cleared of fraudulent activity.

#### Unblock Client:

```sql
UPDATE transaction_blocking.TransactionBlocks
SET isBlocked = FALSE
WHERE clientId = 1 AND isBlocked = TRUE;
```

**Scenario 3: Transaction Blocked Due to Invalid Credentials**
Transaction Attempt: Client with clientId = 2 attempts a transaction.
Credential Check: Client provides invalid credentials, and the transaction is rejected by the bank.

#### Block Transaction:
```sql
INSERT INTO transaction_blocking.TransactionBlocks (clientId, isBlocked, reasonId)
VALUES (2, TRUE, (SELECT reasonId FROM transaction_blocking.BlockingReasons WHERE reasonDescription = 'Invalid credentials'));
```