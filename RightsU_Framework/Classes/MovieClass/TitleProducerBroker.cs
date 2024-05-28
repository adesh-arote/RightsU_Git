using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using UTOFrameWork.FrameworkClasses;

public class TitleProducerBroker : DatabaseBroker
{
    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method or operation is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return "SELECT COUNT(*) FROM Title_Producer WHERE title_producer_code > -1 " + strSearchString;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        return "DELETE FROM Title_Producer WHERE title_producer_code =" + obj.IntCode;
    }

    public override string GetInsertSql(Persistent obj)
    {
        TitleProducer objTitleProducer = (TitleProducer)obj;
        string sql = "INSERT INTO Title_Producer (title_code,producer_vendor_code) VALUES(" + objTitleProducer.titleCode
                   + "," + objTitleProducer.objTalent.IntCode + ")";
        return sql;
    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sql = "SELECT * FROM Title_Producer WHERE title_producer_code > -1 " + strSearchString;
        if (objCriteria.IsPagingRequired)
        {
            sql = objCriteria.getPagingSQL(sql);
            return sql;
        }
        return sql + " ORDER BY " + objCriteria.getASCstr();
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return "SELECT * FROM Title_Producer WHERE title_producer_code=" + obj.IntCode;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        TitleProducer objTitleProducer = (TitleProducer)obj;
        string sql = "UPDATE Title_Producer SET title_code=" + objTitleProducer.titleCode
            + ",producer_vendor_code=" + objTitleProducer.objTalent.IntCode + " WHERE title_producer_code=" + obj.IntCode;
        return sql;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        TitleProducer objTitleProducer;
        if (obj == null)
        {
            objTitleProducer = new TitleProducer();
        }
        else
        {
            objTitleProducer = (TitleProducer)obj;
        }
        objTitleProducer.IntCode = Convert.ToInt32(dRow["title_producer_code"]);
        objTitleProducer.titleCode = Convert.ToInt32(dRow["title_code"]);
        objTitleProducer.objTalent.IntCode = Convert.ToInt32(dRow["producer_vendor_code"]);
        objTitleProducer.status = GlobalParams.LINE_ITEM_EXISTING;
        return objTitleProducer;
    }
}

