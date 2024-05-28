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
/// Summary description for Title
/// </summary>
public class PafBudgetDummy
{
    public PafBudgetDummy()
    {
    }

    private string _paf_code;
    public string paf_code
    {
        get { return this._paf_code; }
        set { this._paf_code = value; }
    }

    private string _paf_no;
    public string paf_no
    {
        get { return this._paf_no; }
        set { this._paf_no = value; }
    }

    private string _paf_cost_type_code;
    public string paf_cost_type_code
    {
        get { return this._paf_cost_type_code; }
        set { this._paf_cost_type_code = value; }
    }

    private string _creation_date;
    public string creation_date
    {
        get { return this._creation_date; }
        set { this._creation_date = value; }
    }

    private string _TitleCostType;
    public string TitleCostType
    {
        get { return this._TitleCostType; }
        set { this._TitleCostType = value; }
    }

    private decimal _amount;
    public decimal amount
    {
        get { return this._amount; }
        set { this._amount = value; }
    }

    private decimal _utilized;
    public decimal utilized
    {
        get { return this._utilized; }
        set { this._utilized = value; }
    }

    private decimal _balance;
    public decimal balance
    {
        get { return this._balance; }
        set { this._balance = value; }
    }

    public ArrayList arrPafDetaDummy(string pafCode)
    {
        string sql = "Exec [USP_PafBudgetDummy] " + pafCode + " ";

        DataSet ds = DatabaseBroker.ProcessSelectDirectly(sql);
        ArrayList objectArray = new ArrayList();
        foreach (DataRow aDataRow in ds.Tables[0].Rows)
        {
            PafBudgetDummy tmpObj = PopulateObjectLocal(aDataRow);
            objectArray.Add(tmpObj);
        }
        return objectArray;
    }

    private PafBudgetDummy PopulateObjectLocal(DataRow drow)
    {
        PafBudgetDummy objPafBudgetDummy = new PafBudgetDummy();
        objPafBudgetDummy.paf_code = Convert.ToString(drow["paf_code"]);
        objPafBudgetDummy.paf_no = Convert.ToString(drow["paf_no"]);
        if (drow["creation_date"] != DBNull.Value)
            objPafBudgetDummy.creation_date = Convert.ToDateTime(drow["creation_date"]).ToString("dd/MM/yyyy");

        if (drow["paf_cost_type_code"] != DBNull.Value)
            objPafBudgetDummy.paf_cost_type_code = Convert.ToString(drow["paf_cost_type_code"]);

        objPafBudgetDummy.TitleCostType = Convert.ToString(drow["TitleCostType"]);


        if (drow["amount"] != DBNull.Value)
            objPafBudgetDummy.amount = Convert.ToDecimal(drow["amount"]);

        if (drow["utilized"] != DBNull.Value)
            objPafBudgetDummy.utilized = Convert.ToDecimal(drow["utilized"]);

        if (drow["balance"] != DBNull.Value)
            objPafBudgetDummy.balance = Convert.ToDecimal(drow["balance"]);

        return objPafBudgetDummy;
    }
}
