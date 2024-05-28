using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using UTOFrameWork.FrameworkClasses;
using System.Collections;
using System.Data;
using System.Web.Script.Services;
using RightsU_BLL;
using System.Data.Entity.Core.Objects;
using System.IO;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]

[Serializable]
public class getExchangeRateWebService : System.Web.Services.WebService
{

    public getExchangeRateWebService()
    {
        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod(EnableSession = true)]
    public string HelloWorld()
    {
        return "Hello World";
    }

    


    //Check Duplicate for Vendor Code BY Sharad on 29-SEPT-2010 of AddEditVendorPage
    [WebMethod(EnableSession = true)]
    public Boolean CheckDuplicateForVendor(string VendorName, int VendorCode)
    {
        Vendor objVendor = new Vendor();
        bool IsExists = objVendor.IsVendorExist(VendorName, VendorCode);
        return IsExists;
    }

    [WebMethod(EnableSession = true)]
    public int getDealMemo_WorkFlowCode(string dealDate, string strDealType)
    {
        //Added by Prashant on 18 Feb 2011
        //strDealType - This flag will b either S for Syndication or A for Acquisition

        string dealSignedDate = Convert.ToString(dealDate);
        int workFlowCode = 0;

        if (strDealType.Trim().ToUpper() == "A")
        {
            //Deal objDeal = new Deal();
            //dealSignedDate = GlobalUtil.MakedateFormat(dealSignedDate);
            //workFlowCode = objDeal.getDealWorkFlowCode(dealSignedDate);
        }
        else if (strDealType.Trim().ToUpper() == "S")
        {
            //SyndicationDeal objSyndicationDeal = new SyndicationDeal();
            //dealSignedDate = GlobalUtil.MakedateFormat(dealSignedDate);
            //workFlowCode = objSyndicationDeal.getDealWorkFlowCode(dealSignedDate);
        }
        return workFlowCode;
    }

    #region ====================METHODS FOR TITLE ====================
    /***************************METHODS FOR SAVE RECORDS IN TO MASTERS FROM SHORTCUTS OF TITLE PAGE************************************/

    /*To Save Territory*/
    [WebMethod(EnableSession = true)]
    public string SaveTerritoryFromTitle(string TerritoryNameTemp, string insertedBY)
    {
        string msg = "";
        Country objTerr = new Country();
        objTerr.CountryName = TerritoryNameTemp;
        objTerr.InsertedBy = Convert.ToInt32(insertedBY);
        objTerr.Is_Active = "Y";

        try
        {
            msg = objTerr.Save();

            if (msg == GlobalParams.RECORD_ADDED)
                msg = objTerr.IntCode.ToString();
            else
                msg = "error";
        }
        catch (DuplicateRecordException)
        {
            msg = "duplicate";
        }
        catch (Exception)
        {
            msg = "error";
        }

        return msg;
    }
    /*End To Save Territory*/

    /*To Save language*/
    [WebMethod(EnableSession = true)]
    public string SaveLanguageFromTitle(string Lanuagename, string insertedBY)
    {
        string msg = "";
        Language objLang = new Language();
        objLang.LanguageName = Lanuagename;
        objLang.InsertedBy = Convert.ToInt32(insertedBY);

        try
        {
            msg = objLang.Save();

            if (msg == GlobalParams.RECORD_ADDED)
                msg = objLang.IntCode.ToString();
            else
                msg = "error";
        }
        catch (DuplicateRecordException)
        {
            msg = "duplicate";
        }
        catch (Exception)
        {
            msg = "error";
        }

        return msg;
    }
    /*End To Save language*/

