
create or replace PROCEDURE ADD_BILL(BillBID INT,BillContractID INT,WATERUNIT INT,ELECTRICUNIT INT,StartDate DATE)
IS
    WATERBDID INT;
    ELECTRICBDID INT;
    BillDID INT;
    WaterPrice INT;
    ElectricPrice INT;
    WaterTotal INT;
    ElectricTotal INT;
    TOTAL INT;
    RoomPrice INT;
    CEndDate DATE;
    EndDate DATE;
BEGIN
    SELECT Contract.CEndDate  INTO CEndDate FROM Contract WHERE Contract.ContractID = BillContractID;
    if  CEndDate >= StartDate then
        EndDate := ADD_MONTHS(StartDate, 1)-1;
        INSERT INTO Bill (BID, BStartDate, BEndDate, BTotal,ContractID) VALUES (BillBID, StartDate, EndDate, 0, BillContractID);
        SELECT Contract.DID,Contract.CPrice INTO BillDID,RoomPrice FROM Contract WHERE Contract.ContractID = BillContractID ;
        SELECT BDID,BDPrice INTO WaterBDID,WaterPrice FROM BillDetail WHERE BillDetail.DID = BillDID AND BDType = 1;
        SELECT BDID,BDPrice INTO ElectricBDID,ElectricPrice FROM BillDetail WHERE BillDetail.DID = BillDID AND BDType = 2;
        WaterTotal := WaterPrice * WaterUnit;
        ElectricTotal := ElectricPrice * ElectricUnit;
        INSERT INTO BillList (BID,BDID,BLUnit,BLTotal) VALUES (BillBID, WaterBDID, WaterUnit, WaterTotal);
        INSERT INTO BillList (BID,BDID,BLUnit,BLTotal) VALUES (BillBID, ElectricBDID, ElectricUnit, ElectricTotal);
        Total := WaterTotal + ElectricTotal + RoomPrice;
        UPDATE Bill SET BTotal = Btotal + Total WHERE BillBID = Bill.BID;
    end if;
END;




CREATE OR REPLACE PROCEDURE ADD_Contract(ContractID INT, StartDate DATE, EndDate DATE, Deposit INT,CRoomNo VARCHAR, USERID VARCHAR, DormID INT, Roomtype INT)
IS
    CPrice INT;
BEGIN
    SELECT RPRICE INTO CPRICE FROM ROOMTYPE WHERE ROOMTYPE.RID = Roomtype AND ROOMTYPE.DID = DormID; 
    insert into Contract (ContractID,CStartDate,CEndDate,CDeposite,CRoomNo,CPrice,RID,DID,USERID)
    values (ContractID, StartDate, EndDate, Deposit, CRoomNo, CPrice, Roomtype, DormID, USERID);
END;  



create or replace PROCEDURE INSERT_BILLLIST(BillID INT,ContrID INT,UNIT INT, BillBDType INT)
IS
    BDID INT;
    ContrDID INT;
    BDPrice INT;
    BDTotal INT;

BEGIN
  
    SELECT Contract.DID INTO ContrDID FROM Contract WHERE Contract.ContractID = ContrID;
    SELECT BDID,BDPrice INTO BDID,BDPrice FROM BillDetail WHERE BillDetail.DID = ContrDID AND BillDetail.BDType = BillBDType;
  
    BDTotal := BDPrice * Unit;
    INSERT INTO BillList (BID,BDID,BLUnit,BLTotal) VALUES (BillID, BDID, Unit, BDTotal);
    UPDATE Bill SET BTotal = Btotal + BDTotal WHERE BillID = Bill.BID;
END;
