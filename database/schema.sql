CREATE TABLE transaction_blocking.ClientTypes (
    clientTypeId INT AUTO_INCREMENT PRIMARY KEY,
    clientTypeName VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE transaction_blocking.BlockingReasons (
    reasonId INT AUTO_INCREMENT PRIMARY KEY,
    reasonDescription VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE transaction_blocking.Clients (
    clientId INT AUTO_INCREMENT PRIMARY KEY,
    clientTypeId INT,
    FOREIGN KEY (clientTypeId) REFERENCES transaction_blocking.ClientTypes(clientTypeId)
);

CREATE TABLE transaction_blocking.TransactionBlocks (
    blockId INT AUTO_INCREMENT PRIMARY KEY,
    clientId INT,
    isBlocked BOOLEAN NOT NULL DEFAULT FALSE,
    reasonId INT,
    blockedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (clientId) REFERENCES transaction_blocking.Clients(clientId),
    FOREIGN KEY (reasonId) REFERENCES transaction_blocking.BlockingReasons(reasonId)
);


