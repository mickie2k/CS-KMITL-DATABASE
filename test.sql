SELECT MIN(TO_CHAR(BStartDate,'Month')) Month ,MIN(TO_CHAR(BStartDate,'YYYY')) YEAR ,MIN(Dorm.DName) หอพัก , MIN(CName) จังหวัด,MIN(DORMUSER.FName ||' '|| DORMUSER.LName) เจ้าของหอ,
SUM(BTotal) TotalBill,SUM(WList.BLUnit) Water_Unit,SUM(WList.BLTotal) Water_Price,SUM(EList.BLUnit) Electric_Unit,
SUM(EList.BLTotal) Electric_Price,
Count(Contract.ContractID) Tenant  FROM Bill
INNER JOIN Contract ON Bill.ContractID = Contract.ContractID
INNER JOIN DORM ON DORM.DID = Contract.DID
INNER JOIN City ON DORM.CID = City.CID
INNER JOIN DORMUSER ON DORMUSER.USERID = DORM.USERID
INNER JOIN BillList WList ON Bill.BID = WList.BID
INNER JOIN BillDetail WDet ON WDet.BDID = WList.BDID AND  WDet.BDType = 1
INNER JOIN BillList EList ON Bill.BID = EList.BID
INNER JOIN BillDetail EDet ON EDet.BDID = EList.BDID AND  EDet.BDType = 2
WHERE DORM.USERID = 3 
GROUP BY Dorm.DID, extract(year from BStartDate), extract(month from BStartDate)
ORDER BY Dorm.DID, extract(year from BStartDate), extract(month from BStartDate)