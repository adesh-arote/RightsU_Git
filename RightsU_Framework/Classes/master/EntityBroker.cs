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
/// Summary description for Entity
/// </summary>
public class EntityBroker : DatabaseBroker
{
    public EntityBroker() { }


    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Entity] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        Entity objEntity;
        if (obj == null)
        {
            objEntity = new Entity();
        }
        else
        {
            objEntity = (Entity)obj;
        }

        objEntity.IntCode = Convert.ToInt32(dRow["Entity_Code"]);
        #region --populate--
        objEntity.EntityName = Convert.ToString(dRow["Entity_Name"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objEntity.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objEntity.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objEntity.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objEntity.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objEntity.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        objEntity.IsActive = Convert.ToChar(dRow["Is_Active"]);

        if (dRow["logo_name"] != DBNull.Value)
            objEntity.LogoName = Convert.ToString(dRow["logo_name"]);
        else
            objEntity.LogoName = "";

        if (dRow["logo_path"] != DBNull.Value)
            objEntity.LogoPath = Convert.ToString(dRow["logo_path"]);
        else
            objEntity.LogoPath = "";
        
        objEntity.IsDefaultEntity = GetDefaultEntityStatus(objEntity.IntCode);

        if (dRow["ParentEntityCode"] != DBNull.Value)
            objEntity.ParentEntityCode = Convert.ToInt32(dRow["ParentEntityCode"]);
        else
            objEntity.ParentEntityCode = 0;

        #endregion
        return objEntity;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        Entity objEntity = (Entity)obj;
        return DBUtil.IsDuplicate(myConnection, "Entity", "Entity_Name", objEntity.EntityName, "Entity_Code", objEntity.IntCode, "Record already exists", "");

    }

    public override string GetInsertSql(Persistent obj)
    {
        Entity objEntity = (Entity)obj;
        return "insert into [Entity]([Entity_Name], [Inserted_On], [Inserted_By], [Is_Active],[logo_name],[ParentEntityCode]) values('" + objEntity.EntityName.Trim().Replace("'", "''") + "', getdate(), '" + objEntity.InsertedBy + "',  'Y','" + objEntity.LogoName + "','" + objEntity.ParentEntityCode + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        Entity objEntity = (Entity)obj;
        return "update [Entity] set [Entity_Name] = '" + objEntity.EntityName.Trim().Replace("'", "''") + "',[Lock_Time] = null, [Last_Updated_Time] = getDate() , [Last_Action_By] =   '" + objEntity.LastActionBy + "', [Is_Active] = '" + objEntity.IsActive + "',[logo_name]='" + objEntity.LogoName + "',[ParentEntityCode] =" + objEntity.ParentEntityCode + " where Entity_Code = '" + objEntity.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        Entity objEntity = (Entity)obj;

        return " DELETE FROM [Entity] WHERE Entity_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        Entity objEntity = (Entity)obj;
        string strSql = "UPDATE [Entity] SET Is_Active='" + objEntity.IsActive + "',[Lock_Time]=null,[Last_Updated_Time] = getDate() WHERE Entity_Code=" + objEntity.IntCode;
        return (strSql);

        //throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Entity] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Entity] WHERE  Entity_Code = " + obj.IntCode;
    }

    public Int32 GetDefaultEntityStatus(Int32 entityCode)
    {
        Int32 strCount;
        string strSelect;
        strSelect = " select COUNT(*) from Entity e inner join Users_Entity ue  on e.entity_code= ue.entity_code " +
                    " where ue.is_default='Y' and e.entity_code=" + entityCode + " ";
        strCount = DatabaseBroker.ProcessScalarDirectly(strSelect);
        return strCount;
    }
}
