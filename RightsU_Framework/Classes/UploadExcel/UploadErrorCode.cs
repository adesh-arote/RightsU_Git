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
/// Summary description for UploadErrorCode
/// </summary>
public class UploadErrorCode:Persistent 
{
    public UploadErrorCode()
    {
        OrderByColumnName = "error_description";//"upload_error_code";
        OrderByCondition = "ASC";
       // orderByReverseCondition = "DESC";
    }
    private string _uploadErrorCode;
    private string _errorDescription;
    private string _errorFor;
    public string uploadErrorCode
    {
        get
        {
            return _uploadErrorCode;
        }
        set
        {
            _uploadErrorCode = value;
        }
    }
    public string errorDescription
    {
        get
        {
            return _errorDescription;
        }
        set
        {
            _errorDescription = value;
        }
    }
    public string errorFor
    {
        get
        {
            return _errorFor;
        }
        set
        {
            _errorFor = value;
        }
    }
    public override void LoadObjects()
    {
    }
    public override DatabaseBroker GetBroker()
    {
        return new UploadErrorCodeBroker();
    }
    public override void UnloadObjects()
    {
    }
}
