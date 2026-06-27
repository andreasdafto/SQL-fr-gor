# SQLite Schema Columns

Database: `C:\CS-Python\SQL-frågor\CS-Statistik.db`
Tables: 23
Columns: 319

## Tables

| Table | Rows | Columns | Primary key columns |
|---|---:|---:|---|
| AccountingItem | 416063 | 22 | AccountingItemId |
| AccountingItemDeleted | 0 | 9 | DeletedId |
| Booking | 43574 | 34 | BookingId |
| BookingDelete | 9548 | 18 | Id |
| BookingHist | 0 | 28 | BookingId |
| BookingItem | 1541 | 8 | BookingItemId |
| BookingItemType | 70 | 8 | BookingItemTypeId |
| BookingStatus | 16 | 7 | BookingStatusId |
| Customer | 25073 | 19 | CustomerId |
| CustomerDeleted | 217 | 9 | DeletedId |
| CustomerType | 24 | 7 | CustomerTypeId |
| GroupBooking | 977 | 12 | GroupId |
| Grouplines | 4057 | 11 | GrouplineId |
| InvoiceItem | 220626 | 22 | InvoiceItemId |
| Item | 16191 | 22 | ItemId |
| ItemGroup | 99 | 7 | ItemGroupId |
| KeyCardDeleted | 59363 | 9 | DeletedId, Timestamp |
| KeyCards | 172262 | 24 | Id |
| KeycardLog | 0 | 13 |  |
| RegisterItem | 335977 | 12 | ReceiptNo, ItemId, Date |
| RegisterSumItem | 0 | 9 | ItemId |
| SyncState | 1 | 2 | TargetName |
| Usern | 105 | 7 | UserId |

## AccountingItem

Rows: 416063

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | AccountingItemId | INT | 1 | 0 |  |
| 2 | OrderId | INT | 0 | 0 |  |
| 3 | ItemId | varchar(50) | 0 | 0 |  |
| 4 | CustomerId | INT | 0 | 0 |  |
| 5 | FromDate | datetime | 0 | 0 |  |
| 6 | ToDate | Datetime | 0 | 0 |  |
| 7 | FromValue | Decimal | 0 | 0 |  |
| 8 | ToValue | Decimal | 0 | 0 |  |
| 9 | ItemName | varchar(50) | 0 | 0 |  |
| 10 | Quantity | Decimal | 0 | 0 |  |
| 11 | TotalPrice | Decimal | 0 | 0 |  |
| 12 | CreatedBy | INT | 0 | 0 |  |
| 13 | CreatedAt | datetime | 0 | 0 |  |
| 14 | UpdatedBy | INT | 0 | 0 |  |
| 15 | UpdatedAt | datetime | 0 | 0 |  |
| 16 | KeyType | varchar(1) | 0 | 0 |  |
| 17 | KeyValue | INT | 0 | 0 |  |
| 18 | SiteId | varchar(8) | 0 | 0 |  |
| 19 | Deleted | INTEGER | 0 | 0 | 0 |
| 20 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 21 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 22 | ImportSourceDate | TEXT | 0 | 0 |  |

## AccountingItemDeleted

Rows: 0

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | DeletedId | INT | 1 | 0 |  |
| 2 | Timestamp | datetime | 0 | 0 |  |
| 3 | Station | varchar(8) | 0 | 0 |  |
| 4 | UserId | INT | 0 | 0 |  |
| 5 | SiteId | varchar(8) | 0 | 0 |  |
| 6 | Deleted | INTEGER | 0 | 0 | 0 |
| 7 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 8 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 9 | ImportSourceDate | TEXT | 0 | 0 |  |

## Booking

