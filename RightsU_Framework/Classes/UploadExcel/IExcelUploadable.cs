using System;
using System.Data;
using System.Collections;
using System.Web.UI.WebControls;
using UTOFrameWork.FrameworkClasses;
	/// <summary>
	/// Summary description for IExcelUploadable.
	/// </summary>
	public interface IExcelUploadable
	{
		//Header column arraylist
		ArrayList getFileHeaderList();
        //ArrayList getFileHeaderList(int invCode);
		//What will be in uploadFiles table for fileType?
		//What error should follow? We can specify "SD" for sales data. 
		//Then error codes will get generated as per it.			
		string frmUploadFileType();
		//logon User Code
		int logonUser();
		//Writes row to database as Error occured
		bool writeToDBTableAfterSuccess(Table dtSuccess,System.Web.UI.Page senderWebForm,int uploadedBy,long uploadedFileId,DataSet ds,int bankCode);
	}
