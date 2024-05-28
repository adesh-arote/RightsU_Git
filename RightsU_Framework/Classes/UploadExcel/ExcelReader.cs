using System;
using System.Data;
using System.Data.OleDb;
using System.Collections;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using UTOFrameWork.FrameworkClasses;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls.WebParts;

/// <summary>
/// Summary description for ExcelReader::==> 
/// It is used for reading Excel sheet and validating it as per
/// each column is set in relative arrayList at GlobalParams.cs
/// </summary>
public class ExcelReader
{
    int intFileCode;
    bool number = false;
    string sheetName;
    string rowDelimiter = "~";
    string uploadFileType = "";
    ArrayList arrSameSheetDataForDuplicate;
    ArrayList arrSecondSameSheetDataForDuplicate = new ArrayList();
    int actualRecordsCount = 0;
    int codeForID = 0;
    string strErrCodes = "";
    bool blnIsErrorFound = false;
    DataSet ds;
    Table dtSuccess;
    Table dtErrorOccured = new Table();
    TableCell tblCell;
    TableRow tblRow;
    string strDate = "";
    bool isLastRow = false;
    DataSet DsNewBS = new DataSet();
    public ExcelReader()
    {
        //If default excel sheet name is "Sheet1" this constructor can be used
        dtSuccess = new Table();
        sheetName = "Sheet1";
    }
    public ExcelReader(string strFileSheetName)
    {
        //If somewhere excel sheet name is diffrent this constructor can be used for setting it.
        dtSuccess = new Table();
        sheetName = strFileSheetName;
    }

    /// <summary>
    /// Validates header column names
    /// </summary>
    /// <param name="colArList">array of cells from excel sheet</param>
    /// <param name="dRow"></param>
    /// <returns></returns>
    public bool validateHeader(ArrayList colArList, DataRow dRow)
    {
        for (int i = 0; i < colArList.Count; i++)
        {
            //if (colArList.Count != dRow.Table.Columns.Count)
            // { return false; }
            // else
            // {
            if (colArList.Count > dRow.Table.Columns.Count)
            {
                return false;
            }
            if (((AttribValueExcelUpload)colArList[i]).Val.ToString().Trim().Replace(" ", "").ToUpper() != dRow.ItemArray[i].ToString().Trim().Replace(" ", "").ToUpper())
            {
                return false;
            }

            // }
        }
        return true;
    }
    /// <summary>
    /// Validates each cell of row.
    /// </summary>
    /// <param name="strErrCodes"></param>
    /// <param name="colArList"></param>
    /// <param name="dRow"></param>
    public void validateThisRow(ArrayList colArList, DataRow dRow, int rowNum, bool isLastRow)
    {
        strErrCodes = "";
        int totalCnt = colArList.Count;
        int prevCode = 0;
        tblRow = new TableRow();

        ((AttribValueExcelUpload)colArList[0])._isValidationRequired = true;
        ((AttribValueExcelUpload)colArList[0])._maxLength = 50;
        AttribValueExcelUpload atrbVal = null;


        for (int i = 0; i < totalCnt; i++)
        {
            atrbVal = (AttribValueExcelUpload)colArList[i];
            tblCell = new TableCell();
            tblCell.Text = dRow.ItemArray[i].ToString().Trim();
            if (atrbVal._isValidationRequired)
            { //Do Null valiadtion for each one if Validation is required
                if (isNullValue(dRow, i, ref strErrCodes))
                {

                }
                else
                { //If length validation required
                    if (atrbVal._isSkipValidationCharPresent
                         && dRow.ItemArray[i].ToString().Trim().ToUpper() == atrbVal._strSkipValidationCharPresentValue.Trim().ToUpper())
                    {
                        tblCell.Text = atrbVal._strSkipValidationCharToBeReplacedWithValue.Trim();
                    }
                    else
                    {
                        if (atrbVal._maxLength > 0)
                        {
                            //If length validation required and numeric validation is not present.
                            if (dRow.ItemArray[i].ToString().Trim().Length > atrbVal._maxLength)
                            {
                                appendErrCode(ref strErrCodes, i.ToString().Trim() + "IL");  //Invalid Length
                            }
                        }
                        if (atrbVal._isNumericValidation)
                        {
                            bool validNum = true;
                            bool isNegativevaluesConsider = false;
                            double amt = 0;
                            if (isValidNegAmount(dRow.ItemArray[i].ToString().Trim().Replace(",", ""), out amt) && uploadFileType.Trim().ToUpper() == "SD")
                            {
                                tblCell.Text = "0";// Gross Amount
                                tblRow.Cells.Add(tblCell);

                                addTblCell(tblRow, "0");  //  Agency Commision Amount
                                addTblCell(tblRow, "0");  //Net Amount
                                addTblCell(tblRow, "0");  //Service Tax Amount
                                addTblCell(tblRow, "0");  //Total Amount
                                i = i + 4;
                                validNum = false;
                            }
                            //added by B.sachin bfor neag val
                            else if (isValidNegAmount(dRow.ItemArray[i].ToString().Trim().Replace(",", ""), out amt) && uploadFileType.Trim().ToUpper() == "BS")
                            {
                                validNum = false;
                                tblCell.Text = dRow.ItemArray[i].ToString().Trim();// cheque Amount
                                appendErrCode(ref strErrCodes, i.ToString().Trim() + "NEG");
                            }


                            //else if (isValidNegAmount(dRow.ItemArray[i].ToString().Trim().Replace(",", ""), out amt) && uploadFileType.Trim().ToUpper() == "RD")
                            //{
                            //    if(NumericUtils.IsNumber(amt.ToString()) == false)
                            //    validNum = false;
                            //}
                            else if (isValidNegAmount(dRow.ItemArray[i].ToString().Trim().Replace(",", ""), out amt) && uploadFileType.Trim().ToUpper() == "PD")
                            {
                                validNum = false;
                                tblCell.Text = dRow.ItemArray[i].ToString().Trim();// cheque Amount
                                appendErrCode(ref strErrCodes, i.ToString().Trim() + "NEG");
                            }
                            else if (atrbVal._isDecimalValidation) //If decimal number validation required
                            {
                                double negval;
                                if (isValidNegAmount(dRow.ItemArray[i].ToString().Trim().Replace(",", ""), out negval))
                                {
                                    if (NumericUtils.IsNumber(negval.ToString()) == false)
                                    {
                                        validNum = false;
                                        appendErrCode(ref strErrCodes, i.ToString().Trim() + "NAN"); //Not A Number
                                    }
                                }
                                else
                                {
                                    if (NumericUtils.IsNumber(dRow.ItemArray[i].ToString().Trim().Replace(",", "")) == false)
                                    {
                                        validNum = false;
                                        appendErrCode(ref strErrCodes, i.ToString().Trim() + "NAN"); //Not A Number
                                    }
                                }
                            }
                            else
                            { //If Whole Number validation required

                                if (NumericUtils.IsWholeNumber(dRow.ItemArray[i].ToString().Trim().Replace(",", "")) == false)
                                {
                                    validNum = false;
                                    appendErrCode(ref strErrCodes, i.ToString().Trim() + "NAWN"); //Not An Whole Number
                                }
                            }
                            if (validNum)
                            {
                                double negval;
                                if (isValidNegAmount(dRow.ItemArray[i].ToString().Trim().Replace(",", ""), out negval))
                                {
                                    if (Convert.ToDouble(negval.ToString()) > atrbVal._maxNumberValue)
                                    {
                                        appendErrCode(ref strErrCodes, i.ToString().Trim() + "ILN"); //Invalid length of Number
                                    }
                                }

                            }
                        } //if(atrbVal._isNumericValidation)
                        else
                        {		//If date validation required
                            if (atrbVal._isDateValidation)
                            {
                                if (this.isDateFormatCorrect(atrbVal._getDateFormatCode, dRow.ItemArray[i].ToString().Trim()) == false)
                                {
                                    appendErrCode(ref strErrCodes, i.ToString().Trim() + "NPDF"); //Not Proper Date Format
                                }
                                else
                                {	//dtSuccess.Rows[rowNum].ItemArray[i]=strDate.Trim();
                                    tblCell.Text = strDate.Trim();

                                    if (checkIfDateBeforeDealDate(Convert.ToInt32(dRow.ItemArray[1].ToString().Trim()), strDate.Trim()))
                                    {
                                        if (strErrCodes != "1IID")
                                        {
                                            appendErrCode(ref strErrCodes, i.ToString().Trim() + "BSD"); //Date Before Deal Date
                                        }
                                    }
                                }
                            }
                            else
                            {

                                bool invFlag = true;

                                if (!invFlag)
                                {
                                    //do when it is not invoice number as it is on acc
                                }
                                else
                                {
                                    if (atrbVal._isCheckFromDataBaseOnIDValidationRequired && uploadFileType.Trim().ToUpper() != "AS")
                                    {
                                        string searchStringForSql = "";

                                        if (atrbVal._searchStringForSql != null)
                                        {

                                            searchStringForSql = " " + atrbVal._searchStringForSql.Trim();

                                        }

                                        if (checkForDataBaseValidation(atrbVal._columnToBeSelected,
                                            atrbVal._forWhichDBTable, atrbVal._checkFromDataBaseOnIDValidationValue,
                                            dRow.ItemArray[i].ToString().Trim(), searchStringForSql
                                            , ref strErrCodes, i.ToString() + "IID"))
                                        {
                                            //If ID get validated and code got returned
                                            tblCell.Text = codeForID.ToString().Trim();
                                        }
                                    }

                                }

                            }
                        }
                    }
                } //end if nullvalue


            }  //end if

            tblRow.Cells.Add(tblCell);
        }  //end for

        if (strErrCodes.Trim() == "")
        {
            string strErrDup = "";
            if (checkDuplicateInSameSheet(dRow, out strErrDup, ds) == false)
            {
                strErrCodes = strErrDup;
            }
        }

        dtSuccess.Rows.Add(tblRow);
    }