Rows: 43574

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | BookingId | INT | 1 | 0 |  |
| 2 | CustomerId | INT | 0 | 0 |  |
| 3 | BookingItemId | varchar(8) | 0 | 0 |  |
| 4 | FromDate | datetime | 0 | 0 |  |
| 5 | ToDate | datetime | 0 | 0 |  |
| 6 | GroupId | INT | 0 | 0 |  |
| 7 | CreatedAt | datetime | 0 | 0 |  |
| 8 | CreatedBy | INT | 0 | 0 |  |
| 9 | UpdatedAt | datetime | 0 | 0 |  |
| 10 | UpdatedBy | INT | 0 | 0 |  |
| 11 | CustomerTypeId | varchar(2) | 0 | 0 |  |
| 12 | Ordersource | varchar(50) | 0 | 0 |  |
| 13 | SubOrdersource | varchar(50) | 0 | 0 |  |
| 14 | OrderId | varchar(50) | 0 | 0 |  |
| 15 | BookingStatusId | varchar(1) | 0 | 0 |  |
| 16 | DueDate | datetime | 0 | 0 |  |
| 17 | DueDate2 | datetime | 0 | 0 |  |
| 18 | PartPayment1 | Decimal | 0 | 0 |  |
| 19 | PartPayment2 | decimal | 0 | 0 |  |
| 20 | GrouplineId | int(20) | 0 | 0 |  |
| 21 | Miscellaneous1 | varchar(15) | 0 | 0 |  |
| 22 | Miscellaneous2 | varchar(15) | 0 | 0 |  |
| 23 | SiteId | varchar(8) | 0 | 0 |  |
| 24 | Parts | int(10) | 0 | 0 |  |
| 25 | Deleted | INTEGER | 0 | 0 | 0 |
| 26 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 27 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 28 | ImportSourceDate | TEXT | 0 | 0 |  |
| 29 | BookingImportStatus | TEXT | 0 | 0 |  |
| 30 | FirstSeenAt | TEXT | 0 | 0 |  |
| 31 | LastSeenAt | TEXT | 0 | 0 |  |
| 32 | CancelledDetectedAt | TEXT | 0 | 0 |  |
| 33 | EndedEarlyDetectedAt | TEXT | 0 | 0 |  |
| 34 | CompletedDetectedAt | TEXT | 0 | 0 |  |

## BookingDelete

Rows: 9548

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | Id | INT | 1 | 0 |  |
| 2 | BookingId | INT | 0 | 0 |  |
| 3 | CustomerId | INT | 0 | 0 |  |
| 4 | BookingItemId | VARCHAR(8) | 0 | 0 |  |
| 5 | FromDate | DATETIME | 0 | 0 |  |
| 6 | ToDate | DATETIME | 0 | 0 |  |
| 7 | ByUser | INT | 0 | 0 |  |
| 8 | EventDate | DATETIME | 0 | 0 |  |
| 9 | Event | VARCHAR(50) | 0 | 0 |  |
| 10 | EventTypeId | INT | 0 | 0 |  |
| 11 | EventDescription | VARCHAR(50) | 0 | 0 |  |
| 12 | SiteId | VARCHAR(8) | 0 | 0 |  |
| 13 | DeletedBy | VARCHAR(50) | 0 | 0 |  |
| 14 | DeleteReason | VARCHAR(50) | 0 | 0 |  |
| 15 | Deleted | INTEGER | 0 | 0 | 0 |
| 16 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 17 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 18 | ImportSourceDate | TEXT | 0 | 0 |  |

## BookingHist

Rows: 0

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | BookingId | INT | 1 | 0 |  |
| 2 | CustomerId | INT | 0 | 0 |  |
| 3 | BookingItemId | varchar(8) | 0 | 0 |  |
| 4 | FromDate | datetime | 0 | 0 |  |
| 5 | ToDate | datetime | 0 | 0 |  |
| 6 | GroupId | INT | 0 | 0 |  |
| 7 | CreatedAt | datetime | 0 | 0 |  |
| 8 | CreatedBy | INT | 0 | 0 |  |
| 9 | UpdatedAt | datetime | 0 | 0 |  |
| 10 | UpdatedBy | INT | 0 | 0 |  |
| 11 | CustomerTypeId | varchar(2) | 0 | 0 |  |
| 12 | Ordersource | varchar(50) | 0 | 0 |  |
| 13 | SubOrdersource | varchar(50) | 0 | 0 |  |
| 14 | OrderId | varchar(50) | 0 | 0 |  |
| 15 | BookingStatusId | varchar(1) | 0 | 0 |  |
| 16 | DueDate | datetime | 0 | 0 |  |
| 17 | DueDate2 | datetime | 0 | 0 |  |
| 18 | PartPayment1 | Decimal | 0 | 0 |  |
| 19 | PartPayment2 | decimal | 0 | 0 |  |
| 20 | GrouplineId | int(20) | 0 | 0 |  |
| 21 | Miscellaneous1 | varchar(15) | 0 | 0 |  |
| 22 | Miscellaneous2 | varchar(15) | 0 | 0 |  |
| 23 | SiteId | varchar(8) | 0 | 0 |  |
| 24 | Parts | int(10) | 0 | 0 |  |
| 25 | Deleted | INTEGER | 0 | 0 | 0 |
| 26 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 27 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 28 | ImportSourceDate | TEXT | 0 | 0 |  |

