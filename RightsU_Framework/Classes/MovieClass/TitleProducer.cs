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


public class TitleProducer:Persistent
{
    #region-----------Constructor-------------
    public TitleProducer()
	{
        OrderByColumnName = "title_producer_code";
        OrderByCondition = "ASC";
    }
    #endregion

    #region-----------Attributes--------------
    private int _titleCode;
    private Talent _objTalent;
    private string _status;
    #endregion

    #region-----------Properties--------------
    public int titleCode
    {
        get { return _titleCode; }
        set { _titleCode = value; }
    }
    public Talent objTalent
    {
        get
        {
            if (_objTalent == null)
            {
                _objTalent = new Talent();
            }
            return _objTalent;
        }
        set { _objTalent = value; }
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
        return new TitleProducerBroker();
    }
    public override void LoadObjects()
    {
        if (_objTalent.IntCode > 0)
        {
            _objTalent.FetchDeep();
        }
    }
    public override void UnloadObjects()
    {
        throw new Exception("The method or operation is not implemented.");
    }
    #endregion
}