    /*To Save Genres*/
    [WebMethod(EnableSession = true)]
    public string SaveGenresFromTitle(string Genresname, string insertedBY)
    {
        string msg = "";
        Genres objGenres = new Genres();
        objGenres.GenresName = Genresname;
        objGenres.InsertedBy = Convert.ToInt32(insertedBY);
        objGenres.Is_Active = "Y";

        try
        {
            msg = objGenres.Save();

            if (msg == GlobalParams.RECORD_ADDED)
                msg = objGenres.IntCode.ToString();
            else
                msg = "error";
        }
        catch (DuplicateRecordException)
        {
            msg = "duplicate";
        }
        catch (Exception)
        {
            msg = "error";
        }

        return msg;
    }
    /*End To Save Genres*/

    /*To Save Talent*/
    [WebMethod(EnableSession = true)]
    public string SaveTalent(string talentName, string selectedRole, string gender, string insertedBY)
    {
        string resposeText = "";
        Talent objTalent = new Talent();
        objTalent.talentName = talentName;
        string[] selectedRoleTemp = selectedRole.Split(new string[] { "!" }, StringSplitOptions.None);
        objTalent.Gender = Convert.ToChar(gender);
        objTalent.arrTalentRoles = new ArrayList();

        foreach (string role in selectedRoleTemp)
        {
            TalentRoles objTalentRole = new TalentRoles();
            Roles objRole = new Roles();

            if (role.ToUpper() == "DIRECTOR")
            {
                objRole.IntCode = GlobalParams.RoleCode_Director;
            }
            else if (role.ToUpper() == "STAR CAST")
            {
                objRole.IntCode = GlobalParams.RoleCode_StarCast;
            }
            else if (role.ToUpper() == "SINGERS")   /* Added By Sharad on 9 Dec 2010  */
            {
                objRole.IntCode = GlobalParams.Role_Code_Singer;
            }
            else if (role.ToUpper() == "PRODUCER")
            {
                objRole.IntCode = GlobalParams.Role_code_Producer;
            }
            else if (role.ToUpper() == "WRITER")
            {
                objRole.IntCode = GlobalParams.Role_code_Writer;
            }
            else if (role.ToUpper() == "DIALOGUES")
            {
                objRole.IntCode = GlobalParams.Role_code_DIALOGUES;
            }
            else if (role.ToUpper() == "SCREEN PLAY")
            {
                objRole.IntCode = GlobalParams.Role_code_SCREEN_PLAY;
            }
            else if (role.ToUpper() == "SCRIPT")
            {
                objRole.IntCode = GlobalParams.Role_code_SCRIPT;
            }
            else if (role.ToUpper() == "STORY")
            {
                objRole.IntCode = GlobalParams.Role_code_STORY;
            }
            else if (role.ToUpper() == "MUSIC COMPOSER")
            {
                objRole.IntCode = GlobalParams.Role_code_MusicComposer;
            }
            else if (role.ToUpper() == "LYRICIST")
            {
                objRole.IntCode = GlobalParams.Role_code_lyricist;
            }
            else if (role.ToUpper() == "DOP")
            {
                objRole.IntCode = GlobalParams.RoleCode_Cinematographer;
            }
            else if (role.ToUpper() == "CHOREOGRAPHER")
            {
                objRole.IntCode = GlobalParams.RoleCode_Choreographer;
            }

            objTalentRole.objRoles = objRole;
            objTalent.arrTalentRoles.Add(objTalentRole);
        }

        objTalent.InsertedBy = Convert.ToInt32(insertedBY);
        objTalent.IsTransactionRequired = true;
        objTalent.IsBeginningOfTrans = true;
        objTalent.IsEndOfTrans = true;
        objTalent.IsProxy = false;

        try
        {
            string msg = objTalent.Save();

            if (msg == GlobalParams.RECORD_ADDED)
                resposeText = objTalent.IntCode.ToString();
            else
                resposeText = "error";
        }
        catch (DuplicateRecordException)
        {
            resposeText = "duplicate";
        }
        catch (Exception)
        {
            resposeText = "error";
        }

        return resposeText;
    }
    /*End To Save Talent*/
    /***************************END METHODS FOR SAVE RECORDS IN TO MASTER FROM SHORTCUTS OF TITLE PAGE************************************/