## BookingItem

Rows: 1541

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | BookingItemId | varchar(8) | 1 | 0 |  |
| 2 | Description | varchar(40) | 0 | 0 |  |
| 3 | BookingItemTypeId | INT | 0 | 0 |  |
| 4 | SiteId | varchar(8) | 0 | 0 |  |
| 5 | Deleted | INTEGER | 0 | 0 | 0 |
| 6 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 7 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 8 | ImportSourceDate | TEXT | 0 | 0 |  |

## BookingItemType

Rows: 70

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | BookingItemTypeId | INT | 1 | 0 |  |
| 2 | Description | varchar(50) | 0 | 0 |  |
| 3 | SiteId | varchar(8) | 0 | 0 |  |
| 4 | Purpose | INT | 0 | 0 |  |
| 5 | Deleted | INTEGER | 0 | 0 | 0 |
| 6 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 7 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 8 | ImportSourceDate | TEXT | 0 | 0 |  |

## BookingStatus

Rows: 16

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | BookingStatusId | varchar(8) | 1 | 0 |  |
| 2 | Description | varchar(50) | 0 | 0 |  |
| 3 | SiteId | varchar(8) | 0 | 0 |  |
| 4 | Deleted | INTEGER | 0 | 0 | 0 |
| 5 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 6 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 7 | ImportSourceDate | TEXT | 0 | 0 |  |

## Customer

Rows: 25073

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | CustomerId | INT | 1 | 0 |  |
| 2 | PostalCode | varchar(8) | 0 | 0 |  |
| 3 | City | varchar(30) | 0 | 0 |  |
| 4 | Country | varchar(4) | 0 | 0 |  |
| 5 | HasEmail | BIT | 0 | 0 |  |
| 6 | HasPhone | BIT | 0 | 0 |  |
| 7 | CustomerTypeId | varchar(2) | 0 | 0 |  |
| 8 | CreatedBy | INT | 0 | 0 |  |
| 9 | CreatedAt | datetime | 0 | 0 |  |
| 10 | UpdatedBy | INT | 0 | 0 |  |
| 11 | UpdatedAt | datetime | 0 | 0 |  |
| 12 | SiteId | varchar(8) | 0 | 0 |  |
| 13 | Newsletter | varchar(70) | 0 | 0 |  |
| 14 | Flag | varchar(10) | 0 | 0 |  |
| 15 | IsoCountry | VARCHAR(2) | 0 | 0 |  |
| 16 | Deleted | INTEGER | 0 | 0 | 0 |
| 17 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 18 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 19 | ImportSourceDate | TEXT | 0 | 0 |  |

## CustomerDeleted

Rows: 217

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | DeletedId | INT | 1 | 0 |  |
| 2 | Timestamp | datetime | 0 | 0 |  |
| 3 | Station | VARCHAR(8) | 0 | 0 |  |
| 4 | UserId | INT | 0 | 0 |  |
| 5 | SiteId | VARCHAR(8) | 0 | 0 |  |
| 6 | Deleted | INTEGER | 0 | 0 | 0 |
| 7 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 8 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 9 | ImportSourceDate | TEXT | 0 | 0 |  |

## CustomerType

Rows: 24

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | CustomerTypeId | VARCHAR(2) | 1 | 0 |  |
| 2 | Name | VARCHAR(30) | 0 | 0 |  |
| 3 | SiteId | VARCHAR(8) | 0 | 0 |  |
| 4 | Deleted | INTEGER | 0 | 0 | 0 |
| 5 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 6 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 7 | ImportSourceDate | TEXT | 0 | 0 |  |

## GroupBooking

Rows: 977

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | GroupId | INT | 1 | 0 |  |
| 2 | Description | VARCHAR(50) | 0 | 0 |  |
| 3 | CustomerId | INT | 0 | 0 |  |
| 4 | FromDate | DATETIME | 0 | 0 |  |
| 5 | ToDate | DATETIME | 0 | 0 |  |
| 6 | GroupType | VARCHAR(8) | 0 | 0 |  |
| 7 | ProfileId | INT | 0 | 0 |  |
| 8 | SiteId | VARCHAR(8) | 0 | 0 |  |
| 9 | Deleted | INTEGER | 0 | 0 | 0 |
| 10 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 11 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 12 | ImportSourceDate | TEXT | 0 | 0 |  |

## Grouplines

