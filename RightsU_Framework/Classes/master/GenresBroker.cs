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
/// Summary description for Genres
/// </summary>
public class GenresBroker : DatabaseBroker {
    public GenresBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Genres] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        Genres objGenres;
        if (obj == null)
        {
            objGenres = new Genres();
        }
        else
        {
            objGenres = (Genres)obj;
        }

        objGenres.IntCode = Convert.ToInt32(dRow["Genres_Code"]);
        #region --populate--
        objGenres.GenresName = Convert.ToString(dRow["Genres_Name"]);
        if (dRow["Inserted_On"] != DBNull.Value)
            objGenres.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
        if (dRow["Inserted_By"] != DBNull.Value)
            objGenres.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
        if (dRow["Lock_Time"] != DBNull.Value)
            objGenres.LockTime = Convert.ToString(dRow["Lock_Time"]);
        if (dRow["Last_Updated_Time"] != DBNull.Value)
            objGenres.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
        if (dRow["Last_Action_By"] != DBNull.Value)
            objGenres.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
        objGenres.Is_Active = Convert.ToString(dRow["Is_Active"]);
        #endregion
        return objGenres;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		Genres objGenres = (Genres)obj;
		return DBUtil.IsDuplicate(myConnection, objGenres.tableName, "Genres_Name", objGenres.GenresName, objGenres.pkColName, objGenres.IntCode, "Record already exist", "");
    }

    public override string GetInsertSql(Persistent obj)
    {
        Genres objGenres = (Genres)obj;
        return "insert into [Genres]([Genres_Name], [Inserted_On], [Inserted_By], [Is_Active]) values(N'" + objGenres.GenresName.Trim().Replace("'", "''") + "', getDate() , '" + objGenres.InsertedBy + "', 'Y');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        Genres objGenres = (Genres)obj;
        return "update [Genres] set [Genres_Name] = N'" + objGenres.GenresName.Trim().Replace("'", "''") + "',  [Lock_Time] = null, [Last_Updated_Time] = getDate() , [Last_Action_By] = '" + objGenres.LastActionBy + "' where Genres_Code = '" + objGenres.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        Genres objGenres = (Genres)obj;
        return "DELETE FROM [Genres] WHERE Genres_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
		Genres objGenres = (Genres)obj;
		return "Update [Genres] set Is_Active='"+objGenres.Is_Active +"',lock_time=null, last_updated_time= getdate() where Genres_Code = '" + objGenres.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Genres] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Genres] WHERE  Genres_Code = " + obj.IntCode;
    }
}
