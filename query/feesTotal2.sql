SET @m_startDate :=  '20240201 0000';
SET @m_endDate :=  '20240209 0000';


SELECT id AS operationID, 
       CASE LEFT(entity_id, 3) 
          WHEN  'SUB' THEN 'ADQUIRENCIA'
			 			 
          ELSE 'EMISION'
		 END AS businessLine,
		 'aff_dummy' AS affiliation, 
       'dummy1' AS LEVEL1, 'dummy2' AS LEVEL2, 'dummy3' AS LEVEL3, 'dummy4' AS LEVEL4, 'dummy5' AS LEVEL5, entity_id AS clientID, 'clientName' AS clientName,
       CASE TYPE 
          WHEN   1 THEN 'SPEI Salida'
          WHEN   3 THEN 'SPEI Entrada'
          WHEN   4 THEN 'Book to Book Send'
          WHEN  10 THEN 'TAE'          
          WHEN  11 THEN 'Pago de Servicios' 
          WHEN  12 THEN 'Retiro ATM' 
			 WHEN  13 THEN 'Compra POS' 
			 WHEN  22 THEN 'VISA Nacional'
			 WHEN  23 THEN 'AMEX'
			 WHEN  27 THEN 'Mastercard Nacional'
			 WHEN  29 THEN 'Book to Book Received'
			 WHEN  56 THEN 'Vales'
			 WHEN  57 THEN 'internacional'
			 WHEN 104 THEN 'Deposito en Efectivo'
			 WHEN 105 THEN 'Pago Referenciado'
			 WHEN 106 THEN 'Traspaso Referenciado'
			 WHEN 107 THEN 'Pago Recibido de Convenio'
			 WHEN 108 THEN 'Deposito CITI'
			 WHEN 109 THEN 'Deposito Mixto'
			 WHEN 110 THEN 'Deposito Cheque'
			 			 
          ELSE CONCAT('not defined :', Type)
		 END AS type, 
		 'EN RED' AS LiquidationType,
       CASE status 
          WHEN  31 THEN 'Liquidada'
			 			 
          ELSE CONCAT('not defined :', Type)
		 END AS status, 
		 amount, IFNULL(processingCode, 0.0) AS netAmount, 
		 IFNULL(settleAmount, 0.0) AS totalFee, IFNULL(accountNumber, 0.0) AS fee, IFNULL(systemSource, 0.0) AS FeeTax, 
		 IFNULL(systemTraceAuditNumber, 0.0) AS branchFee, IFNULL(TIMESTAMP, 0.0) AS entityFee, IFNULL(transactionID, 0.0) AS affiliatedFee, 
		 IFNULL(transactionSubType, 0.0) AS onsignaFee, 
		 internalReference, transactionBundler, 
		 DATE_FORMAT(created_at, "%d-%b-%Y %H:%i") AS created_at, 
		 YEAR(created_at) AS YEAR,
		 MONTH(created_at) AS MONTH,
		 DAY(created_at) AS DAY,
		 HOUR(created_at) AS HOUR,
       REPLACE(description, ',', ' ') AS Description, 
		 IFNULL(originalUsername, 'Not Provided') AS merchantName, 
		 IFNULL(originalEmail, 'Not Provited') AS merchantEmail,
		 IFNULL(observation, 'userEmail') AS userEmail 		 
  FROM Operation 
 WHERE DATE_SUB(created_at, INTERVAL 6 HOUR) BETWEEN STR_TO_DATE(@m_startDate, '%Y%m%d %H%i')
                                                 AND STR_TO_DATE(@m_endDate, '%Y%m%d %H%i')
   AND TYPE IN (1, 3, 4, 10, 11, 12, 13, 22, 23, 27, 29, 56, 57, 104, 105, 106, 107, 108, 109, 110)  
   AND STATUS IN (31) 
 ORDER BY created_at ASC ;
 
 
 SELECT COUNT(*) AS counter, SUM(amount) AS amount 
  FROM Operation 
 WHERE DATE_SUB(created_at, INTERVAL 6 HOUR) BETWEEN STR_TO_DATE(@m_startDate, '%Y%m%d %H%i')
                                                 AND STR_TO_DATE(@m_endDate, '%Y%m%d %H%i')
   AND TYPE IN (1, 3, 4, 10, 11, 12, 13, 22, 23, 27, 29, 56, 57, 104, 105, 106, 107, 108, 109, 110)  
   AND STATUS IN (31) ;