    [WebMethod(EnableSession = true)]
    public string CheckDuplicateTitleName(string TitleName, string TitleCode)
    {
        string msg = "";
        Title objTitle = new Title();

        if (TitleCode == "")
            TitleCode = "0";

        bool IsExists = objTitle.IsTitleExist(TitleName, Convert.ToInt32(TitleCode));

        if (IsExists)
            msg = "InValid";
        else
            msg = "Valid";

        return msg;
    }

    //SaveLanguageFromTitle(string Lanuagename, string insertedBY)
    public string SaveProducerFromTitle(string ProducerName, string insertedBY)
    {
        string msg = "";
        Vendor objVendor = new Vendor();
        objVendor.VendorName = ProducerName;
        objVendor.IsBeginningOfTrans = true;
        objVendor.IsEndOfTrans = true;
        objVendor.IsTransactionRequired = true;
        objVendor.InsertedBy = Convert.ToInt32(insertedBY);
        objVendor.Is_Active = "Y";
        VendorRole ObjVendorRole = new VendorRole();
        ObjVendorRole.RoleCode = GlobalParams.RoleCode_Producer;
        objVendor.ArrRole.Add(ObjVendorRole);
        objVendor.IsProxy = false;

        try
        {
            msg = objVendor.Save();

            if (msg == GlobalParams.RECORD_ADDED)
                msg = objVendor.IntCode.ToString();
            else
                msg = "error";
        }
        catch (DuplicateRecordException)
        {
            msg = "duplicate";
        }
        catch (Exception)
        {
            msg = "error";
        }

        return msg;
    }

    #endregion

    //For to give alert in Syndication Deal Right preffered week selection if selected pf week 
    //is Already added in another Deal for same movie and same platform.
    [WebMethod(EnableSession = true)]
    public string checkPfWKReference(string WK, int titleCode, string platformCode)
    {
        string[] arrWKStartEndDate = WK.Split('-');

        string strWKStartDate = arrWKStartEndDate[0].Trim();
        string strWKEndDate = arrWKStartEndDate[1].Trim();

        string strSql = " select SD.syndication_no from syn_deal_movie_rights_yearwise_run_week SDMRWK "
        + " inner join syn_deal_movie_rights SDMR on SDMR.syn_deal_movie_rights_code=SDMRWK.syn_deal_movie_rights_code "
        + " inner join syndication_deal_movie SDM on SDM.syndication_deal_movie_code=SDMR.syndication_deal_movie_code "
        + " inner join syndication_deal SD on SD.syndication_deal_code = SDM.syndication_deal_code "
        + " where ('" + GlobalUtil.GetFormatedDateTime(strWKStartDate) + "' between start_week_date and end_week_date or '" + GlobalUtil.GetFormatedDateTime(strWKEndDate) + "' between start_week_date and end_week_date "
        + " or start_week_date  between '" + GlobalUtil.GetFormatedDateTime(strWKStartDate) + "' and '" + GlobalUtil.GetFormatedDateTime(strWKEndDate) + "' or end_week_date  between '" + GlobalUtil.GetFormatedDateTime(strWKStartDate) + "' and '" + GlobalUtil.GetFormatedDateTime(strWKEndDate) + "' )"
        + " and is_preferred='Y'and SDM.title_code in (" + titleCode + ") and SDMR.platform_code in (" + platformCode + ") "
        + " and ISNULL(SD.Is_Active,'N') = 'Y' ";

        string msg = "";
        string synDealNo = "";
        DataSet dsDealNo = new DataSet();
        dsDealNo = DatabaseBroker.ProcessSelectDirectly(strSql);

        if (dsDealNo.Tables[0].Rows.Count > 0)
        {
            synDealNo = Convert.ToString(dsDealNo.Tables[0].Rows[0]["syndication_no"]);
            msg = "Week [" + WK + "] is already used for another syndication deal. <br/> Deal No. : " + synDealNo;
        }

        return msg;
    }

