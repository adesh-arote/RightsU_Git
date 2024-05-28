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
public class Entity : Persistent
{
    public Entity()
    {
        OrderByColumnName = "Entity_Name";
        OrderByCondition = "ASC";
        pkColName = "Entity_Code";
        tableName = "Entity";

    }

    #region ---------------Attributes And Prperties---------------


    private string _EntityName;
    public string EntityName
    {
        get { return this._EntityName; }
        set { this._EntityName = value; }
    }

    private char _IsActive;
    public char IsActive
    {
        get { return this._IsActive; }
        set { this._IsActive = value; }
    }

    private string _LogoPath;
    public string LogoPath
    {
        get { return this._LogoPath; }
        set { this._LogoPath = value; }
    }

    private string _LogoName;
    public string LogoName
    {
        get { return this._LogoName; }
        set { this._LogoName = value; }
    }

    /* Added By sharad for Default Entity Validation on 12 Jan 2011 */
  
    private int _IsDefaultEntity;
    public int IsDefaultEntity
    {
        get { return this._IsDefaultEntity; }
        set { this._IsDefaultEntity = value; }
    }


    private int _ParentEntityCode;
    public int ParentEntityCode
    {
        get { return this._ParentEntityCode; }
        set { this._ParentEntityCode = value; }
    }

    /* Added By sharad for Default Entity Validation on 12 Jan 2011 */
    #endregion

    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new EntityBroker();
    }

    public override void LoadObjects()
    {
    }


    public override void UnloadObjects()
    {
        throw new NotImplementedException();
    }

    #endregion
}
