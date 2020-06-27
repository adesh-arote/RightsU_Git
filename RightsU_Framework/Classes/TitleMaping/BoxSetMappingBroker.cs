using System;
using System.Data;
using System.Configuration;
//using System.Web;
//using System.Web.Security;
//using System.Web.UI;
//using System.Web.UI.WebControls;
//using System.Web.UI.WebControls.WebParts;
//using System.Web.UI.HtmlControls;
using UTOFrameWork.FrameworkClasses;
using System.Collections;
using System.Data.SqlClient;

/// <summary>
/// Summary description for BoxSetMapping
/// </summary>
public class BoxSetMappingBroker : DatabaseBroker
{
    public BoxSetMappingBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Box_Set_Mapping] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        BoxSetMapping objBoxSetMapping;
        if (obj == null)
        {
            objBoxSetMapping = new BoxSetMapping();
        }
        else
        {
            objBoxSetMapping = (BoxSetMapping)obj;
        }

        objBoxSetMapping.IntCode = Convert.ToInt32(dRow["box_mapping_code"]);
        #region --populate--
        if (dRow["boxset_external_title_code"] != DBNull.Value)
            objBoxSetMapping.BoxsetExternalTitleCode = Convert.ToInt32(dRow["boxset_external_title_code"]);
        if (dRow["inserted_on"] != DBNull.Value)
            objBoxSetMapping.InsertedOn = Convert.ToString(dRow["inserted_on"]);
        if (dRow["inserted_by"] != DBNull.Value)
            objBoxSetMapping.InsertedBy = Convert.ToInt32(dRow["inserted_by"]);
        if (dRow["lock_time"] != DBNull.Value)
            objBoxSetMapping.LockTime = Convert.ToString(dRow["lock_time"]);
        if (dRow["last_updated_time"] != DBNull.Value)
            objBoxSetMapping.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);
        if (dRow["last_action_by"] != DBNull.Value)
            objBoxSetMapping.LastActionBy = Convert.ToInt32(dRow["last_action_by"]);
        if (dRow["Mapping_Type"] != DBNull.Value)
            objBoxSetMapping.MappingType = Convert.ToString(dRow["Mapping_Type"]);

        #endregion
        return objBoxSetMapping;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        BoxSetMapping objBoxSetMapping = (BoxSetMapping)obj;

        string strSql = "insert into [Box_Set_Mapping]([boxset_external_title_code], [inserted_on], [inserted_by], [lock_time], [last_updated_time], [last_action_by],[Mapping_Type]) "
        + " values('" + objBoxSetMapping.BoxsetExternalTitleCode + "', GetDate(), '" + objBoxSetMapping.InsertedBy + "',  "
        + " Null, GetDate(), '" + objBoxSetMapping.InsertedBy + "','" + objBoxSetMapping.MappingType + "');";
        return strSql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        BoxSetMapping objBoxSetMapping = (BoxSetMapping)obj;
        string strSql = "update [Box_Set_Mapping] set [boxset_external_title_code] = '" + objBoxSetMapping.BoxsetExternalTitleCode + "', "
        + " [lock_time] = Null, [last_updated_time] = GetDate(), [last_action_by] = '" + objBoxSetMapping.LastActionBy + "', "
        + " [Mapping_Type] = '" + objBoxSetMapping.MappingType + "' "
        + " where box_mapping_code = '" + objBoxSetMapping.IntCode + "';";
        return strSql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        BoxSetMapping objBoxSetMapping = (BoxSetMapping)obj;
        if (objBoxSetMapping.arrBoxSetMappingTitles.Count > 0)
            DBUtil.DeleteChild("BoxSetMappingTitles", objBoxSetMapping.arrBoxSetMappingTitles, objBoxSetMapping.IntCode, (SqlTransaction)objBoxSetMapping.SqlTrans);

        return " DELETE FROM [Box_Set_Mapping] WHERE box_mapping_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        BoxSetMapping objBoxSetMapping = (BoxSetMapping)obj;
        return "Update [Box_Set_Mapping] set Is_Active='" + objBoxSetMapping.Is_Active + "',lock_time=null, last_updated_time= getdate() where box_mapping_code = '" + objBoxSetMapping.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Box_Set_Mapping] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Box_Set_Mapping] WHERE  box_mapping_code = " + obj.IntCode;
    }
}