    [WebMethod(EnableSession = true)]
    public int CheckDupAmortRule(int ruleCode, string gridData)
    {
        AmortRule objAmortRule = new AmortRule();
        bool IsExists;

        if (!gridData.Contains("-"))
        {
            int noOfMonth = Convert.ToInt32(gridData);
            IsExists = objAmortRule.IsAmortRuleExist(ruleCode, noOfMonth);
        }
        else
        {
            IsExists = objAmortRule.IsAmortRuleExistForMulipleChild(ruleCode, gridData);
        }

        if (IsExists)
            return 1;
        else
            return 0;
    }

    [WebMethod(EnableSession = true)]
    public int CheckDupRuleNo(int ruleCode, string ruleNo)
    {
        AmortRule objAmortRule = new AmortRule();
        bool IsExists = objAmortRule.IsRuleNoExist(ruleNo, ruleCode);

        if (IsExists)
            return 1;
        else
            return 0;
    }

    [WebMethod(EnableSession = true)]
    //public DataSet FillTerritory(string strPlatformCodes , ListBox lstPlatform)
    //{
    //    DataSet dset = new DataSet();
    //    string strSelect = 
    //    return dset;
    //}

    public string FillTerritory(string strPlatformCodes)
    {
        strPlatformCodes = strPlatformCodes.Trim('~').Replace('~', ',').Trim(',');

        DataSet dset = new DataSet();
        string strTerritoryRecords = string.Empty;
        string isApplicableForDomesticTerritory = string.Empty;
        string strSql = "";
        string strSelect = " select	distinct applicable_for_Demestic_territory	from Platform where platform_code in(" + strPlatformCodes + ")";
        dset = DatabaseBroker.ProcessSelectDirectly(strSelect);

        if (dset.Tables[0].Rows.Count > 0)
            isApplicableForDomesticTerritory = Convert.ToString(dset.Tables[0].Rows[0][0]);

        if (isApplicableForDomesticTerritory.ToUpper() == "Y")
            strSql = " select territory_code,territory_name from Territory where is_active = 'Y' ";
        else
            strSql = " select Country_code,Country_name from Country where is_Domestic_territory = 'Y' " +
                     " and is_active = 'Y'";

        DataSet dsTerritory = new DataSet();
        dsTerritory = DatabaseBroker.ProcessSelectDirectly(strSql);

        foreach (DataRow drow in dsTerritory.Tables[0].Rows)
        {
            strTerritoryRecords += drow[0] + "~" + drow[1] + "#";
        }

        string strTemp = strTerritoryRecords.Trim('#');
        return strTemp + "@" + isApplicableForDomesticTerritory;
    }


    [WebMethod(EnableSession = true)]
    public string FillFormat(string strPlatformCodes, string rightCatCodeForFormat)
    {
        string strFormatRecords = string.Empty;
        string strSelectedPlatforms = RemoveExtraComma(strPlatformCodes.Replace("~", ",").Trim(','), ",");
        string strPlatformsApplicableForFormatTab = string.Empty;

        strPlatformsApplicableForFormatTab = " SELECT STUFF	" +
                                              "	( " +
                                              " 	( " +
                                                    "	Select ',' + CONVERT(VARCHAR(100) , platform_code) from Platform where 1=1  " +
                                                    "	AND platform_code IN (" + (strSelectedPlatforms == string.Empty ? "0" : strSelectedPlatforms) + ") " +
                                                    "	and platform_code in( select platforms_code  from rights_category_platforms where rights_category_code = " + rightCatCodeForFormat + ") " +
                                                    "	FOR XML PATH('') " +
                                                    " ) " +
                                                    ", 1, 1, '' " +
                                             "	) AS D";


        string strSeperatedPt = DatabaseBroker.ProcessScalarReturnString(strPlatformsApplicableForFormatTab);
        string[] strValidPt = strSeperatedPt.Trim(',').Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
        int intValidPtCount = strValidPt.Count();

        string strFilterFormat = " select format_code, format_name from Format ft where 1=1 and ft.format_code in( select f.format_code from format f " +
                        " inner join format_platforms fp on f.format_code = fp.format_code " +
                        " where fp.platform_code in ( " + (strSeperatedPt == string.Empty ? "0" : strSeperatedPt) + " ) " +
                        " group by f.format_code  " +
                        " having COUNT(*) = " + intValidPtCount + " )";

        DataSet dsFormat = new DataSet();
        dsFormat = DatabaseBroker.ProcessSelectDirectly(strFilterFormat);

        foreach (DataRow drow in dsFormat.Tables[0].Rows)
        {
            strFormatRecords += drow[0] + "~" + drow[1] + "#";
        }

        string strTemp = strFormatRecords.Trim('#');
        return strTemp;
    }

