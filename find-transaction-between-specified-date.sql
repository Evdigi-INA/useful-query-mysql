-- Description: Find transaction between specified date
-- Author: @rachyharkov
-- Date: 2023-01-01
-- Biasanya kita ingin mengetahui transaksi yang terjadi pada periode tertentu menggunakan between. Misalnya, transaksi yang terjadi pada bulan Februari 2022 (BETWEEN 2022-02-01 AND 2022-02-28). Tetapi, bagaimana jika kita ingin mengetahui transaksi yang terjadi pada periode tertentu yang tidak beraturan? Misalnya, transaksi yang terjadi pada periode 1 Februari 2022 sampai 30 April 2022 (BETWEEN 2022-02-01 AND 2022-04-30). Kita bisa menggunakan query berikut ini:

SET @date_min = '2022-02-01';
SET @date_max = '2022-04-30';
SELECT
	date_generator.date,
	IFNULL(
	SUM( -- jumlahkan
		IF( -- jika
			transactions.merchant_id = 100 AND -- merchant_id = 100
			transactions.status = 'paid', -- status = paid
			transactions.amount, -- return amount yang dijumlahkan
			0 -- jika tidak, return 0 (tidak mungkin menghasilkan nilai lebih dari 0)
		)
	),0) AS 'y'
FROM 
-- generate tanggal dari @date_min sampai @date_max
	(
		SELECT 
		DATE_ADD(@date_min, INTERVAL (@i:=@i+1)-1 DAY) AS 'date'
		FROM 
			information_schema.columns,(SELECT @i:=0) gen_sub
		WHERE 
			DATE_ADD(@date_min, INTERVAL @i DAY) BETWEEN @date_min AND @date_max
	) 
date_generator
-- end
LEFT JOIN transactions ON transactions.created_at = date_generator.date
GROUP BY date;

-- Nah loh, Pusing pusing dah lu kwkwkk, Tapi Kita bisa menggunakan query tersebut untuk menemukan transaksi dengan tanggal yang tidak beraturan dan output sesuai harapan bukan?, silahkan ubah periode yang diinginkan pada variabel @date_min dan @date_max