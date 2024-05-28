using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

/// <summary>
/// Summary description for Talent
/// </summary>
public class Talent : Persistent
{
	

    #region-----------Constructor-------------
    public Talent()
	{
		tableName = "Talent";
        OrderByColumnName = "talent_name";
        OrderByCondition = "ASC";
		pkColName = "Talent_Code";
	}    
    #endregion

    #region-----------Attributes--------------
    private string _talentName;
    private ArrayList _arrTalentRoles;
	private char _Gender;
    #endregion	
	
    #region-----------Properties--------------
    public string talentName
    {
        get { return _talentName; }
        set { _talentName = value; }
    }
    public ArrayList arrTalentRoles
    {
        get { return _arrTalentRoles; }
        set { _arrTalentRoles = value; }
    }

	public char Gender 
	{
		get { return _Gender; }
		set { _Gender = value; }
	}

	//private char _IsActive;
	//public char IsActive 
	//{
	//    get { return this._IsActive; }
	//    set { this._IsActive = value; }
	//}

    #endregion

    #region-----------Methods-----------------
    public override DatabaseBroker GetBroker()
    {
        return new TalentBroker();
    }

    public override void LoadObjects()
    {
        TalentRoles objTalentRoles = new TalentRoles();
        this._arrTalentRoles = DBUtil.FillArrayList(objTalentRoles, " and talent_code='" + this.IntCode + "'", true); 
    }

    public override void UnloadObjects()
    {
        if (this.arrTalentRoles != null)
        {
            foreach (TalentRoles objTalentRoles in this.arrTalentRoles)
            {
                objTalentRoles.IsDirty = true;

                if (objTalentRoles.IntCode == 0)
                {
                    objTalentRoles.IsDirty = false;
                }

                if (objTalentRoles.status == "MOD")
                {
                    objTalentRoles.IsDirty = true;
                }

                if (objTalentRoles.status == "DEL")
                {
                    objTalentRoles.IsDirty = false;
                    objTalentRoles.IsDeleted = true;
                }
                objTalentRoles.talentCode = this.IntCode;
                objTalentRoles.IsTransactionRequired = true;
                objTalentRoles.SqlTrans = this.SqlTrans;
                objTalentRoles.Save();
            }
        }
    }

    public override string getRecordStatus(out int UserCode)
    {
        return this.GetBroker().getRecordStatus(this, out UserCode);
    }
    public override void refreshRecord()
    {
        this.GetBroker().refreshRecord(this);
    }

    public override void unlockRecord()
    {
        this.GetBroker().unlockRecord(this);
    }

    public void GetStatus(ref bool _Director, ref bool _StarCast, Int32 _IntCode)
    {
        ((TalentBroker)this.GetBroker()).GetStatus(ref _Director, ref _StarCast, _IntCode);
    }

    #endregion
}