    public string RemoveExtraComma(string Str, string seprator)
    {
        while (Str.Contains(seprator + seprator))
        {
            Str = Str.Replace(seprator + seprator, seprator);
        }
        return Str;
    }


    [WebMethod(EnableSession = true)]   /* added by prashant on 20 June 2011 */
    public string getCommonPlatformForHoldback(string strSelectedMovieCount, string AllPlatformCdes)
    {
        string strSql = string.Empty;
        strSql = "select dbo.fn_GetCommonPlatformForHoldBack(" + strSelectedMovieCount + ",'" + AllPlatformCdes + "')";
        string strReultOut = DatabaseBroker.ProcessScalarReturnString(strSql);
        return strReultOut;
    }


    [WebMethod(EnableSession = true)]
    public string CountOfLicensorMovies(string strLicensorMovies, string strLicensorCodes, string strSource)
    {
        //DealMovie objDealMovie = new DealMovie();
        string movieCount = "0";// objDealMovie.GetMovieCount(strLicensorMovies, strLicensorCodes);

        if (movieCount == "0")
            return Convert.ToString(strSource);
        else
            return string.Empty;
    }


    [WebMethod(EnableSession = true)]
    public string SetEndDate(string StartDate, string MM, string YYYY)
    {
        string Enddate = DatabaseBroker.ProcessScalarReturnString("select  convert(varchar(100), dateadd(d,-1,DATEADD(MONTH," + MM + ",DATEADD(YEAR," + YYYY + ",convert(datetime,'" + StartDate + "',103)))),103)");
        return Enddate;
    }


    [WebMethod(EnableSession = true)]   // Added By Sharad for Use In the Amort Rule
    public string CheckDupRuleNoForAmort(int code, string ruleNo)
    {
        string strResult = string.Empty;
        int ruleCode = Convert.ToInt32(code);
        string ruleNumber = Convert.ToString(ruleNo);
        AmortRule objAmortRule = new AmortRule();
        bool IsExists = objAmortRule.IsRuleNoExist(ruleNumber, ruleCode);

        if (IsExists)
            strResult = "InValid";
        else
            strResult = "Valid";

        return strResult;
    }

    [WebMethod(EnableSession = true)]   // Added By Sharad for Use In the Amort Rule
    public string CheckDupAmortRuleForAmort(int code, string strgridData)
    {
        string strResult = string.Empty;
        int ruleCode = Convert.ToInt32(code);
        string gridData = Convert.ToString(strgridData);
        AmortRule objAmortRule = new AmortRule();
        bool IsExists;

        if (!gridData.Contains("-"))
        {
            int noOfMonth = Convert.ToInt32(gridData);
            IsExists = objAmortRule.IsAmortRuleExist(ruleCode, noOfMonth);
        }
        else
        {
            IsExists = objAmortRule.IsAmortRuleExistForMulipleChild(ruleCode, gridData);
        }

        if (IsExists)
            strResult = "InValid";
        else
            strResult = "Valid";

        return strResult;
    }