    /// <summary>
    /// this function is intended for checking neg amount 
    /// for onaccount adjustment in receipt module
    /// </summary>
    /// <param name="onAccGrossAmount">this is input grosss amount 
    /// read from the xls and may -ve sign or enclosed in the bracket
    /// other wise its an +ve amount or not an number
    /// </param>
    /// <param name="validNegAmount">
    /// this double out param which will give valid -ve amount on suceeding
    /// -ve </param>
    /// <returns></returns>
    static public bool isValidNegAmount(string onAccGrossAmount, out double validNegAmount)
    {
        validNegAmount = 0;
        if (onAccGrossAmount.IndexOf("(") == 0 && onAccGrossAmount.IndexOf(")") == onAccGrossAmount.Length - 1)
        {
            //check for absolute amount
            try
            {
                validNegAmount = double.Parse(onAccGrossAmount.Substring(1, onAccGrossAmount.Length - 2)) * -1;
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
        else//when amount is not enclosd within (round brackets)
        {
            try
            {
                validNegAmount = double.Parse(onAccGrossAmount);
                if (validNegAmount < 0)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception)
            {
                return false;
            }
        }
    }
    /// <summary>
    /// Checks duplicate record in same excel sheet. Logic is keep your duplicate check in arrayList. 
    /// Here you need to specify what are your required checkduplicate string.
    /// Create string if you have more than single check duplicaterecords like "col1~col2~col3".
    /// Every row will be checked as per your logic.
    /// </summary>
    /// <param name="dRow">Datarow for select criteria</param>
    /// <param name="strErrDup"></param>
    /// <returns></returns>
    public bool checkDuplicateInSameSheet(DataRow dRow, out string strErrDup, DataSet ds)
    {
        strErrDup = "";

        if (uploadFileType.Trim().ToUpper() == "P")
        {
            if (arrSameSheetDataForDuplicate.Contains(dRow.ItemArray[0].ToString().Trim()))
            {
                strErrDup = "DUPISTBExl";
            }
            arrSameSheetDataForDuplicate.Add(dRow.ItemArray[0].ToString().Trim());
            if (strErrDup.Trim() != "")
            {
                return false;
            }

            if (arrSecondSameSheetDataForDuplicate.Contains(dRow.ItemArray[1].ToString().Trim()))
            {
                strErrDup = "DUPIVCExl";
            }
            arrSecondSameSheetDataForDuplicate.Add(dRow.ItemArray[1].ToString().Trim());
            if (strErrDup.Trim() != "")
            {
                return false;
            }
        }
        return true;
    }
    public bool isDateFormatCorrect(string dateFormatCode, string strDateToValidate)
    {
        //Note:Please convert any date we have in mm/dd/yyyy format in above step, for Validation.
        strDate = "";
        /* Here we r using code for date format depening on date field in excel sheet.
         * mm/dd/yyyy ==> 04/07/2006
         * yyyy-mm-dd ==> 2006-04-17
         * yyyymmdd   ==> 20060417
         * yyyy0mm    ==> 2006004
         * mmm-yy     ==> Apr-06
         * dd-mm-yyyy ==> 01-02-2007
         * */
        try
        {
            if (dateFormatCode.ToString().Trim().ToLower() == "mm/dd/yyyy")
            {
                if (strDateToValidate.Length > 10)
                {
                    return false;
                }
                else
                {
                    if (strDateToValidate.IndexOf("/") == -1)
                        return false;
                    string[] strTmp = strDateToValidate.Trim().Split('/');

                    if (strTmp[2].Length != 4)
                    {
                        return false;
                    }
                    if (strTmp.Length == 3)
                    {
                        //strDate = strTmp[1] + "/" + strTmp[0] + "/" + strTmp[2];
                        strDate = strDateToValidate.Trim();
                    }
                    else
                    {
                        return false;
                        // strDate = strDateToValidate.Trim();
                    }
                }
            }
            if (dateFormatCode.ToString().Trim().ToLower() == "dd/mm/yy")
            {
                if (strDateToValidate.Length > 8)
                {
                    return false;
                }
                else
                {
                    string[] strTmp = strDateToValidate.Trim().Split('/');
                    if (strTmp.Length < 2)
                    {
                        return false;
                    }
                    if (Convert.ToInt32(strTmp[0].Length) > 31 || Convert.ToInt32(strTmp[0].Length) == 0)
                    {
                        return false;
                    }
                    if (Convert.ToInt32(strTmp[1].Length) > 12 || Convert.ToInt32(strTmp[1].Length) == 0)
                    {
                        return false;
                    }
                    if (Convert.ToInt32(strTmp[2].Length) == 0)
                    {
                        return false;
                    }
                    if (strTmp[2].Length != 2)
                    {
                        return false;
                    }
                    if (strTmp.Length == 3)
                    {
                        strDate = strTmp[1] + "/" + strTmp[0] + "/" + strTmp[2];
                        //strDate = strDateToValidate.Trim();
                    }
                    else
                    {
                        return false;
                        // strDate = strDateToValidate.Trim();
                    }
                }
            }

            if (dateFormatCode.ToString().Trim().ToLower() == "yyyy-mm-dd")
            {
                string[] strTmp = strDateToValidate.Trim().Split('-');
                if (strTmp.Length == 3)
                {
                    if (Convert.ToInt32(strTmp[2]) > 31 || Convert.ToInt32(strTmp[2].Length) == 0)
                    {
                        return false;
                    }
                    if (Convert.ToInt32(strTmp[1]) > 12 || Convert.ToInt32(strTmp[1].Length) == 0)
                    {
                        return false;
                    }
                    if (Convert.ToInt32(strTmp[0].Length) != 4 || Convert.ToInt32(strTmp[0]) < 1900)
                    {
                        return false;
                    }
                    strDate = strTmp[1] + "/" + strTmp[2] + "/" + strTmp[0];
                }
                else
                {
                    //if (isDateFormatCorrect(strDateToValidate, "mm/dd/yyyy") == false)
                    return false;
                    //strDate = strDateToValidate.Trim();
                }
            }
            else
            {
                if (dateFormatCode.ToString().Trim().ToLower() == "yyyymmdd")
                {
                    if (strDateToValidate.Length != 8)
                    {
                        return false;
                    }
                    else
                    {
                        //char[] arr = strDateToValidate.ToCharArray();
                        strDate = strDateToValidate.Substring(4, 2) + "/" + strDateToValidate.Substring(6, 2) + "/" + strDateToValidate.Substring(0, 4);
                    }
                }
                else if (dateFormatCode.ToString().Trim().ToLower() == "yyyy0mm")
                {
                    if (strDateToValidate.Length > 7)
                    {
                        return false;
                    }
                    else
                    {
                        string[] strTmp = strDateToValidate.Trim().Split('0');
                        //char[] arr = strDateToValidate.ToCharArray();
                        strDate = strTmp[1] + "/01/" + strTmp[0];
                    }
                }
                else if (dateFormatCode.ToString().Trim().ToLower() == "mmm-yy")
                {
                    if (strDateToValidate.Length > 6)
                    {
                        return false;
                    }
                    else
                    {
                        string[] strTmp = strDateToValidate.Trim().Split('-');
                        //char[] arr = strDateToValidate.ToCharArray();
                        if (strTmp.Length == 2)
                        {
                            string strDateOut;
                            if (GlobalParams.convertMonthStrToNum(out strDateOut, strTmp[0]))
                            {
                                strDate = strDateOut + "/01/" + strTmp[1];
                            }
                            else
                            {
                                return false;
                            }
                        }
                        else
                        {
                            return false;
                        }
                    }
                }
                else if (dateFormatCode.ToString().Trim().ToLower() == "dd-mmm-yyyy")
                {
                    if (strDateToValidate.Length > 11)
                    {
                        return false;
                    }
                    else
                    {
                        string[] strTmp = strDateToValidate.Trim().Split('-');
                        //char[] arr = strDateToValidate.ToCharArray();
                        if (strTmp.Length == 3)
                        {
                            string strDateOut;
                            if (GlobalParams.convertMonthStrToNum(out strDateOut, strTmp[1]))
                            {
                                string tmp0 = (strTmp[0].Length == 1) ? "0" + strTmp[0] : strTmp[0];
                                strDate = strDateOut + "/" + tmp0 + "/" + strTmp[2];
                            }
                            else
                            {
                                return false;
                            }
                        }
                        else
                        {
                            return false;
                        }
                    }
                }
                else if (dateFormatCode.ToString().Trim().ToLower() == "dd-mmm-yy")
                {
                    if (strDateToValidate.Length > 9)
                    {
                        return false;
                    }
                    else
                    {
                        string[] strTmp = strDateToValidate.Trim().Split('-');
                        //char[] arr = strDateToValidate.ToCharArray();
                        if (strTmp.Length == 3)
                        {
                            string strDateOut;
                            if (GlobalParams.convertMonthStrToNum(out strDateOut, strTmp[1]))
                            {
                                strDate = strDateOut + "/" + strTmp[0] + "/" + strTmp[2];
                            }
                            else
                            {
                                return false;
                            }
                        }
                        else
                        {
                            return false;
                        }
                    }
                }
                else if (dateFormatCode.ToString().Trim().ToLower() == "dd-mm-yyyy")
                {
                    if (strDateToValidate.Length > 10)
                    {
                        return false;
                    }
                    else
                    {
                        string[] strTmp = strDateToValidate.Trim().Split('-');
                        if (strTmp.Length == 3)
                        {
                            if (strTmp[2].Length != 4 || Convert.ToInt64(strTmp[2]) < 1900)
                            {
                                return false;
                            }
                            strDate = strTmp[1] + "/" + strTmp[0] + "/" + strTmp[2];
                        }
                        else
                        {
                            return false;
                        }
                    }
                }
                else if (dateFormatCode.ToString().Trim().ToLower() == "dd/mm/yyyy")
                {

                    if (strDateToValidate.Length > 10)
                    {
                        return false;
                    }
                    else
                    {
                        string[] strTmp = strDateToValidate.Trim().Split('/');
                        if (strTmp.Length == 3)
                        {
                            if (strTmp[2].Length != 4 || Convert.ToInt64(strTmp[2]) < 1900)
                            {
                                return false;
                            }
                            strDate = strTmp[1] + "/" + strTmp[0] + "/" + strTmp[2];
                        }
                        else
                        {
                            return false;
                        }
                    }

                }

            }
            try
            {
                //Please convert any date we have in mm/dd/yyyy format in above step, for Validation.
                DateTime dt = DateTime.Parse(strDate);
            }
            catch (Exception ex)
            {
                return false;
            }
            finally
            {
                //We are sending dateformat as dd/mm/yyyy into database table.
                string[] strTmp = strDate.Trim().Split('/');
                if (strTmp.Length == 3)
                {
                    strDate = strTmp[1] + "/" + strTmp[0] + "/" + strTmp[2];
                }
            }
        }
        catch (Exception ex)
        {
            return false;
        }
        return true;
    }
    public bool checkForDataBaseValidation(string forTableColumnName, string forWhichTable,
         string forWhichSelectCriteria, string inputIDValue, string searchStringForSql
        , ref string pErrCode, string theErrCode)
    {
        /* Here we r using code for valid ID check depening on data in database table.
         * Note: Respective Codes will get recorded at respective arrayLists.
         *       So as same can be used for inserting into dataBase table.
         * */
        codeForID = 0;

        codeForID = CheckAndGetCodeOnIdFromDB.getCodeForIDInputFromDataBaseTable(forTableColumnName, forWhichTable, forWhichSelectCriteria, inputIDValue, searchStringForSql);
        if (codeForID > 0)
        {
            return true;
        }
        pErrCode += (pErrCode == "" ? "" : rowDelimiter) + theErrCode;
        return false;
    }
    private bool isNullValue(DataRow dRow, int indx, ref string pErrCode)
    {
        if (dRow.ItemArray[indx].ToString() == null || dRow.ItemArray[indx].ToString().Trim() == "")
        {
            if (pErrCode != "")
            {
                pErrCode = pErrCode + rowDelimiter;
            }
            pErrCode = pErrCode + indx.ToString().Trim() + "N";    //Null
            return true;
        }

        return false;
    }

    /// <summary>
    /// Reads excel file along with all validations
    /// </summary>
    /// <param name="uploadObj"></param>
    /// <returns>It returns true if any error </returns>
    public bool readExcelFile(object uploadObjIExcelUploadable, out string errorStr, HtmlInputFile fileInput, System.Web.UI.Page senderWebForm, int login_code)//(ref IExcelUploadable uploadObj)
    {
        errorStr = "";
        arrSameSheetDataForDuplicate = new ArrayList();

        bool isHeaderMismatchErrorFound = false;
        bool allRowsNull = false;
        string strActualFileNameWithDate;
        string path = senderWebForm.Request.ServerVariables["APPL_PHYSICAL_PATH"];
        string fileExtension = "";
        string strFileName = System.IO.Path.GetFileName(fileInput.PostedFile.FileName);
        fileExtension = System.IO.Path.GetExtension(fileInput.PostedFile.FileName);
        //If excel sheet is of extension other than ".xls" ~or~ path is wrong for file to be uploaded.
        if ((fileExtension.ToLower() != ".xls" && fileExtension.ToLower() != ".xlsx") || (fileInput.PostedFile.ContentLength <= 0))
        {
            errorStr = "Please upload Excel Sheet named as " + sheetName.Trim() + " only with .xls extension.";
            return true;
        }
        strActualFileNameWithDate = System.DateTime.Now.Ticks + "~" + strFileName;
        string fullpathname = path + "UploadFolder/UploadExcel/" + strActualFileNameWithDate;
        fileInput.PostedFile.SaveAs(fullpathname);

        //Get interface details for entity class to be uploaded.
        IExcelUploadable uploadObj = (IExcelUploadable)uploadObjIExcelUploadable;

        OleDbConnection cn;
        string strRowDelimited = "";
        DataRow dRow;
        ds = new DataSet();
        try
        {
            //Select from excel sheet in dataset.
            //cn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + fullpathname + ";Extended Properties='Excel 8.0;HDR=No;IMEX=1'");

            //cn = new OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + fullpathname + ";Extended Properties=;Excel 4.0;HDR=No;IMEX=1");
            //OleDbDataAdapter da = new OleDbDataAdapter("Select * From [" + sheetName.Trim() + "$]", cn);
            

            cn = new OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + fullpathname + ";Extended Properties=;Excel 8.0;HDR=YES;IMEX=1");
            OleDbDataAdapter da = new OleDbDataAdapter("Select * From [MigrateCost$]", cn);
            da.Fill(ds );
        }
        catch (Exception ex)
        {
            //If error in select of sheet data.....
            errorStr = "Please upload excel sheet named as \\'" + sheetName.Trim() + "\\'";
            System.IO.File.Delete(fullpathname.Trim());
            return true;
        }
        finally
        {
            //Always delete uploaded excel file from folder.
            System.IO.File.Delete(fullpathname.Trim());
        }
        //Check is there is any table in dataset which shows something got selected from excel sheet.
        if (ds.Tables.Count > 0)
        {
            //Check is there is any data in excel sheet other than header row.
            if (ds.Tables[0].Rows.Count > 1)
            {
                ArrayList colArList = uploadObj.getFileHeaderList();
                int iRowcount = ds.Tables[0].Rows.Count;
                int iColCount = colArList.Count;
                int totalNullCells = 0;

                dRow = ds.Tables[0].Rows[0];
                //header validation
                if (validateHeader(colArList, dRow) == false)
                {
                    //Header is not proper error.
                    strErrCodes = "H";
                    blnIsErrorFound = true;
                    errorStr = "Uploaded excel sheet \\'" + sheetName.Trim() + "\\' header mismatch.";
                    return true;
                }
                uploadFileType = uploadObj.frmUploadFileType().Trim();

                UploadFile objUpFile = new UploadFile();
                objUpFile.uploadRecordCount = ds.Tables[0].Rows.Count - 1;
                objUpFile.UploadedBy = uploadObj.logonUser();
                objUpFile.fileName = strActualFileNameWithDate;
                uploadFileType = uploadObj.frmUploadFileType().Trim();
                objUpFile.uploadType = uploadFileType;
                objUpFile.errorYN = "N";
                objUpFile.bankCode = 0;
                objUpFile.IsLastIdRequired = true;
                objUpFile.Save();
                intFileCode = objUpFile.IntCode;

                DataTable BankS = new DataTable();
                DsNewBS = ds.Copy();
                int NewDsRowCount = 0;
                foreach (DataRow drNewBSWONull in ds.Tables[0].Rows)
                {
                    if (!chechk_nullroeDs(drNewBSWONull))
                        NewDsRowCount++;
                    else
                        break;
                }

                for (int i = NewDsRowCount; i < ds.Tables[0].Rows.Count; i++)
                {
                    DsNewBS.Tables[0].Rows.RemoveAt(NewDsRowCount);
                }

                DataRow ddRow;
                int rowCount = 0;

                for (int i = 1; i < iRowcount; i++)
                {
                    dRow = ds.Tables[0].Rows[i];
                    totalNullCells = 0;
                    strRowDelimited = "";
                    //make columns value list useing delimiter
                    for (int x = 0; x < iColCount; x++)
                    {
                        if (x == 0)
                        {
                            strRowDelimited = dRow.ItemArray[x].ToString().Trim();
                        }
                        else
                        {
                            strRowDelimited = strRowDelimited + rowDelimiter + dRow.ItemArray[x].ToString().Trim();
                        }
                    }
                    //calculate null field's
                    for (int j = 0; j < iColCount; j++)
                    {
                        if (dRow.ItemArray[j] == null || dRow.ItemArray[j].ToString().Trim() == "")
                        {
                            totalNullCells++;
                        }
                    }
                    //If entire row is null then skip valiadtion for current row onwards.
                    if (totalNullCells == iColCount)
                    {
                        if (i == 1)
                            allRowsNull = true;
                        //blnIsErrorFound=true;
                        //isHeaderMismatchErrorFound=true;
                        break;
                    }

                    strErrCodes = "";

                    actualRecordsCount++;
                    if (i == iRowcount - 1)
                    {
                        isLastRow = true;
                    }
                    else
                    {
                        isLastRow = false;
                    }
                    //validate each row()
                    validateThisRow(colArList, dRow, i, isLastRow);
                    //if (uploadFileType.ToString() == "P")
                    //    ExtraVAlidationforP(colArList, dRow, i, ds, WhCode);

                    if (strErrCodes.Trim().Length != 0)
                    {
                        blnIsErrorFound = true;
                        tblRow = new TableRow();
                        tblCell = new TableCell();
                        tblCell.Text = intFileCode.ToString();
                        tblRow.Cells.Add(tblCell);//0
                        tblCell = new TableCell();
                        tblCell.Text = i.ToString();
                        tblRow.Cells.Add(tblCell);//1
                        tblCell = new TableCell();
                        tblCell.Text = strRowDelimited.Trim();
                        tblRow.Cells.Add(tblCell);//2
                        tblCell = new TableCell();
                        tblCell.Text = strErrCodes.Trim();
                        tblRow.Cells.Add(tblCell);//3
                        tblCell = new TableCell();
                        tblCell.Text = uploadFileType.Trim();
                        tblRow.Cells.Add(tblCell);//4							
                        dtErrorOccured.Rows.Add(tblRow);
                    }
                }
                if (blnIsErrorFound == true)
                {
                    //If Error found then make error flag in dataBase table as 'Y'.
                    objUpFile = new UploadFile();
                    //Putting actual records get counted with validation.
                    objUpFile.IntCode = intFileCode;
                    //Actual records get checked in validation loop.
                    objUpFile.fileName = strActualFileNameWithDate;
                    objUpFile.uploadRecordCount = actualRecordsCount;
                    objUpFile.errorYN = "Y";
                    objUpFile.IsLastIdRequired = false;
                    objUpFile.IsDirty = true;
                    objUpFile.Save();
                    //Add errors in error_detail table
                    UploadErrorDetail objUED = new UploadErrorDetail();
                    for (int i = 0; i < dtErrorOccured.Rows.Count; i++)
                    {
                        objUED.fileCode = Convert.ToInt32(dtErrorOccured.Rows[i].Cells[0].Text.ToString().Trim());
                        objUED.rowNum = Convert.ToInt32(dtErrorOccured.Rows[i].Cells[1].Text.ToString().Trim()) + 1;
                        objUED.rowDelimed = dtErrorOccured.Rows[i].Cells[2].Text.ToString().Trim();
                        objUED.errColumns = dtErrorOccured.Rows[i].Cells[3].Text.ToString().Trim();
                        objUED.uploadType = dtErrorOccured.Rows[i].Cells[4].Text.ToString().Trim();
                        objUED.Save();
                    }
                }
                else if (allRowsNull)
                {
                    errorStr = "Uploaded excel not having Data for Upload";
                    return true;
                }
                else
                {
                    //dtSuccess.GetChanges();
                    int rownumber = 0;
                    blnIsErrorFound = uploadObj.writeToDBTableAfterSuccess(dtSuccess, senderWebForm, login_code, intFileCode, ds, 0);
                    if (blnIsErrorFound == false)
                    {
                        if (uploadFileType.ToString() == "RT")
                        {
                            ArrayList arrtaxdetail = new ArrayList();
                            ArrayList arrInvDetail = new ArrayList();
                            foreach (TableRow dr in dtSuccess.Rows)
                            {
                                //InventoryDetail objtaxdtl = new InventoryDetail();
                                //// InventoryDetail objInvDetail = new InventoryDetail();

                                //objtaxdtl.IntCode = 0;
                                //objtaxdtl.serialNo = Convert.ToString(dr.Cells[0].Text);
                                //objtaxdtl.inventoryCode = Convert.ToInt32(bankCode);
                                ////objtaxdtl.status = "1";
                                //objtaxdtl.isPaired = "N";
                                //objtaxdtl.delStatus = "N";
                                //objtaxdtl.reqCode = 0;
                                //objtaxdtl.Tstatus = StockEntrySrNo.StockEntryDone; ;
                                //objtaxdtl.boxTypeCode = boxTypeCode;
                                //arrtaxdetail.Add(objtaxdtl);
                                //arrGRNDetail = arrtaxdetail;
                            }
                        }

                    }
                    if (blnIsErrorFound)
                    {
                        if (uploadFileType.ToString() == "RU" || uploadFileType.ToString() == "RD")
                            errorStr = "Problem in saving row number " + (rownumber + 1);
                        else
                            errorStr = "Problem in uploading file";
                    }
                }

                return blnIsErrorFound;
            }
            else
            {
                //Empty sheet data, only header is there.
                errorStr = "Uploaded excel sheet \\'" + sheetName.Trim() + "\\' is not having data.";
                return true;
            }
        }
        else
        {
            //Empty sheet.
            errorStr = "Uploaded excel sheet \\'" + sheetName.Trim() + "\\' is empty.";
            return true;
        }

    }

    public DataSet readExcel(object uploadObjIExcelUploadable, out string errorStr, HtmlInputFile fileInput, System.Web.UI.Page senderWebForm, int login_code)//(ref IExcelUploadable uploadObj)
    {
        errorStr = "";
        arrSameSheetDataForDuplicate = new ArrayList();

        bool isHeaderMismatchErrorFound = false;
        bool allRowsNull = false;
        string strActualFileNameWithDate;
        string path = senderWebForm.Request.ServerVariables["APPL_PHYSICAL_PATH"];
        string fileExtension = "";
        string strFileName = System.IO.Path.GetFileName(fileInput.PostedFile.FileName);
        fileExtension = System.IO.Path.GetExtension(fileInput.PostedFile.FileName);
        //If excel sheet is of extension other than ".xls" ~or~ path is wrong for file to be uploaded.
        if ((fileExtension.ToLower() != ".xls" && fileExtension.ToLower() != ".xlsx") || (fileInput.PostedFile.ContentLength <= 0))
        {
            errorStr = "Please upload Excel Sheet named as " + sheetName.Trim() + " only with .xls extension.";
           // return true;
        }
        strActualFileNameWithDate = System.DateTime.Now.Ticks + "~" + strFileName;
        string fullpathname = path + "UploadFolder/UploadExcel/" + strActualFileNameWithDate;
        fileInput.PostedFile.SaveAs(fullpathname);

        //Get interface details for entity class to be uploaded.
        IExcelUploadable uploadObj = (IExcelUploadable)uploadObjIExcelUploadable;

        OleDbConnection cn;
        string strRowDelimited = "";
        DataRow dRow;
        ds = new DataSet();
        try
        {
            //Select from excel sheet in dataset.
            
            cn = new OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + fullpathname + ";Extended Properties=;Excel 8.0;HDR=YES;IMEX=1");
            OleDbDataAdapter da = new OleDbDataAdapter("Select * From [MigrateCost$]", cn);
            da.Fill(ds);
        }
        catch (Exception ex)
        {
            //If error in select of sheet data.....
            errorStr = "Please upload excel sheet named as \\'" + sheetName.Trim() + "\\'";
            System.IO.File.Delete(fullpathname.Trim());
            //return true;
        }
        int NewDsRowCount = 0;
        foreach (DataRow drNewBSWONull in ds.Tables[0].Rows)
        {
            if (!chechk_nullroeDs(drNewBSWONull))
                NewDsRowCount++;
            else
                break;
        }

        for (int i = NewDsRowCount; i < ds.Tables[0].Rows.Count; i++)
        {
            ds.Tables[0].Rows.RemoveAt(NewDsRowCount);
        }

        return ds;

    }

