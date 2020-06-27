using System;
using System.Collections;
using System.Data;
using UTOFrameWork.FrameworkClasses;
/// <summary>
/// Summary description for UploadFile.
/// </summary>
public class UploadFile : Persistent
{
    #region "-Members-"
    private string _fileName;
    private string _errYN;
    private string _uploadType;
    private string _pendingReviewYN;
    private Int32 _uploadRecordCount;
    private int _recordsInserted;
    private int _recordsUpdated;
    private int _bankCode;
    private int _channelCode;
    private ArrayList _arrUpErrorDtl;
    private ArrayList _arrSAP_WBS;
    #endregion

    #region "-Constructors-"
    public UploadFile()
    {
        OrderByColumnName = "file_code";
        OrderByCondition = "DESC";
        //OrderByReverseCondition = "DESC";
    }
    #endregion

    #region "-Properties-"
    public string fileName
    {
        get
        {
            return _fileName;
        }
        set
        {
            _fileName = value;
        }
    }

    public string errorYN
    {
        get
        {
            return _errYN;
        }
        set
        {
            _errYN = value;
        }
    }
    public string uploadType
    {
        get
        {
            return _uploadType;
        }
        set
        {
            _uploadType = value;
        }
    }

    public string pendingReviewYN
    {
        get
        {
            return _pendingReviewYN;
        }
        set
        {
            _pendingReviewYN = value;
        }
    }

    public Int32 uploadRecordCount
    {
        get
        {
            return _uploadRecordCount;
        }
        set
        {
            _uploadRecordCount = value;
        }
    }

    public int bankCode
    {
        get
        {
            return _bankCode;
        }
        set
        {
            _bankCode = value;
        }
    }
    public int channelCode
    {
        get
        {
            return _channelCode;
        }
        set
        {
            _channelCode = value;
        }
    }
    public int recordsInserted
    {
        get
        {
            return _recordsInserted;
        }
        set
        {
            _recordsInserted = value;
        }
    }
    public int recordsUpdated
    {
        get
        {
            return _recordsUpdated;
        }
        set
        {
            _recordsUpdated = value;
        }
    }

    public ArrayList arrUpErrorDtl
    {
        get
        {
            if (_arrUpErrorDtl == null)
            {
                _arrUpErrorDtl = new ArrayList();
            }
            return _arrUpErrorDtl;
        }
        set { _arrUpErrorDtl = value; }
    }

    public ArrayList arrSAP_WBS
    {
        get
        {
            if (_arrSAP_WBS == null)
            {
                _arrSAP_WBS = new ArrayList();
            }
            return _arrSAP_WBS;
        }
        set { _arrSAP_WBS = value; }
    }




    #endregion

    public override DatabaseBroker GetBroker()
    {
        return new UploadFileBroker();
    }

    public override void LoadObjects()
    {

    }

    public override void UnloadObjects()
    {
        foreach (UploadErrorDetail objUpErrorDtl in this.arrUpErrorDtl)
        {
            objUpErrorDtl.SqlTrans = this.SqlTrans;
            objUpErrorDtl.IsTransactionRequired = true;
            objUpErrorDtl.IsProxy = true;
            objUpErrorDtl.fileCode = this.IntCode;
            if (objUpErrorDtl.IntCode > 0)
            {
                objUpErrorDtl.IsDirty = true;
            }
            objUpErrorDtl.Save();
        }

        foreach (SAP_WBS objSAP_WBS in this.arrSAP_WBS)
        {
            objSAP_WBS.SqlTrans = this.SqlTrans;
            objSAP_WBS.IsTransactionRequired = true;
            objSAP_WBS.IsProxy = true;
            objSAP_WBS.File_Code = this.IntCode;
            int intCode =  ((SAP_WBSBroker)objSAP_WBS.GetBroker()).GetIntCodeOnWBS_Code(objSAP_WBS);
            objSAP_WBS.IntCode = intCode;
            if (objSAP_WBS.IntCode > 0)
                objSAP_WBS.IsDirty = true;

            objSAP_WBS.Save();
        }
    }

    public void LoadArrayList()
    {
        this.arrUpErrorDtl = DBUtil.FillArrayList(new UploadErrorDetail(), " AND file_code=" + this.IntCode, false);
    }

    public DataSet getPath(int channelCode, string Type, string parameterName)
    {
        DataSet ds = ((UploadFileBroker)GetBroker()).getPath(channelCode, Type, parameterName);
        return ds;
    }

}