    [WebMethod(EnableSession = true)]
    public string getTitleSynonpsis_Deal(int titleCode)
    {
        string strResult = string.Empty;
        Title objT = new Title();

        try
        {
            strResult = objT.getSynopsis(titleCode);
        }
        catch (Exception)
        {
            strResult = "error";
        }

        return strResult;
    }

    [WebMethod(EnableSession = true)]
    public string IsTitleTentativeOnly(string titlecode)
    {
        string strQuery = "select count(DMR.platform_code) from Deal_Movie DM " +
                    "inner join Deal_Movie_Rights DMR on  DMR.deal_movie_code = DM.deal_movie_code and ISNULL(UPPER(LTRIM(RTRIM(DMR.IsTentative))), '') != 'Y' " +
                    "where DM.title_code in (" + titlecode + ")";
        int count = DatabaseBroker.ProcessScalarDirectly(strQuery);

        if (count >= 1)
            return "N";

        return "Y";
    }


    [WebMethod(EnableSession = true)]
    public string ValidateRightsEndDateWithBlackoutMaxDate(string RightsEndDate, string BlackoutMaxDate)
    {
        return DatabaseBroker.ProcessScalarReturnString("select [dbo].[fn_validate_RightsEndDate_With_MaxBlackoutEndDate] ('" + RightsEndDate + "','" + BlackoutMaxDate + "')");
    }


    [WebMethod(EnableSession = true)]
    public bool IsSameRightContainBothTerritory(string territoryCode, string countryCode)
    {
        bool isConatin = false;//TerritoryGroup.IsSameRightContainBothTerritory(territoryCode, countryCode);
        //string strQuery = "select count(*) from acq_deal_rights_territory where Acq_Deal_Rights_Code is not Null and Country_Code=" + countryCode + " and Territory_Code=" + territoryCode;
        //int count = DatabaseBroker.ProcessScalarDirectly(strQuery);
        //if (count >= 1)
        //    return true;
        //else
        //return false;
        return isConatin;
    }


