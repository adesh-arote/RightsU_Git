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

/// <summary>
/// Summary description for BoxSetMappingTitles
/// </summary>
public class BoxSetMappingTitlesBroker : DatabaseBroker
{
    public BoxSetMappingTitlesBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Box_Set_Mapping_Titles] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        BoxSetMappingTitles objBoxSetMappingTitles;
        if (obj == null)
        {
            objBoxSetMappingTitles = new BoxSetMappingTitles();
        }
        else
        {
            objBoxSetMappingTitles = (BoxSetMappingTitles)obj;
        }

        objBoxSetMappingTitles.IntCode = Convert.ToInt32(dRow["box_mapping_titles_code"]);
        #region --populate--
        if (dRow["box_mapping_code"] != DBNull.Value)
            objBoxSetMappingTitles.BoxMappingCode = Convert.ToInt32(dRow["box_mapping_code"]);
        if (dRow["external_title_code"] != DBNull.Value)
            objBoxSetMappingTitles.ExternalTitleCode = Convert.ToInt32(dRow["external_title_code"]);
        if (dRow["percentage"] != DBNull.Value)
            objBoxSetMappingTitles.percentage = Convert.ToDecimal(dRow["percentage"]);
        #endregion
        return objBoxSetMappingTitles;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        BoxSetMappingTitles objBoxSetMappingTitles = (BoxSetMappingTitles)obj;
        string strSql = "insert into [Box_Set_Mapping_Titles]([box_mapping_code], [external_title_code], [percentage]) "
        + " values('" + objBoxSetMappingTitles.BoxMappingCode + "', '" + objBoxSetMappingTitles.ExternalTitleCode + "', "
        + " '" + objBoxSetMappingTitles.percentage + "');";
        return strSql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        BoxSetMappingTitles objBoxSetMappingTitles = (BoxSetMappingTitles)obj;
        string strSql = "update [Box_Set_Mapping_Titles] set [box_mapping_code] = '" + objBoxSetMappingTitles.BoxMappingCode + "', "
        + " [external_title_code] = '" + objBoxSetMappingTitles.ExternalTitleCode + "', "
        + " [percentage] = '" + objBoxSetMappingTitles.percentage + "' "
        + " where box_mapping_titles_code = '" + objBoxSetMappingTitles.IntCode + "';";
        return strSql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        BoxSetMappingTitles objBoxSetMappingTitles = (BoxSetMappingTitles)obj;

        return " DELETE FROM [Box_Set_Mapping_Titles] WHERE box_mapping_titles_code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        BoxSetMappingTitles objBoxSetMappingTitles = (BoxSetMappingTitles)obj;
        return "Update [Box_Set_Mapping_Titles] set Is_Active='" + objBoxSetMappingTitles.Is_Active + "',lock_time=null, last_updated_time= getdate() where box_mapping_titles_code = '" + objBoxSetMappingTitles.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Box_Set_Mapping_Titles] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Box_Set_Mapping_Titles] WHERE  box_mapping_titles_code = " + obj.IntCode;
    }
}