    public DataSet readExcelMigrateHouseID(object uploadObjIExcelUploadable, out string errorStr, HtmlInputFile fileInput, System.Web.UI.Page senderWebForm, int login_code)//(ref IExcelUploadable uploadObj)
    {
        errorStr = "";
        arrSameSheetDataForDuplicate = new ArrayList();

        bool isHeaderMismatchErrorFound = false;
        bool allRowsNull = false;
        string strActualFileNameWithDate;
        string path = senderWebForm.Request.ServerVariables["APPL_PHYSICAL_PATH"];
        string fileExtension = "";
        string strFileName = System.IO.Path.GetFileName(fileInput.PostedFile.FileName);
        fileExtension = System.IO.Path.GetExtension(fileInput.PostedFile.FileName);
        //If excel sheet is of extension other than ".xls" ~or~ path is wrong for file to be uploaded.
        if ((fileExtension.ToLower() != ".xls" && fileExtension.ToLower() != ".xlsx") || (fileInput.PostedFile.ContentLength <= 0))
        {
            errorStr = "Please upload Excel Sheet named as " + sheetName.Trim() + " only with .xls extension.";
            // return true;
        }
        strActualFileNameWithDate = System.DateTime.Now.Ticks + "~" + strFileName;
        string fullpathname = path + "UploadFolder/UploadExcel/" + strActualFileNameWithDate;
        fileInput.PostedFile.SaveAs(fullpathname);

        //Get interface details for entity class to be uploaded.
        IExcelUploadable uploadObj = (IExcelUploadable)uploadObjIExcelUploadable;

        OleDbConnection cn;
        string strRowDelimited = "";
        DataRow dRow;
        ds = new DataSet();
        try
        {
            //Select from excel sheet in dataset.

            cn = new OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + fullpathname + ";Extended Properties=;Excel 8.0;HDR=YES;IMEX=1");
            OleDbDataAdapter da = new OleDbDataAdapter("Select * From [migrateHouseID$]", cn);
            da.Fill(ds);
        }
        catch (Exception ex)
        {
            //If error in select of sheet data.....
            errorStr = "Please upload excel sheet named as \\'" + sheetName.Trim() + "\\'";
            System.IO.File.Delete(fullpathname.Trim());
            //return true;
        }

