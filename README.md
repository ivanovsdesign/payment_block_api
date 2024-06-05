# 🚫 Payment Blocking API

This API allows you to manage transaction blocks for payment delivery to businesses, ensuring secure and fraud-free transactions. 

<i>Notice: it is just an OpenAPI specification made as an assignment<br>Acual service isn't developed yet</i>

## 📜 Table of Contents
- [Overview](#overview)
- [API Endpoints](#api-endpoints)
  - [Block Transactions](#block-transactions)
  - [Unblock Transactions](#unblock-transactions)
  - [Check Block Status](#check-block-status)
  - [Distinguish Client Type](#distinguish-client-type)
- [Schemas](#schemas)
- [Example Usage](#example-usage)

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

### 👤 Distinguish Client Type

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