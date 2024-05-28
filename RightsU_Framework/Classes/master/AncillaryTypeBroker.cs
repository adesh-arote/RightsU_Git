using System;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

public class AncillaryTypeBroker : DatabaseBroker
{

    public AncillaryTypeBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Ancillary_Type] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        AncillaryType objAncillaryRight;
        if (obj == null)
        {
            objAncillaryRight = new AncillaryType();
        }
        else
        {
            objAncillaryRight = (AncillaryType)obj;
        }

        objAncillaryRight.IntCode = Convert.ToInt32(dRow["Ancillary_Type_Code"]);        
        objAncillaryRight.AncillaryTypeName = Convert.ToString(dRow["Ancillary_Type_Name"]);       
        return objAncillaryRight;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        throw new NotImplementedException();
    }

    public override string GetInsertSql(Persistent obj)
    {
        throw new NotImplementedException();
    }

    public override string GetUpdateSql(Persistent obj)
    {
        throw new NotImplementedException();
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        throw new NotImplementedException();
    }

    public override string GetDeleteSql(Persistent obj)
    {
        throw new NotImplementedException();
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new NotImplementedException();
    }

    public override string GetCountSql(string strSearchString)
    {
        throw new NotImplementedException();
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Ancillary_Type] WHERE  Ancillary_Type_code = " + obj.IntCode;
    }
}
