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
/// <summary>
/// Summary description for MovieTerritory
/// </summary>
public class TitleTerritory:Persistent {
    #region-----------Constructor-------------
    public TitleTerritory()
	{
        OrderByColumnName = "Country_Code";
        OrderByCondition = "ASC";
    }
    #endregion

    #region-----------Attributes--------------
    private Country _objTerritory;
    private int _titleCode;
    private string _status;
    #endregion

    #region-----------Properties--------------
    public Country objTerritory
    {
        get { 
            if(_objTerritory==null){
                _objTerritory = new Country(); 
            }
            return _objTerritory; }
        set { _objTerritory = value; }
    }
    public int titleCode
    {
        get { return _titleCode; }
        set { _titleCode = value; }
    }
    public string status
    {
        get { return _status; }
        set { _status = value; }
    }
	
    #endregion

    #region-----------Methods-----------------
    public override DatabaseBroker GetBroker()
    {
        return new TitleTerritoryBroker();
    }
    public override void LoadObjects()
    {
        if (_objTerritory.IntCode > 0) {
            _objTerritory.Fetch();
        }
    }
    public override void UnloadObjects()
    {
        throw new Exception("The method or operation is not implemented.");
    }
    #endregion
}
