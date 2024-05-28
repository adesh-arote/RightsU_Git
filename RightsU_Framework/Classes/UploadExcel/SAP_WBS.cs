using System;
using System.Collections;
using System.Data;
using UTOFrameWork.FrameworkClasses;
/// <summary>
/// Summary description for UploadFile.
/// </summary>
public class SAP_WBS : Persistent
{
    #region --- Members ---
    private string _WBS_Code;
    private string _WBS_Description;
    private string _Studio_Vendor;
    private string _Original_Dubbed;
    private string _Status;
    private string _Sport_Type;
    private int _File_Code;
    #endregion

    #region --- Properties ---
    public string WBS_Code
    {
        get { return _WBS_Code; }
        set { _WBS_Code = value; }
    }
    public string WBS_Description
    {
        get { return _WBS_Description; }
        set { _WBS_Description = value; }
    }
    public string Studio_Vendor
    {
        get { return _Studio_Vendor; }
        set { _Studio_Vendor = value; }
    }
    public string Original_Dubbed
    {
        get { return _Original_Dubbed; }
        set { _Original_Dubbed = value; }
    }
    public string Status
    {
        get { return _Status; }
        set { _Status = value; }
    }
    public string Sport_Type
    {
        get { return _Sport_Type; }
        set { _Sport_Type = value; }
    }
    public int File_Code
    {
        get { return _File_Code; }
        set { _File_Code = value; }
    }
    #endregion

    public SAP_WBS()
    {
        OrderByColumnName = "SAP_WBS_Code";
        OrderByCondition = "DESC";
    }

    public override DatabaseBroker GetBroker()
    {
        return new SAP_WBSBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {

    }
}