Rows: 4057

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | GrouplineId | INT | 1 | 0 |  |
| 2 | GroupId | INT | 0 | 0 |  |
| 3 | NumberOfParts | INT | 0 | 0 |  |
| 4 | Relation | INT | 0 | 0 |  |
| 5 | FromDate | DATETIME | 0 | 0 |  |
| 6 | ToDate | DATETIME | 0 | 0 |  |
| 7 | SiteId | VARCHAR(8) | 0 | 0 |  |
| 8 | Deleted | INTEGER | 0 | 0 | 0 |
| 9 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 10 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 11 | ImportSourceDate | TEXT | 0 | 0 |  |

## InvoiceItem

Rows: 220626

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | InvoiceItemId | INT | 1 | 0 |  |
| 2 | InvoiceId | INT | 0 | 0 |  |
| 3 | BookingId | INT | 0 | 0 |  |
| 4 | CustomerId | INT | 0 | 0 |  |
| 5 | GroupId | INT | 0 | 0 |  |
| 6 | InvoiceDate | DATETIME | 0 | 0 |  |
| 7 | InvoiceAmount | DECIMAL | 0 | 0 |  |
| 8 | TotalTurnover | DECIMAL | 0 | 0 |  |
| 9 | PayedAmount | DECIMAL | 0 | 0 |  |
| 10 | EqualizedAmount | DECIMAL | 0 | 0 |  |
| 11 | DueDate | DATETIME | 0 | 0 |  |
| 12 | Status | VARCHAR(12) | 0 | 0 |  |
| 13 | CashierNo | INT | 0 | 0 |  |
| 14 | UserId | INT | 0 | 0 |  |
| 15 | Ordersource | VARCHAR(15) | 0 | 0 |  |
| 16 | SubOrdersource | VARCHAR(15) | 0 | 0 |  |
| 17 | OrderId | VARCHAR(20) | 0 | 0 |  |
| 18 | SiteId | VARCHAR(8) | 0 | 0 |  |
| 19 | Deleted | INTEGER | 0 | 0 | 0 |
| 20 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 21 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 22 | ImportSourceDate | TEXT | 0 | 0 |  |

## Item

Rows: 16191

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | ItemId | VARCHAR(50) | 1 | 0 |  |
| 2 | ItemName | VARCHAR(50) | 0 | 0 |  |
| 3 | SettlementType | VARCHAR(1) | 0 | 0 |  |
| 4 | IsPayment | BIT | 0 | 0 |  |
| 5 | VatProcentage | DECIMAL | 0 | 0 |  |
| 6 | AccountNo | VARCHAR(10) | 0 | 0 |  |
| 7 | ItemGroupId | INT | 0 | 0 |  |
| 8 | EANBarcode | VARCHAR(15) | 0 | 0 |  |
| 9 | SiteId | VARCHAR(8) | 0 | 0 |  |
| 10 | Unit | VARCHAR(10) | 0 | 0 |  |
| 11 | KeyType | VARCHAR(10) | 0 | 0 |  |
| 12 | NumberOfClips1 | int(3) | 0 | 0 |  |
| 13 | NumberOfClips2 | int(3) | 0 | 0 |  |
| 14 | NumberOfClips3 | int(3) | 0 | 0 |  |
| 15 | Switches | VARCHAR(10) | 0 | 0 |  |
| 16 | Deleted | INTEGER | 0 | 0 | 0 |
| 17 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 18 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 19 | ImportSourceDate | TEXT | 0 | 0 |  |
| 20 | CostPrice | DECIMAL | 0 | 0 |  |
| 21 | Currency | VARCHAR(3) | 0 | 0 |  |
| 22 | Tags | VARCHAR(40) | 0 | 0 |  |

## ItemGroup

Rows: 99

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | ItemGroupId | INT | 1 | 0 |  |
| 2 | Description | VARCHAR(50) | 0 | 0 |  |
| 3 | SiteId | VARCHAR(8) | 0 | 0 |  |
| 4 | Deleted | INTEGER | 0 | 0 | 0 |
| 5 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 6 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 7 | ImportSourceDate | TEXT | 0 | 0 |  |

## KeyCardDeleted

Rows: 59363

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | DeletedId | INTEGER | 1 | 0 |  |
| 2 | Timestamp | DATETIME | 2 | 0 |  |
| 3 | Station | varchar(8) | 0 | 0 |  |
| 4 | UserId | INT | 0 | 0 |  |
| 5 | SiteId | varchar(8) | 0 | 0 |  |
| 6 | Deleted | INTEGER | 0 | 0 | 0 |
| 7 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 8 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 9 | ImportSourceDate | TEXT | 0 | 0 |  |

## KeyCards

