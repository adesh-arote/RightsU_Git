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
/// Summary description for TitleLanguage
/// </summary>
public class TitleLanguage121:Persistent {
    #region-----------Constructor-------------
    public TitleLanguage121()
	{
        OrderByColumnName = "title_language_code";
        OrderByCondition = "ASC";
    }
    #endregion
    #region-----------Attributes--------------
        private int _titleCode;
        private Language _objLanguage;
        private string _status;
    #endregion
    #region-----------Properties--------------
        public int titleCode
        {
            get { return _titleCode; }
            set { _titleCode = value; }
        }
        public Language objLanguage
        {
            get {
                if (_objLanguage == null) {
                    _objLanguage = new Language();
                }
                return _objLanguage; }
            set { _objLanguage = value; }
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
            return new TitleLanguageBroker123();
        }

        public override void UnloadObjects()
        {
            throw new Exception("The method or operation is not implemented.");
        }
    public override void LoadObjects()
    {
        if (objLanguage.IntCode > 0) {
            objLanguage.Fetch();
        }
    }
    #endregion
}
