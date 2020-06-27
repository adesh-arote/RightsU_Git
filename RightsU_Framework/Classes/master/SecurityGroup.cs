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
using System.Collections;

/// <summary>
/// Summary description for Title
/// </summary>
public class SecurityGroup : Persistent {
    public SecurityGroup()
    {
        OrderByColumnName = "security_group_code";
        OrderByCondition = "ASC";
        tableName = "Security_Group";
        pkColName = "Security_Group_code";
    }

    #region ------------- Properties--------------

    private string _securitygroupname;
    public string securitygroupname
    {
        get { return _securitygroupname; }
        set { _securitygroupname = value; }
    }
    private ArrayList _arrSecGroupRel;
    public ArrayList arrSecGroupRel
    {
        get
        {
            if (this._arrSecGroupRel == null)
                this._arrSecGroupRel = new ArrayList();
            return this._arrSecGroupRel;
        }
        set { this._arrSecGroupRel = value; }
    }

    private ArrayList _arrSecGroupRel_ForDel;
    public ArrayList arrSecGroupRel_ForDel
    {
        get
        {
            if (this._arrSecGroupRel_ForDel == null)
                this._arrSecGroupRel_ForDel = new ArrayList();
            return this._arrSecGroupRel_ForDel;
        }
        set { this._arrSecGroupRel_ForDel = value; }
    }

    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new SecurityGroupBroker();
    }

    public override void UnloadObjects()
    {
        if (this.arrSecGroupRel_ForDel != null)
        {
            foreach (SecurityGroupRel objSecGroupRel in arrSecGroupRel_ForDel)
            {
                objSecGroupRel.IsTransactionRequired = true;
                objSecGroupRel.SqlTrans = this.SqlTrans;
                objSecGroupRel.IsEndOfTrans = false;
                objSecGroupRel.IsDeleted = true;
                objSecGroupRel.Save();
            }
        }

        if (this.arrSecGroupRel != null)
        {
            foreach (SecurityGroupRel objSecGroupRel in arrSecGroupRel)
            {
                objSecGroupRel.securitygroupcode = this.IntCode;
                objSecGroupRel.IsTransactionRequired = true;
                objSecGroupRel.SqlTrans = this.SqlTrans;
                //  objSecGroupRel.IsEndOfTrans = false;
                objSecGroupRel.Save();
            }
        }
    }

    public override void LoadObjects()
    {
        this.arrSecGroupRel_ForDel = FillArrayList(new SecurityGroupRel(), " and security_group_code = '" + this.IntCode + "'", false);
    }

    public static ArrayList FillArrayList(Persistent Obj, string strSearch, bool isSubClassReq)
    {
        ArrayList arrFilledObject;
        Criteria ObjCri = new Criteria(Obj);
        ObjCri.IsPagingRequired = false;
        ObjCri.IsSubClassRequired = isSubClassReq;
        arrFilledObject = ObjCri.Execute(strSearch);
        return arrFilledObject;
    }

    #endregion

    public string getSecurityGroupRelCodes(int sec_code)
    {
        return ((SecurityGroupBroker)this.GetBroker()).getSecurityGroupRelCodes(sec_code);
    }

    public ArrayList getArrUserRightCodes(int groupCode, int moduleCode, string strSearch)
    {
        return ((SecurityGroupBroker)this.GetBroker()).getArrUserRightCodes(groupCode, moduleCode, strSearch);
    }
    public string getArrUserRightCodesString(int groupCode, int moduleCode, string strSearch)
    {
        return ((SecurityGroupBroker)this.GetBroker()).getArrUserRightCodesString(groupCode, moduleCode, strSearch);
    }
}