        return ds;

    }

    private void DuplicateCheck(DataSet ds)
    {
        string strErrDup = "";
        if (strErrCodes == "")
        {
            strErrDup = "";
            for (int k = 0; k < ds.Tables[0].Rows.Count; k++)
            {
                if (k != 0)
                {
                    if (arrSameSheetDataForDuplicate.Contains(ds.Tables[0].Rows[k][0].ToString().Trim()))
                    {
                        appendErrCode(ref strErrCodes, "DUPISTB"); // strErrDup = "DUPISTB";//
                        //return false;
                    }
                    arrSameSheetDataForDuplicate.Add(ds.Tables[0].Rows[k][0].ToString().Trim());


                    if (arrSecondSameSheetDataForDuplicate.Contains(ds.Tables[0].Rows[k][1].ToString().Trim()))
                    {
                        appendErrCode(ref strErrCodes, "DUPIVC"); // strErrDup = "DUPIVC";//
                        //  return false;
                    }
                    arrSecondSameSheetDataForDuplicate.Add(ds.Tables[0].Rows[k][1].ToString().Trim());

                }

            }
        }
    }

    private void ExtraVAlidationforP(ArrayList colArList, DataRow dRow, int row, DataSet ds, int WhCode)
    {
        int WhCodeNew = Convert.ToInt32(ConfigurationManager.AppSettings["defaultWHCode"].ToString().Trim());
        string strErrDup = "";
        if (strErrCodes == "")
        {
            strErrDup = "";

            string sqlIdateWHstb = "";
            //sqlIdate = "select count(*) from  Inventory_Detail where serial_no = '" + dRow.ItemArray[0].ToString().Replace("'", "''") + "' and is_paired ='N'";
            sqlIdateWHstb = "select count(*) from  Inventory_Detail id inner join stock_entry_srno SES on ses.inventory_detail_code=id.inventory_detail_code ";
            sqlIdateWHstb += " where id.serial_no = '" + dRow.ItemArray[0].ToString().Replace("'", "''") + "' and ses.wh_code=" + WhCode + " and ses.status in('6','1')  and id.inventory_code='1'";


            string sqlIdateWHvc = "";
            //sqlIdate1 = "select count(*) from  Inventory_Detail where serial_no = '" + dRow.ItemArray[1].ToString().Replace("'", "''") + "' and is_paired ='N'";
            sqlIdateWHvc = "select count(*) from  Inventory_Detail id inner join stock_entry_srno SES on ses.inventory_detail_code=id.inventory_detail_code ";
            sqlIdateWHvc += " where id.serial_no = '" + dRow.ItemArray[1].ToString().Replace("'", "''") + "' and ses.wh_code=" + WhCode + " and ses.status in('6','1') and id.inventory_code='2'";

            string sqlFaultySTB = "";
            string sqlFaultyVC = "";

            sqlFaultySTB = "select count(*) from  Inventory_Detail id inner join stock_entry_srno SES on ses.inventory_detail_code=id.inventory_detail_code ";
            sqlFaultySTB += " where id.serial_no = '" + dRow.ItemArray[0].ToString().Replace("'", "''") + "' and ses.wh_code=" + WhCode + " and ses.status in('8','5') and id.inventory_code='1'";
            sqlFaultyVC = "select count(*) from  Inventory_Detail id inner join stock_entry_srno SES on ses.inventory_detail_code=id.inventory_detail_code ";
            sqlFaultyVC += " where id.serial_no = '" + dRow.ItemArray[1].ToString().Replace("'", "''") + "' and ses.wh_code=" + WhCode + " and ses.status in('8','5') and id.inventory_code='2'";


            if (DatabaseBroker.ProcessScalarDirectly(sqlFaultySTB) > 0 || DatabaseBroker.ProcessScalarDirectly(sqlFaultyVC) > 0)
            {
                if (DatabaseBroker.ProcessScalarDirectly(sqlIdateWHstb) <= 0)
                {
                    appendErrCode(ref strErrCodes, "1STBF"); //Invalid OnAcc Adjustment
                }
                if (DatabaseBroker.ProcessScalarDirectly(sqlIdateWHvc) <= 0)
                {
                    appendErrCode(ref strErrCodes, "1VCF"); //Invalid OnAcc Adjustment
                }
            }
            else if (DatabaseBroker.ProcessScalarDirectly(sqlIdateWHstb) <= 0 || DatabaseBroker.ProcessScalarDirectly(sqlIdateWHvc) <= 0)
            {
                if (DatabaseBroker.ProcessScalarDirectly(sqlIdateWHstb) <= 0)
                {
                    appendErrCode(ref strErrCodes, "1STBWH"); //Invalid OnAcc Adjustment
                }
                if (DatabaseBroker.ProcessScalarDirectly(sqlIdateWHvc) <= 0)
                {
                    appendErrCode(ref strErrCodes, "1VCWH"); //Invalid OnAcc Adjustment
                }
            }
            else
            {

                string sqlIdate = "";
                //sqlIdate = "select count(*) from  Inventory_Detail where serial_no = '" + dRow.ItemArray[0].ToString().Replace("'", "''") + "' and is_paired ='N'";
                sqlIdate = "select count(*) from  Inventory_Detail id inner join stock_entry_srno SES on ses.inventory_detail_code=id.inventory_detail_code ";
                sqlIdate += " inner join stock_entry_detail SED on SED.stock_entry_detail_code=SES.stock_entry_detail_code inner join stock_entry SE on se.stock_entry_code=sed.stock_entry_code";
                sqlIdate += " where id.serial_no = '" + dRow.ItemArray[0].ToString().Replace("'", "''") + "' and id.is_paired ='N' and se.wh_code=" + WhCode + " and SES.status in('6','1')  and id.inventory_code='1'";

                if (DatabaseBroker.ProcessScalarDirectly(sqlIdate) <= 0)
                {
                    appendErrCode(ref strErrCodes, "1STB"); //Invalid OnAcc Adjustment
                }

                string sqlIdate1 = "";
                //sqlIdate1 = "select count(*) from  Inventory_Detail where serial_no = '" + dRow.ItemArray[1].ToString().Replace("'", "''") + "' and is_paired ='N'";
                sqlIdate1 = "select count(*) from  Inventory_Detail id inner join stock_entry_srno SES on ses.inventory_detail_code=id.inventory_detail_code ";
                sqlIdate1 += " inner join stock_entry_detail SED on SED.stock_entry_detail_code=SES.stock_entry_detail_code inner join stock_entry SE on se.stock_entry_code=sed.stock_entry_code";
                sqlIdate1 += " where id.serial_no = '" + dRow.ItemArray[1].ToString().Replace("'", "''") + "' and id.is_paired ='N' and se.wh_code=" + WhCode + " and SES.status in('6','1')  and id.inventory_code='2'";


                if (DatabaseBroker.ProcessScalarDirectly(sqlIdate1) <= 0)
                {
                    appendErrCode(ref strErrCodes, "1VC"); //Invalid OnAcc Adjustment
                }

                //string sqlChl = "";
                //sqlChl = "select count(*) from  Channel where channel_name = '" + dRow.ItemArray[2].ToString().Replace("'", "''") + "' and is_own ='Y'";

                //if (DatabaseBroker.ProcessScalarDirectly(sqlChl) <= 0)
                //{
                //    appendErrCode(ref strErrCodes, "2ChlName"); //Invalid OnAcc Adjustment
                //}

            }

        }

    }

    public string changeDateFormat(string date1)
    {

        string[] arr;
        arr = date1.Trim().Split('/');
        string newdate = "";
        if (arr.Length == 3)
        {
            newdate = arr[1] + "/" + arr[0] + "/" + arr[2];

        }

        return newdate;

    }
    private void appendErrCode(ref string pErrorCodes, string newErrCode)
    {
        if (pErrorCodes != "")
        {
            pErrorCodes += rowDelimiter;
        }
        pErrorCodes += newErrCode;
    }
    private void addTblCell(TableRow TR, string cellTxt)
    {
        TableCell tblCell = new TableCell();
        tblCell.Text = cellTxt;
        TR.Cells.Add(tblCell);
    }

    /// <summary>
    /// It checks for duplicate record present in database
    /// </summary>
    /// <param name="dRow">Datarow for select criteria</param>
    /// <param name="strErrDup">If u have single error code send as it is like "DUP". If more than one error code set as "~" seperated like "DUP1~DUP2~DUP3".</param>
    /// <returns>true=No Duplicate/false=Duplicate</returns>

    private bool chechk_nullroeDs(DataRow drow)
    {
        int colval = 0;
        for (int i = 0; i < drow.ItemArray.Length; i++)
        {
            if (drow.ItemArray[i].ToString() == null || drow.ItemArray[i].ToString() == "")
            {
                colval = colval + 1;
            }
        }

        if (colval == drow.ItemArray.Length)
        {
            return true;
        }
        else
        {
            return false;
        }

    }


    public bool readExcelBORevenue(object uploadObjIExcelUploadable, out string errorStr, HtmlInputFile fileInput, System.Web.UI.Page senderWebForm, int login_code)//(ref IExcelUploadable uploadObj)
    {
        errorStr = "";
        arrSameSheetDataForDuplicate = new ArrayList();

        bool isHeaderMismatchErrorFound = false;
        bool allRowsNull = false;
        string strActualFileNameWithDate;
        string path = senderWebForm.Request.ServerVariables["APPL_PHYSICAL_PATH"];
        string fileExtension = "";
        string strFileName = System.IO.Path.GetFileName(fileInput.PostedFile.FileName);
        fileExtension = System.IO.Path.GetExtension(fileInput.PostedFile.FileName);
        //If excel sheet is of extension other than ".xls" ~or~ path is wrong for file to be uploaded.
        if ((fileExtension.ToLower() != ".xls" && fileExtension.ToLower() != ".xlsx") || (fileInput.PostedFile.ContentLength <= 0))
        {
            errorStr = "Please upload Excel Sheet named as " + sheetName.Trim() + " only with .xls extension.";
            return true;
        }
        strActualFileNameWithDate = System.DateTime.Now.Ticks + "~" + strFileName;
        string fullpathname = path + "UploadFolder/UploadExcel/" + strActualFileNameWithDate;
        fileInput.PostedFile.SaveAs(fullpathname);

        //Get interface details for entity class to be uploaded.
        IExcelUploadable uploadObj = (IExcelUploadable)uploadObjIExcelUploadable;

        OleDbConnection cn;
        string strRowDelimited = "";
        DataRow dRow;
        ds = new DataSet();
        try
        {
            //Select from excel sheet in dataset.
            //cn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + fullpathname + ";Extended Properties='Excel 8.0;HDR=No;IMEX=1'");

            //cn = new OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + fullpathname + ";Extended Properties=;Excel 4.0;HDR=No;IMEX=1");
            //OleDbDataAdapter da = new OleDbDataAdapter("Select * From [" + sheetName.Trim() + "$]", cn);


            cn = new OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + fullpathname + ";Extended Properties=;Excel 8.0;HDR=no;IMEX=1");
            OleDbDataAdapter da = new OleDbDataAdapter("Select * From [Sheet1$]", cn);
            da.Fill(ds);
        }
        catch (Exception ex)
        {
            //If error in select of sheet data.....
            //errorStr = "Please upload excel sheet named as \\'" + sheetName.Trim() + "\\'";
            errorStr = Convert.ToString(ex.Message);  //"Please upload excel sheet named as \\'" + sheetName.Trim() + "\\'";
            System.IO.File.Delete(fullpathname.Trim());
            return true;
        }
        finally
        {
            //Always delete uploaded excel file from folder.
            System.IO.File.Delete(fullpathname.Trim());
        }
        //Check is there is any table in dataset which shows something got selected from excel sheet.
        if (ds.Tables.Count > 0)
        {
            //Check is there is any data in excel sheet other than header row.
            if (ds.Tables[0].Rows.Count > 1)
            {
                ArrayList colArList = uploadObj.getFileHeaderList();
                int iRowcount = ds.Tables[0].Rows.Count;
                int iColCount = colArList.Count;
                int totalNullCells = 0;

                dRow = ds.Tables[0].Rows[0];
                //header validation
                if (validateHeader(colArList, dRow) == false)
                {
                    //Header is not proper error.
                    strErrCodes = "H";
                    blnIsErrorFound = true;
                    errorStr = "Uploaded excel sheet \\'" + sheetName.Trim() + "\\' header mismatch.";
                    return true;
                }
                uploadFileType = uploadObj.frmUploadFileType().Trim();

                UploadFile objUpFile = new UploadFile();
                objUpFile.uploadRecordCount = ds.Tables[0].Rows.Count - 1;
                objUpFile.UploadedBy = uploadObj.logonUser();
                objUpFile.fileName = strActualFileNameWithDate;
                uploadFileType = uploadObj.frmUploadFileType().Trim();
                objUpFile.uploadType = uploadFileType;
                objUpFile.errorYN = "N";
                objUpFile.bankCode = 0;
                objUpFile.IsLastIdRequired = true;
                objUpFile.Save();
                intFileCode = objUpFile.IntCode;

                DataTable BankS = new DataTable();
                DsNewBS = ds.Copy();
                int NewDsRowCount = 0;
                foreach (DataRow drNewBSWONull in ds.Tables[0].Rows)
                {
                    if (!chechk_nullroeDs(drNewBSWONull))
                        NewDsRowCount++;
                    else
                        break;
                }

                for (int i = NewDsRowCount; i < ds.Tables[0].Rows.Count; i++)
                {
                    DsNewBS.Tables[0].Rows.RemoveAt(NewDsRowCount);
                }

                DataRow ddRow;
                int rowCount = 0;

                for (int i = 1; i < iRowcount; i++)
                {
                    dRow = ds.Tables[0].Rows[i];
                    totalNullCells = 0;
                    strRowDelimited = "";
                    //make columns value list using delimiter
                    for (int x = 0; x < iColCount; x++)
                    {
                        if (x == 0)
                        {
                            strRowDelimited = dRow.ItemArray[x].ToString().Trim();
                        }
                        else
                        {
                            strRowDelimited = strRowDelimited + rowDelimiter + dRow.ItemArray[x].ToString().Trim();
                        }
                    }
                    //calculate null field's
                    for (int j = 0; j < iColCount; j++)
                    {
                        if (dRow.ItemArray[j] == null || dRow.ItemArray[j].ToString().Trim() == "")
                        {
                            totalNullCells++;
                        }
                    }
                    //If entire row is null then skip valiadtion for current row onwards.
                    if (totalNullCells == iColCount)
                    {
                        if (i == 1)
                            allRowsNull = true;
                        //blnIsErrorFound=true;
                        //isHeaderMismatchErrorFound=true;
                        break;
                    }

                    strErrCodes = "";

                    actualRecordsCount++;
                    if (i == iRowcount - 1)
                    {
                        isLastRow = true;
                    }
                    else
                    {
                        isLastRow = false;
                    }
                    //validate each row()
                    validateThisRow(colArList, dRow, i, isLastRow);
                    //if (uploadFileType.ToString() == "P")
                    //    ExtraVAlidationforP(colArList, dRow, i, ds, WhCode);

                    if (strErrCodes.Trim().Length != 0)
                    {
                        blnIsErrorFound = true;
                        tblRow = new TableRow();
                        tblCell = new TableCell();
                        tblCell.Text = intFileCode.ToString();
                        tblRow.Cells.Add(tblCell);//0
                        tblCell = new TableCell();
                        tblCell.Text = i.ToString();
                        tblRow.Cells.Add(tblCell);//1
                        tblCell = new TableCell();
                        tblCell.Text = strRowDelimited.Trim();
                        tblRow.Cells.Add(tblCell);//2
                        tblCell = new TableCell();
                        tblCell.Text = strErrCodes.Trim();
                        tblRow.Cells.Add(tblCell);//3
                        tblCell = new TableCell();
                        tblCell.Text = uploadFileType.Trim();
                        tblRow.Cells.Add(tblCell);//4							
                        dtErrorOccured.Rows.Add(tblRow);
                    }
                }
                if (blnIsErrorFound == true)
                {
                    //If Error found then make error flag in dataBase table as 'Y'.
                    objUpFile = new UploadFile();
                    //Putting actual records get counted with validation.
                    objUpFile.IntCode = intFileCode;
                    //Actual records get checked in validation loop.
                    objUpFile.fileName = strActualFileNameWithDate;
                    objUpFile.uploadRecordCount = actualRecordsCount;
                    objUpFile.errorYN = "Y";
                    objUpFile.IsLastIdRequired = false;
                    objUpFile.IsDirty = true;
                    objUpFile.Save();
                    //Add errors in error_detail table
                    UploadErrorDetail objUED = new UploadErrorDetail();
                    for (int i = 0; i < dtErrorOccured.Rows.Count; i++)
                    {
                        objUED.fileCode = Convert.ToInt32(dtErrorOccured.Rows[i].Cells[0].Text.ToString().Trim());
                        objUED.rowNum = Convert.ToInt32(dtErrorOccured.Rows[i].Cells[1].Text.ToString().Trim()) + 1;
                        objUED.rowDelimed = dtErrorOccured.Rows[i].Cells[2].Text.ToString().Trim();
                        objUED.errColumns = dtErrorOccured.Rows[i].Cells[3].Text.ToString().Trim();
                        objUED.uploadType = dtErrorOccured.Rows[i].Cells[4].Text.ToString().Trim();
                        objUED.Save();
                    }
                }
                else if (allRowsNull)
                {
                    errorStr = "Uploaded excel does not have Data for Upload";
                    return true;
                }
                else
                {
                    //dtSuccess.GetChanges();
                    int rownumber = 0;
                    blnIsErrorFound = uploadObj.writeToDBTableAfterSuccess(dtSuccess, senderWebForm, login_code, intFileCode, ds, 0);
                    if (blnIsErrorFound == false)
                    {
                        if (uploadFileType.ToString() == "RB")
                        {
                            ArrayList arrtaxdetail = new ArrayList();
                            ArrayList arrInvDetail = new ArrayList();
                            foreach (TableRow dr in dtSuccess.Rows)
                            {
                                //InventoryDetail objtaxdtl = new InventoryDetail();
                                //// InventoryDetail objInvDetail = new InventoryDetail();

                                //objtaxdtl.IntCode = 0;
                                //objtaxdtl.serialNo = Convert.ToString(dr.Cells[0].Text);
                                //objtaxdtl.inventoryCode = Convert.ToInt32(bankCode);
                                ////objtaxdtl.status = "1";
                                //objtaxdtl.isPaired = "N";
                                //objtaxdtl.delStatus = "N";
                                //objtaxdtl.reqCode = 0;
                                //objtaxdtl.Tstatus = StockEntrySrNo.StockEntryDone; ;
                                //objtaxdtl.boxTypeCode = boxTypeCode;
                                //arrtaxdetail.Add(objtaxdtl);
                                //arrGRNDetail = arrtaxdetail;
                            }
                        }

                    }
                    if (blnIsErrorFound)
                    {
                        if (uploadFileType.ToString() == "RU" || uploadFileType.ToString() == "RD")
                            errorStr = "Problem in saving row number " + (rownumber + 1);
                        else
                            errorStr = "Problem in uploading file";
                    }
                }

                return blnIsErrorFound;
            }
            else
            {
                //Empty sheet data, only header is there.
                errorStr = "Uploaded excel sheet \\'" + sheetName.Trim() + "\\' does not have data.";
                return true;
            }
        }
        else
        {
            //Empty sheet.
            errorStr = "Uploaded excel sheet \\'" + sheetName.Trim() + "\\' is empty.";
            return true;
        }

    }

    private bool checkIfDateBeforeDealDate(int title_Code, string strDate)
    {
        //DateTime dt = Convert.ToDateTime(strDate);
        //string sql = "Select COUNT(*) from Deal where deal_code in ( "
        //                +" Select deal_code from Deal_Movie where title_code in ("+title_Code+") "
        //                +" ) and deal_signed_date < '"+strDate+"'";


        //Commented by bhavesh 
        //string sql = "select count(D.deal_code) from Deal D "
        //            + " inner join Deal_Movie DM on DM.deal_code = D.Deal_code and DM.title_code in(" + title_Code + ")"
        //            +" inner join Deal_Movie_rights DMR on DMR.deal_movie_code = DM.Deal_movie_code "
        //            +" group by D.deal_code "
        //            + " having  Convert(datetime,'" + strDate + "',102) Between min(DMR.right_start_date) and max(DMR.right_end_date)";

        string sql = "select count(d.deal_code) from deal d "
                    + " inner join deal_movie dm on dm.deal_code = d.deal_code and dm.title_code in(" + title_Code + ")"
                    + " inner join deal_movie_rights dmr on dmr.deal_movie_code = dm.deal_movie_code "
                    + " group by D.deal_code ,D.deal_signed_date , DMR.right_period_for "
                    + " having   "
                    + " cast (Convert(datetime,'" + strDate + "',103) as date) between( "
                    + " case  DMR.right_period_for "
                    + " when  'U' THEN  D.deal_signed_date "
                    + " ELSE   min(DMR.right_start_date) END ) "
                    + " AND (case  DMR.right_period_for when  'U' "
                    + " THEN  CASE when CAST(GETDATE() as Date) < CAST(Convert(datetime,'" + strDate + "',103) as date) "
                    + "then  CAST(Convert(datetime,'" + strDate + "',103) as date) else CAST(GETDATE() as Date) end  ELSE   CAST(min(DMR.right_end_date)  as Date) END )";


        string res = DatabaseBroker.ProcessScalarReturnString(sql);
        if (res == "" || Convert.ToInt32(res) == 0) { return true; }

        return false;
    }


}
