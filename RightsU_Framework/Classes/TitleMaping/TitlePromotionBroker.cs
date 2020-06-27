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
/// Summary description for TitlePromotion
/// </summary>
public class TitlePromotionBroker : DatabaseBroker
{
	public TitlePromotionBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Title_Promotion] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        TitlePromotion objTitlePromotion;
		if (obj == null)
		{
			objTitlePromotion = new TitlePromotion();
		}
		else
		{
			objTitlePromotion = (TitlePromotion)obj;
		}

		objTitlePromotion.IntCode = Convert.ToInt32(dRow["title_promotion_code"]);
		#region --populate--
		if (dRow["external_title_code"] != DBNull.Value)
			objTitlePromotion.ExternalTitleCode = Convert.ToInt32(dRow["external_title_code"]);
		if (dRow["effective_start_date"] != DBNull.Value)
			objTitlePromotion.EffectiveStartDate = Convert.ToDateTime(dRow["effective_start_date"]);
		if (dRow["effective_end_date"] != DBNull.Value)
			objTitlePromotion.EffectiveEndDate = Convert.ToDateTime(dRow["effective_end_date"]);
		objTitlePromotion.IsPromotion = Convert.ToString(dRow["is_promotion"]);
		if (dRow["inserted_on"] != DBNull.Value)
			objTitlePromotion.InsertedOn = Convert.ToString(dRow["inserted_on"]);
		if (dRow["inserted_by"] != DBNull.Value)
			objTitlePromotion.InsertedBy = Convert.ToInt32(dRow["inserted_by"]);
		if (dRow["lock_time"] != DBNull.Value)
            objTitlePromotion.LockTime = Convert.ToString(dRow["lock_time"]);
		if (dRow["last_updated_time"] != DBNull.Value)
            objTitlePromotion.LastUpdatedTime = Convert.ToString(dRow["last_updated_time"]);
		if (dRow["last_action_by"] != DBNull.Value)
			objTitlePromotion.LastActionBy = Convert.ToInt32(dRow["last_action_by"]);
		#endregion
		return objTitlePromotion;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        //TitlePromotion objTitlePromotion = (TitlePromotion)obj;
        //string str = " Deletionmark = 'N' and ProductCode = '" + objBrands.ProductCode + "' and Advertiser_SID = '" + objBrands.AdvertiserID + "' and BrandCode <> '" + objBrands.IntCode + "'";
       // return GlobalUtil.IsDuplicate(myConnection, "Brand", "BrandName", objBrands.BrandName, "BrandCode", objBrands.IntCode, "Brand Name Exist", str);
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		TitlePromotion objTitlePromotion = (TitlePromotion)obj;
		return "insert into [Title_Promotion]([external_title_code], [effective_start_date], [is_promotion], [inserted_on], [inserted_by], [lock_time], [last_updated_time], [last_action_by]) values('" + objTitlePromotion.ExternalTitleCode + "', '" + objTitlePromotion.EffectiveStartDate + "', '" + objTitlePromotion.IsPromotion.Trim().Replace("'", "''") + "', GetDate(), '" + objTitlePromotion.InsertedBy + "',  Null, GetDate(), '" + objTitlePromotion.InsertedBy + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
		TitlePromotion objTitlePromotion = (TitlePromotion)obj;
		//return "update [Title_Promotion] set [external_title_code] = '" + objTitlePromotion.ExternalTitleCode + "', [effective_start_date] = '" + objTitlePromotion.EffectiveStartDate + "', [effective_end_date] = '" + objTitlePromotion.EffectiveEndDate + "', [is_promotion] = '" + objTitlePromotion.IsPromotion.Trim().Replace("'", "''") + "', [lock_time] = Null, [last_updated_time] = GetDate(), [last_action_by] = '" + objTitlePromotion.LastActionBy + "' where title_promotion_code = '" + objTitlePromotion.IntCode + "';";
        return "update [Title_Promotion] set [effective_end_date] = '" + objTitlePromotion.EffectiveEndDate + "', [last_updated_time] = GetDate(), [last_action_by] = '" + objTitlePromotion.LastActionBy + "' where title_promotion_code = '" + objTitlePromotion.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		TitlePromotion objTitlePromotion = (TitlePromotion)obj;

		return " DELETE FROM [Title_Promotion] WHERE title_promotion_code = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        TitlePromotion objTitlePromotion = (TitlePromotion)obj;
        return "Update [Title_Promotion] set Is_Active='" + objTitlePromotion.Is_Active + "',lock_time=null, last_updated_time= getdate() where title_promotion_code = '" + objTitlePromotion.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [Title_Promotion] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [Title_Promotion] WHERE  title_promotion_code = " + obj.IntCode;
    }
    
    public string getEffectiveStartDt(int TitlePromCode)
    {
        return "select effective_start_date from Title_Promotion where title_promotion_code='"+ TitlePromCode +"'";
    }

    public DataSet getDealTitle(string searchStr)
    {
        //string sql = "select english_title from Title where english_title like  '" + searchStr + "%' and is_active='Y'";
        string sql="select distinct t.english_title from Deal_Movie dm inner join Title t on t.title_code=dm.title_code"
                   + " inner join External_Title et on et.deal_movie_code=dm.deal_movie_code and t.english_title like  '" + searchStr + "%'";
        DataSet ds = ProcessSelectDirectly(sql);
        return ds;
    }
    //public string getMaxTitlePromotionCode(int ExtTitleCode)
    //{
    //    return ProcessScalarReturnString("select isnull(MAX(title_promotion_code),0) from Title_Promotion where external_title_code='" + ExtTitleCode + "' and effective_end_date is null");
    //}
}   
