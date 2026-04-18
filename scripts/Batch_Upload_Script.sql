-- SQL Script to Load Sample O2C Test Data
-- Execute in SAP Test System (not Production)

-- Create Sample Customers
INSERT INTO KNA1 (KUNNR, NAME1, ORT01, LAND1, WAERK, ZTERM)
VALUES 
  ('C001', 'ABC Corporation', 'New York', 'US', 'USD', 'NT30'),
  ('C002', 'XYZ Industries', 'Los Angeles', 'US', 'USD', 'NT30'),
  ('C003', 'Global Traders', 'London', 'GB', 'GBP', 'NT45');

-- Assign Credit Limits
INSERT INTO CDHDR (MANDANT, OBJECTCLAS, OBJECTID, CHANGENR, CHANGEUSER, CHANGEDATE)
SELECT '100', 'KNA1', KUNNR, 1, 'TEST', CURRENT_DATE FROM KNA1
WHERE KUNNR IN ('C001', 'C002', 'C003');

-- Create Sample Materials
INSERT INTO MARA (MATNR, MTART, MATKL, MEINS, BRGEW, NTGEW)
VALUES 
  ('MAT001', 'FERT', '001', 'EA', 2.5, 2.0),
  ('MAT002', 'FERT', '001', 'EA', 3.0, 2.5),
  ('MAT003', 'FERT', '002', 'KG', 10.0, 9.5);

-- Insert Batch-Managed Material
INSERT INTO MARA (MATNR, MTART, MATKL, MEINS, KZMBF)
VALUES ('MAT004', 'FERT', '002', 'EA', 'X');  -- KZMBF = Batch Management

-- Create Sample Sales Orders
INSERT INTO VBAK (MANDT, VBELN, VBTYP, KUNNR, ERDAT, ERNAM, VKORG, VTWEG)
VALUES 
  ('100', 'SO000001', 'C', 'C001', CURRENT_DATE, 'TEST', '1000', '10'),
  ('100', 'SO000002', 'C', 'C002', CURRENT_DATE, 'TEST', '1000', '10'),
  ('100', 'SO000003', 'C', 'C003', CURRENT_DATE, 'TEST', '1000', '10');

-- Insert Sales Order Line Items
INSERT INTO VBAP (MANDT, VBELN, POSNR, MATNR, KWMENG, MEINS, VRKME, NETPR)
VALUES 
  ('100', 'SO000001', '10', 'MAT001', 100, 'EA', 'EA', 95.00),
  ('100', 'SO000001', '20', 'MAT002', 50, 'EA', 'EA', 120.00),
  ('100', 'SO000002', '10', 'MAT003', 200, 'KG', 'KG', 15.50),
  ('100', 'SO000003', '10', 'MAT004', 75, 'EA', 'EA', 250.00);

-- Create Sample Batches
INSERT INTO MCHA (MANDT, MATNR, CHARG, CHARGEDATE, ERFME, ERFASU, CLOS_FLAG)
VALUES 
  ('100', 'MAT004', 'B202601001', CURRENT_DATE - INTERVAL '30' DAY, '200', 'TEST', ' '),
  ('100', 'MAT004', 'B202602001', CURRENT_DATE - INTERVAL '15' DAY, '150', 'TEST', ' '),
  ('100', 'MAT004', 'B202603001', CURRENT_DATE, '100', 'TEST', ' ');

-- Commit Transaction
COMMIT;

PRINT 'Sample test data loaded successfully';