Rows: 172262

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | Id | INTEGER | 1 | 0 |  |
| 2 | CustomerId | INT | 0 | 0 |  |
| 3 | KeyType | VARCHAR(3) | 0 | 0 |  |
| 4 | CardId | VARCHAR(40) | 0 | 0 |  |
| 5 | FromDate | DATETIME | 0 | 0 |  |
| 6 | ToDate | DATETIME | 0 | 0 |  |
| 7 | Status | VARCHAR(1) | 0 | 0 |  |
| 8 | Balance | DECIMAL | 0 | 0 |  |
| 9 | BookingItemId | VARCHAR(8) | 0 | 0 |  |
| 10 | CreatedAt | DATETIME | 0 | 0 |  |
| 11 | CreatedBy | INT | 0 | 0 |  |
| 12 | UpdatedAt | DATETIME | 0 | 0 |  |
| 13 | UpdatedBy | INT | 0 | 0 |  |
| 14 | PointBalance1 | INT | 0 | 0 |  |
| 15 | PointBalance2 | INT | 0 | 0 |  |
| 16 | PointBalance3 | INT | 0 | 0 |  |
| 17 | SiteId | VARCHAR(8) | 0 | 0 |  |
| 18 | ActiveZone | varchar(50) | 0 | 0 |  |
| 19 | ItemId | int(50) | 0 | 0 |  |
| 20 | Price | DECIMAL | 0 | 0 |  |
| 21 | Deleted | INTEGER | 0 | 0 | 0 |
| 22 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 23 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 24 | ImportSourceDate | TEXT | 0 | 0 |  |

## KeycardLog

Rows: 0

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | Id | INT | 0 | 0 |  |
| 2 | CustomerId | INT | 0 | 0 |  |
| 3 | KeyCardId | INT | 0 | 0 |  |
| 4 | Date | DATETIME | 0 | 0 |  |
| 5 | Saldo | DECIMAL | 0 | 0 |  |
| 6 | SaldoAfter | DECIMAL | 0 | 0 |  |
| 7 | Status | INT | 0 | 0 |  |
| 8 | StatusText | VARCHAR | 0 | 0 |  |
| 9 | Deleted | INTEGER | 0 | 0 | 0 |
| 10 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 11 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 12 | ImportSourceDate | TEXT | 0 | 0 |  |
| 13 | SiteId | VARCHAR(8) | 0 | 0 |  |

## RegisterItem

Rows: 335977

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | ReceiptNo | INT | 3 | 0 |  |
| 2 | ItemId | VARCHAR(100) | 1 | 0 |  |
| 3 | Date | DATETIME | 2 | 0 |  |
| 4 | Quantity | decimal | 0 | 0 |  |
| 5 | TotalAmount | DECIMAL | 0 | 0 |  |
| 6 | Register | INT | 0 | 0 |  |
| 7 | UserId | INT | 0 | 0 |  |
| 8 | SiteId | VARCHAR(8) | 0 | 0 |  |
| 9 | Deleted | INTEGER | 0 | 0 | 0 |
| 10 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 11 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 12 | ImportSourceDate | TEXT | 0 | 0 |  |

## RegisterSumItem

Rows: 0

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | ItemId | VARCHAR(100) | 1 | 0 |  |
| 2 | Date | DATE | 0 | 0 |  |
| 3 | Quantity | DECIMAL | 0 | 0 |  |
| 4 | TotalAmount | DECIMAL | 0 | 0 |  |
| 5 | SiteId | VARCHAR(8) | 0 | 0 |  |
| 6 | Deleted | INTEGER | 0 | 0 | 0 |
| 7 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 8 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 9 | ImportSourceDate | TEXT | 0 | 0 |  |

## SyncState

Rows: 1

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | TargetName | TEXT | 1 | 0 |  |
| 2 | LastSuccessfulSyncAt | TEXT | 0 | 0 |  |

## Usern

Rows: 105

| # | Column | Type | PK | Not null | Default |
|---:|---|---|---:|---:|---|
| 1 | UserId | INT | 1 | 0 |  |
| 2 | Username | VARCHAR(30) | 0 | 0 |  |
| 3 | SiteId | VARCHAR(8) | 0 | 0 |  |
| 4 | Deleted | INTEGER | 0 | 0 | 0 |
| 5 | ImportFirstSeenAt | TEXT | 0 | 0 |  |
| 6 | ImportUpdatedAt | TEXT | 0 | 0 |  |
| 7 | ImportSourceDate | TEXT | 0 | 0 |  |