    [WebMethod(EnableSession = true)]
    public string BindDropDownAncillaryMedium(string strAncillaryPlatformCode)
    {
        DataSet ds = new DataSet();
        string str = "";
        //string strSql = "Select Ancillary_Medium_Code,Ancillary_Medium_Name from Ancillary_Medium"
        //            + " Where Ancillary_Medium_Code IN"
        //            + " ( "
        //                + " Select Ancillary_Medium_Code From Ancillary_Platform_Medium "
        //                + " Where Ancillary_Platform_code IN(" + strAncillaryPlatformCode + ")"
        //            + " )";
        string strSql = "Select APM.Ancillary_Platform_Medium_Code,Ancillary_Medium_Name from Ancillary_Medium  AM"
                        + " Inner Join Ancillary_Platform_Medium APM ON AM.Ancillary_Medium_Code=APM.Ancillary_Medium_Code"
                        + " Where APM.Ancillary_Platform_code IN(" + strAncillaryPlatformCode + ")";

        ds = DatabaseBroker.ProcessSelectDirectly(strSql);

        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            str += ds.Tables[0].Rows[i]["Ancillary_Medium_Name"].ToString()
                + "#" + ds.Tables[0].Rows[i]["Ancillary_Platform_Medium_Code"].ToString() + "^";
        }
        return str.Trim('^');
    }


    [WebMethod(EnableSession = true)]
    public string BindDropDownAncillaryPlatform(int SelectedAncillaryTypeCode)
    {
        DataSet ds = new DataSet();
        string str = "";
        string sql = "Select Ancillary_Platform_code,Platform_Name from Ancillary_Platform Where  Ancillary_Type_code = " + SelectedAncillaryTypeCode;
        ds = DatabaseBroker.ProcessSelectDirectly(sql);

        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            str += ds.Tables[0].Rows[i]["Platform_Name"].ToString()
                + "#" + ds.Tables[0].Rows[i]["Ancillary_Platform_code"].ToString() + "^";
        }

        return str.Trim('^');
    }


    [WebMethod(EnableSession = true)]
    public string BindLanguagesDDL(string movies, string platforms, string country, string LangType)
    {
       // USP_Service objUS = new USP_Service();
        IQueryable<RightsU_Entities.Language> LangaugeList;
       // Language_Service objCS = new Language_Service();
        string str = "";
        LangType = LangType == "S" ? "SL" : "DL";

        try
        {
            //string Code = objUS.USP_GET_DATA_FOR_APPROVED_TITLES(
            //                                                    movies.ToString().Replace('~', ',').Trim(',')
            //                                                    , platforms.ToString().Replace('~', ',').Trim(',')
            //                                                    , country.ToString().Replace('~', ',').Trim(',')
            //                                                    , LangType).ElementAt(0);
            //if (Code != null)
            //{
            //    string[] Language_Codes = Code.Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            //    LangaugeList = objCS.SearchFor(x => x.Language_Code > 0 && Language_Codes.Contains(x.Language_Code.ToString()));
            //    foreach (var item in LangaugeList)
            //        str += item.Language_Name + "#" + item.Language_Code + "^";
            //}
        }
        catch (Exception exmsg)
        { }
        return str.Trim('^');
    }


    [WebMethod(EnableSession = true)]
    public bool ValidateAndMoveRL(string territoryCode, string countryCode)
    {
        string strQuery = "select((select count(*) from acq_deal_rights_territory where Acq_Deal_Rights_Code is not Null and Country_Code=" + countryCode + " and Territory_Code=" + territoryCode + ")+(select count(*) from acq_deal_pushback_territory where acq_deal_pushback_Code is not Null and Country_Code=" + countryCode + " and Territory_Code=" + territoryCode + "))";
        int count = DatabaseBroker.ProcessScalarDirectly(strQuery);

        if (count >= 1)
            return true;
        else
            return false;
    }


    [WebMethod(EnableSession = true)]
    public bool ValidateWithDeal(string territoryCode, string countryCode)
    {
        string strQuery = "Exec USP_ValidateWithDeal '" + territoryCode + "','" + countryCode + "'";
        int count = DatabaseBroker.ProcessScalarDirectly(strQuery);

        if (count >= 1)
            return true;
        else
            return false;
    }


    //[WebMethod(EnableSession = true)]
    //public bool IsSameRightContainsIn_deal_rights(string territoryCode, string countryCode)
    //{
    //    string strQuery = "select count(*) from acq_deal_rights_territory where Acq_Deal_Rights_Code is not Null and Country_Code=" + countryCode + " and Territory_Code=" + territoryCode;
    //    int count = DatabaseBroker.ProcessScalarDirectly(strQuery);
    //    if (count >= 1)
    //        return true;
    //    else
    //        return false;
    //}


    [WebMethod(EnableSession = true)]
    public bool chkCountryEnability(string countryCode)
    {
        string strQuery = "select((select count(*) from acq_deal_rights_territory where Acq_Deal_Rights_Code is not Null and Country_Code="
            + countryCode + ")+(select count(*) from acq_deal_pushback_territory where acq_deal_pushback_Code is not Null and Country_Code="
            + countryCode + ")+(select count(*) from Country where Parent_Country_Code=" + countryCode + "))";
        int count = DatabaseBroker.ProcessScalarDirectly(strQuery);

        if (count > 0)
            return true;
        else
            return false;
    }


    [WebMethod(EnableSession = true)]
    public bool chkTerritoryEnability(string territoryCode)
    {
        string strQuery = "select((select count(*) from acq_deal_rights_territory where Acq_Deal_Rights_Code is not Null  and Territory_Code=" + territoryCode + ")+(select count(*) from acq_deal_pushback_territory where acq_deal_pushback_Code is not Null and Territory_Code=" + territoryCode + "))";
        int count = DatabaseBroker.ProcessScalarDirectly(strQuery);

        if (count >= 1)
            return true;
        else
            return false;
    }


    [WebMethod(EnableSession = true)]
    public string GetSynRightStatus(string RightCode, string DealCode)
    {
        if (Convert.ToInt32(RightCode) > 0)
        {
            string strQuery = "Select ISNULL(Right_Status,'P') as Right_Status from Syn_Deal_Rights where Syn_Deal_Rights_Code = " + RightCode;
            //return DatabaseBroker.ProcessScalarReturnString(strQuery);
            DataSet ds = DatabaseBroker.ProcessSelectDirectly(strQuery);
            return ds.Tables[0].Rows[0]["Right_Status"].ToString();
        }
        else
        {
            string strQuery = "Select COUNT(Syn_Deal_Code) from Syn_Deal_Rights  where Syn_Deal_Code = " + DealCode + " and ISNULL( Right_Status,'P') in ('E')";
            int count = DatabaseBroker.ProcessScalarDirectly(strQuery);

            if (count >= 1)
                return "E";

            strQuery = "Select COUNT(Syn_Deal_Code) from Syn_Deal_Rights  where Syn_Deal_Code = " + DealCode + " and ISNULL( Right_Status,'P') in ('P')";
            count = DatabaseBroker.ProcessScalarDirectly(strQuery);

            if (count >= 1)
                return "P";
            else
                return "C";
        }
    }

    [WebMethod(EnableSession = true)]
    public List<Country> LoadCountry(string code)
    {
        int TerriteroyCode = Convert.ToInt32(code.TrimStart('T'));
        //Territory_Details_Service terrDeatailService = new Territory_Details_Service();
        List<Country> lstCountry = new List<Country>();
        //lstCountry = terrDeatailService.SearchFor(t => t.Territory_Code == TerriteroyCode).Select(c => new Country { IntCode = c.Country_Code, CountryName = c.Country.Country_Name }).OrderBy(c=>c.CountryName).ToList();
        return lstCountry;
    }

    [WebMethod(EnableSession = true)]
    public List<Language> LoadLanguage(string code)
    {
        int LangGroupCode = Convert.ToInt32(code.TrimStart('G'));
        //Language_Group_Service languGroupService = new Language_Group_Service();
        List<Language> lstCountry = new List<Language>();
        //lstCountry = languGroupService.GetById(LangGroupCode).Language_Group_Details.Select(c => new Language { IntCode = c.Language_Code.Value, LanguageName = c.Language.Language_Name }).ToList();
        return lstCountry;
    }

    [WebMethod (EnableSession = true)]
    public string LoadUserControl()
    {
        using (Page page = new Page())
        {
            //int[] arrPlatform;
            //arrPlatform = new Platform_Service().SearchFor(p => p.Is_Active == "Y")
            //                                                                    .Select(p => p.Platform_Code).Distinct().ToArray();
            //RightsU_WebApp.UserControl.UC_Platform_Tree userControl = (RightsU_WebApp.UserControl.UC_Platform_Tree)page.LoadControl("UserControl/UC_Platform_Tree.ascx");
            //userControl.PlatformCodes_Display = string.Join(",", arrPlatform);
            //userControl.PopulateTreeNode("N");
            //System.Web.UI.HtmlControls.HtmlForm form = new System.Web.UI.HtmlControls.HtmlForm();
            //form.Controls.Add(userControl);
            //page.Controls.Add(form);
            using (StringWriter writer = new StringWriter())
            {
                //page.Controls.Add(userControl);
                HttpContext.Current.Server.Execute(page, writer, false);
                return writer.ToString();
            }
        }
    }
}

