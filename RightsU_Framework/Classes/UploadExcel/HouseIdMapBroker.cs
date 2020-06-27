using System;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

public class HouseIdMapBroker : DatabaseBroker
{
    public HouseIdMapBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [tblHouseIdMap] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        HouseIdMap objHouseIdMap;
        if (obj == null)
        {
            objHouseIdMap = new HouseIdMap();
        }
        else
        {
            objHouseIdMap = (HouseIdMap)obj;
        }

        objHouseIdMap.IntCode = Convert.ToInt32(dRow["map_code"]);
        #region --populate--
        objHouseIdMap.mapHouseIdUnk = Convert.ToString(dRow["map_house_id_unk"]);
        objHouseIdMap.mapHouseId = Convert.ToString(dRow["map_house_id"]);
        objHouseIdMap.title = Convert.ToString(dRow["title"]);
        if (dRow["last_updated_by"] != DBNull.Value)
            objHouseIdMap.LastUpdatedBy = Convert.ToInt32(dRow["last_updated_by"]);
        if (dRow["last_updated_on"] != DBNull.Value)
            objHouseIdMap.LastUpdatedOn = Convert.ToDateTime(dRow["last_updated_on"]);
        objHouseIdMap.src = Convert.ToString(dRow["src"]);
        objHouseIdMap.fileID = Convert.ToString(dRow["fileID"]);
        #endregion
        return objHouseIdMap;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        HouseIdMap objHouseIdMap = (HouseIdMap)obj;
        bool ChkDuplicate = false;
        bool IsValid = false;
        ChkDuplicate = DBUtil.IsDuplicateSqlTrans(ref obj, "Deal_Movie_Contents_HouseID", "House_ID", objHouseIdMap.mapHouseId, "Deal_Movie_Contents_HouseID_Code", 0, "House ID not exists", "", false);
        if (ChkDuplicate)
        {
            IsValid = false;
        }
        else
        {
            throw new DuplicateRecordException("House ID not exists");
        }
            

        return IsValid;
    }

    public override string GetInsertSql(Persistent obj)
    {
        HouseIdMap objHouseIdMap = (HouseIdMap)obj;
        return "insert into [tblHouseIdMap]([map_house_id_unk], [map_house_id], [title], [last_updated_by], [last_updated_on], [src],[fileID]) values('" + objHouseIdMap.mapHouseIdUnk.Trim().Replace("'", "''") + "', '" + objHouseIdMap.mapHouseId.Trim().Replace("'", "''") + "', '" + objHouseIdMap.title.Trim().Replace("'", "''") + "', '" + objHouseIdMap.LastUpdatedBy + "', '" + objHouseIdMap.LastUpdatedOn + "', '" + objHouseIdMap.src.Trim().Replace("'", "''") + "','" + objHouseIdMap.fileID.Trim().Replace("'", "''") + "');";

    }

    public override string GetUpdateSql(Persistent obj)
    {
        HouseIdMap objHouseIdMap = (HouseIdMap)obj;
        // return "update [tblHouseIdMap] set [map_house_id_unk] = '" + objHouseIdMap.mapHouseIdUnk.Trim().Replace("'", "''") + "', [map_house_id] = '" + objHouseIdMap.mapHouseId.Trim().Replace("'", "''") + "', [title] = '" + objHouseIdMap.title.Trim().Replace("'", "''") + "', [last_updated_by] = '" + objHouseIdMap.LastUpdatedBy + "', [last_updated_on] = '" + objHouseIdMap.LastUpdatedOn + "', [src] = '" + objHouseIdMap.src.Trim().Replace("'", "''") + "' where map_code = '" + objHouseIdMap.IntCode + "';";

        return "update [tblHouseIdMap] set [map_house_id_unk] = '" + objHouseIdMap.mapHouseIdUnk.Trim().Replace("'", "''") + "', [map_house_id] = '" + objHouseIdMap.mapHouseId.Trim().Replace("'", "''") + "', [title] = '" + objHouseIdMap.title.Trim().Replace("'", "''") + "',[fileID] = '" + objHouseIdMap.fileID.Trim().Replace("'", "''") + "', [src] = '" + objHouseIdMap.src.Trim().Replace("'", "''") + "' where map_code = '" + objHouseIdMap.IntCode + "';";

    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        HouseIdMap objHouseIdMap = (HouseIdMap)obj;
        return " DELETE FROM [tblHouseIdMap] WHERE map_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        HouseIdMap objHouseIdMap = (HouseIdMap)obj;
        //return "Update [tblHouseIdMap] set Is_Active='" + objHouseIdMap.Is_Active + "',lock_time=null, last_updated_time= getdate() where map_code = '" + objHouseIdMap.IntCode + "'";

        return "Update [tblHouseIdMap] set last_updated_time= getdate() where map_code = '" + objHouseIdMap.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [tblHouseIdMap] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [tblHouseIdMap] WHERE  map_code = " + obj.IntCode;
    }





}
