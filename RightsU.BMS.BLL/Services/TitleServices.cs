using Newtonsoft.Json;
using RightsU.BMS.BLL.Miscellaneous;
using RightsU.BMS.DAL;
using RightsU.BMS.DAL.Repository;
using RightsU.BMS.Entities;
using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.InputClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace RightsU.BMS.BLL.Services
{
    public class TitleServices
    {
        private readonly TitleRepositories objTitleRepositories = new TitleRepositories();
        private readonly Title_CountryRepositories objTitle_CountryRepositories = new Title_CountryRepositories();
        private readonly Title_TalentRepositories objTitle_TalentRepositories = new Title_TalentRepositories();
        private readonly Title_GenersRepositories objTitle_GenersRepositories = new Title_GenersRepositories();
        private readonly Extended_ColumnsRepositories objExtendedColumnsRepositories = new Extended_ColumnsRepositories();
        private readonly Extended_Columns_ValueRepositories objExtended_Columns_ValueRepositories = new Extended_Columns_ValueRepositories();
        private readonly Map_Extended_ColumnsRepositories objMap_Extended_ColumnsRepositories = new Map_Extended_ColumnsRepositories();
        private readonly Map_Extended_Columns_DetailsRepositories objMap_Extended_Columns_DetailsRepositories = new Map_Extended_Columns_DetailsRepositories();
        private readonly LanguageRepositories objLanguageRepositories = new LanguageRepositories();
        private readonly ProgramRepositories objProgramRepositories = new ProgramRepositories();
        private readonly CountryRepositories objCountryRepositories = new CountryRepositories();
        private readonly TalentRepositories objTalentRepositories = new TalentRepositories();
        private readonly RoleRepositories objRoleRepositories = new RoleRepositories();
        private readonly Deal_TypeRepositories objDeal_TypeRepositories = new Deal_TypeRepositories();
        private readonly GenresRepositories objGenresRepositories = new GenresRepositories();
        private readonly BannerRepositories objBannerRepositories = new BannerRepositories();
        private readonly AL_LabRepositories objAL_LabRepositories = new AL_LabRepositories();

        //public TitleReturn List_Titles(string order, Int32? page, string search_value, Int32? size, string sort, string Date_GT, string Date_LT, Int32? id)
        //{
        //    TitleReturn objTitleReturn = new TitleReturn();
        //    objTitleReturn = objTitleRepositories.GetTitle_List(order, page.Value, search_value, size.Value, sort, Date_GT, Date_LT, id.Value);
        //    return objTitleReturn;
        //}

        public GenericReturn GetTitleList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validations

            if (!string.IsNullOrEmpty(order))
            {
                if (order.ToUpper() != "ASC")
                {
                    if (order.ToUpper() != "DESC")
                    {
                        _objRet.Message = "Input Paramater 'order' is not in valid format";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }
                }
            }
            else
            {
                order = ConfigurationManager.AppSettings["defaultOrder"];
            }

            if (page == 0)
            {
                page = Convert.ToInt32(ConfigurationManager.AppSettings["defaultPage"]);
            }

            if (size > 0)
            {
                var maxSize = Convert.ToInt32(ConfigurationManager.AppSettings["maxSize"]);
                if (size > maxSize)
                {
                    _objRet.Message = "Input Paramater 'size' should not be greater than " + maxSize;
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                }
            }
            else
            {
                size = Convert.ToInt32(ConfigurationManager.AppSettings["defaultSize"]);
            }

            if (!string.IsNullOrEmpty(sort.ToString()))
            {
                if (sort.ToLower() == "CreatedDate".ToLower())
                {
                    sort = "Inserted_On";
                }
                else if (sort.ToLower() == "UpdatedDate".ToLower())
                {
                    sort = "Last_UpDated_Time";
                }
                else if (sort.ToLower() == "TitleName".ToLower())
                {
                    sort = "Title_Name";
                }
                else
                {
                    _objRet.Message = "Input Paramater 'sort' is not in valid format";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                }
            }
            else
            {
                sort = ConfigurationManager.AppSettings["defaultSort"];
            }

            try
            {
                if (!string.IsNullOrEmpty(Date_GT))
                {
                    try
                    {
                        Date_GT = DateTime.Parse(Date_GT).ToString("yyyy-MM-dd");
                    }
                    catch (Exception ex)
                    {
                        _objRet.Message = "Input Paramater 'dateGt' is not in valid format";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }

                }
                if (!string.IsNullOrEmpty(Date_LT))
                {
                    try
                    {
                        Date_LT = DateTime.Parse(Date_LT).ToString("yyyy-MM-dd");
                    }
                    catch (Exception ex)
                    {
                        _objRet.Message = "Input Paramater 'dateLt' is not in valid format";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }
                }

                if (!string.IsNullOrEmpty(Date_GT) && !string.IsNullOrEmpty(Date_LT))
                {
                    if (DateTime.Parse(Date_GT) > DateTime.Parse(Date_LT))
                    {
                        _objRet.Message = "Input Paramater 'dateLt' should not be less than 'dateGt'";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }
                }
            }
            catch (Exception ex)
            {
                _objRet.Message = "Input Paramater 'dateLt' or 'dateGt' is not in valid format";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            #endregion

            TitleReturn _TitleReturn = new TitleReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _TitleReturn = objTitleRepositories.GetTitle_List(order, page, search_value, size, sort, Date_GT, Date_LT, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _TitleReturn.paging.page = page;
            _TitleReturn.paging.size = size;

            _objRet.Response = _TitleReturn;

            return _objRet;
        }

        public List<USPAPI_Title_Bind_Extend_Data> USPAPI_Title_Bind_Extend_Data(Nullable<int> title_Code)
        {
            return objTitleRepositories.USPAPI_Title_Bind_Extend_Data(title_Code);
        }

        public GenericReturn GetTitleById(Int32 id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (id == 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    TitleInput _TitleReturn = new TitleInput();

                    var objTitle = objTitleRepositories.GetById(id);

                    _TitleReturn.id = objTitle.Title_Code.Value;
                    _TitleReturn.Name = objTitle.Title_Name;

                    #region Title Language

                    TitleGeneric objTitleLanguage = new TitleGeneric();

                    var titleLanguage = objLanguageRepositories.Get(objTitle.Title_Language_Code.Value);

                    objTitleLanguage.id = titleLanguage.Language_Code.Value;
                    objTitleLanguage.Name = titleLanguage.Language_Name;
                    _TitleReturn.TitleLanguage = objTitleLanguage;

                    #endregion

                    _TitleReturn.OriginalName = objTitle.Original_Title;

                    #region OriginalLanguage

                    TitleGeneric objOriginalLanguage = new TitleGeneric();

                    var originalLanguage = objLanguageRepositories.Get(objTitle.Original_Language_Code.Value);

                    objOriginalLanguage.id = originalLanguage.Language_Code.Value;
                    objOriginalLanguage.Name = originalLanguage.Language_Name;
                    _TitleReturn.OriginalLanguage = objOriginalLanguage;

                    #endregion

                    _TitleReturn.ProductionYear = objTitle.Year_Of_Production.Value;
                    _TitleReturn.DurationInMin = objTitle.Duration_In_Min.Value;

                    #region Program

                    TitleGeneric objProgram = new TitleGeneric();

                    var program = objProgramRepositories.Get(objTitle.Program_Code.Value);

                    objProgram.id = program.Program_Code.Value;
                    objProgram.Name = program.Program_Name;
                    _TitleReturn.Program = objProgram;

                    #endregion

                    #region Country

                    List<TitleCountry> lstTitleCountry = new List<TitleCountry>();

                    foreach (var country in objTitle.Title_Country)
                    {
                        var objcountry = objCountryRepositories.Get(country.Country_Code.Value);

                        lstTitleCountry.Add(new TitleCountry() { id = country.Title_Country_Code.Value, CountryId = country.Country_Code.Value, Name = objcountry.Country_Name });
                    }

                    _TitleReturn.Country = lstTitleCountry;

                    #endregion

                    #region Title Talent

                    List<TitleTalent> lstTitleTalent = new List<TitleTalent>();

                    foreach (var talent in objTitle.Title_Talent)
                    {
                        var objTalent = objTalentRepositories.Get(talent.Talent_Code.Value);
                        var objRole = objRoleRepositories.Get(talent.Role_Code.Value);

                        lstTitleTalent.Add(new TitleTalent()
                        {
                            id = talent.Title_Talent_Code.Value,
                            Name = objTalent.Talent_Name,
                            Role = objRole.Role_Name,
                            RoleId = talent.Role_Code.Value,
                            TalentId = talent.Talent_Code.Value
                        });
                    }

                    _TitleReturn.TitleTalent = lstTitleTalent;

                    #endregion

                    #region Asset Type

                    TitleGeneric objAssetType = new TitleGeneric();

                    var assetType = objDeal_TypeRepositories.Get(objTitle.Deal_Type_Code.Value);

                    objAssetType.id = assetType.Deal_Type_Code.Value;
                    objAssetType.Name = assetType.Deal_Type_Name;
                    _TitleReturn.AssetType = objAssetType;

                    #endregion

                    _TitleReturn.Synopsis = objTitle.Synopsis;

                    #region Title Genre

                    List<TitleGenre> lstTitleGeners = new List<TitleGenre>();

                    foreach (var genres in objTitle.Title_Geners)
                    {
                        var objgenres = objGenresRepositories.Get(genres.Genres_Code.Value);

                        lstTitleGeners.Add(new TitleGenre() { id = genres.Title_Geners_Code.Value, GenreId = genres.Genres_Code.Value, Name = objgenres.Genres_Name });
                    }

                    _TitleReturn.Genre = lstTitleGeners;

                    #endregion

                    var abc = JsonConvert.SerializeObject(_TitleReturn);

                    var alLab = objAL_LabRepositories.Get(1013);

                    //_TitleReturn = objTitleRepositories.GetTitleById(id);

                    var objMapExtended = objMap_Extended_ColumnsRepositories.SearchFor(new { Record_Code = _TitleReturn.id });

                    List<ExtendedColumns> objExtended = new List<ExtendedColumns>();

                    if (objMapExtended.Count() > 0)
                    {
                        foreach (var item in objMapExtended)
                        {
                            if (item.Columns_Code.Is_Ref == "N" && item.Columns_Code.Is_Defined_Values == "N" && item.Columns_Code.Is_Multiple_Select == "N")
                            {
                                string strColumnValue = string.Empty;

                                if (item.Columns_Code.Control_Type == "DATE")
                                {
                                    if (!string.IsNullOrEmpty(item.Column_Value))
                                    {
                                        strColumnValue = Convert.ToString(GlobalTool.DateToLinux(DateTime.Parse(item.Column_Value)));
                                    }
                                }
                                else
                                {
                                    strColumnValue = item.Column_Value;
                                }

                                objExtended.Add(new ExtendedColumns()
                                {
                                    id = item.Map_Extended_Columns_Code.Value,
                                    ColumnId = item.Columns_Code.Columns_Code.Value,
                                    Key = item.Columns_Code.Columns_Name,
                                    Row_No = item.Row_No == null ? 0 : item.Row_No.Value,
                                    Value = strColumnValue
                                });
                            }
                            else if (item.Columns_Code.Is_Ref == "Y" && item.Columns_Code.Is_Multiple_Select == "N")
                            {
                                if (item.Columns_Code.Is_Defined_Values == "Y")
                                {
                                    var objExtendedValue = objExtended_Columns_ValueRepositories.Get(item.Columns_Value_Code.Value);

                                    if (objExtendedValue != null)
                                    {
                                        objExtended.Add(new ExtendedColumns()
                                        {
                                            id = item.Map_Extended_Columns_Code.Value,
                                            ColumnId = item.Columns_Code.Columns_Code.Value,
                                            Key = item.Columns_Code.Columns_Name,
                                            Row_No = item.Row_No == null ? 0 : item.Row_No.Value,
                                            Value = new TitleGeneric()
                                            {
                                                id = objExtendedValue.Columns_Value_Code.Value,
                                                Name = objExtendedValue.Columns_Value
                                            }
                                        });
                                    }
                                }
                                else
                                {
                                    TitleGeneric objGeneric = new TitleGeneric();

                                    if (item.Columns_Code.Ref_Table.ToLower() == "Banner".ToLower())
                                    {
                                        var banner = objBannerRepositories.Get(item.Columns_Value_Code.Value);
                                        if (banner != null)
                                        {
                                            objGeneric.id = banner.Banner_Code.Value;
                                            objGeneric.Name = banner.Banner_Name;
                                        }
                                    }
                                    else if (item.Columns_Code.Ref_Table.ToLower() == "Language".ToLower())
                                    {
                                        var language = objLanguageRepositories.Get(item.Columns_Value_Code.Value);
                                        if (language != null)
                                        {
                                            objGeneric.id = language.Language_Code.Value;
                                            objGeneric.Name = language.Language_Name;
                                        }
                                    }
                                    else if (item.Columns_Code.Ref_Table.ToLower() == "Talent".ToLower())
                                    {
                                        var talent = objTalentRepositories.Get(item.Columns_Value_Code.Value);
                                        if (talent != null)
                                        {
                                            objGeneric.id = talent.Talent_Code.Value;
                                            objGeneric.Name = talent.Talent_Name;
                                        }
                                    }
                                    else if (item.Columns_Code.Ref_Table.ToLower() == "version".ToLower())
                                    {
                                        var talent = objTalentRepositories.Get(item.Columns_Value_Code.Value);
                                        if (talent != null)
                                        {
                                            objGeneric.id = talent.Talent_Code.Value;
                                            objGeneric.Name = talent.Talent_Name;
                                        }
                                    }
                                    else if (item.Columns_Code.Ref_Table.ToLower() == "AL_Lab".ToLower())
                                    {
                                        //var alLab = objAL_LabRepositories.Get(1013);
                                        //if (alLab != null)
                                        //{
                                        //    objGeneric.id = alLab.AL_Lab_id.Value;
                                        //    objGeneric.Name = alLab.AL_Lab_Name;
                                        //}
                                    }
                                }
                            }
                            //else if (objExtendedColumn.Is_Ref == "Y" && objExtendedColumn.Is_Multiple_Select == "Y")
                            //{
                            //    foreach (var details in (List<ExtendedColumnDetails>)Metadata.Value)
                            //    {
                            //        Map_Extended_Columns_Details objMapExtendedColumnDetails = new Map_Extended_Columns_Details();
                            //        objMapExtendedColumnDetails.Columns_Value_Code = details.ColumnValueId;
                            //        objMapExtendedColumn.Map_Extended_Columns_Details.Add(objMapExtendedColumnDetails);
                            //    }
                            //}

                        }

                        _TitleReturn.MetaData = objExtended;
                    }

                    if (_TitleReturn != null)
                    {
                        //List<USPAPI_Title_Bind_Extend_Data> lstExtended = new List<USPAPI_Title_Bind_Extend_Data>();
                        //lstExtended = USPAPI_Title_Bind_Extend_Data(_TitleReturn.id);

                        //if (lstExtended.Count() > 0)
                        //{
                        //    var objGroupCode = lstExtended.Select(x => x.Extended_Group_Code).Distinct().ToList();

                        //    foreach (Int32 item in objGroupCode)
                        //    {
                        //        string strGroupName = lstExtended.Where(x => x.Extended_Group_Code == item).Select(x => x.Group_Name).Distinct().FirstOrDefault();
                        //        Dictionary<string, string> objDictionary = new Dictionary<string, string>();
                        //        lstExtended.Where(x => x.Extended_Group_Code == item).ToList().ForEach(x =>
                        //        {
                        //            if (string.IsNullOrEmpty(x.Column_Value))
                        //            {
                        //                objDictionary.Add(x.Columns_Name, x.Name);
                        //            }
                        //            else
                        //            {
                        //                objDictionary.Add(x.Columns_Name, x.Column_Value);
                        //            }

                        //        });

                        //        _TitleReturn.MetaData.Add(strGroupName, objDictionary);
                        //    }
                        //}
                    }
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            //_objRet.Response = _TitleReturn;

            return _objRet;
        }

        public GenericReturn PostTitle(TitleInput objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (string.IsNullOrEmpty(objInput.Name))
            {
                _objRet.Message = "Input Paramater 'Name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.TitleLanguage == null || objInput.TitleLanguage.id <= 0)
            {
                _objRet.Message = "Input Paramater 'TitleLanguage' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            //else
            //{
            //    var Language = objTitleRepositories.Title_Validation(Convert.ToString(objInput.TitleLanguageId), "Language");

            //    if (Language.InputValueCode == 0)
            //    {
            //        _objRet.Message = "Input Paramater 'TitleLanguageId :'" + Language.InvalidValue + " is not Valid";
            //        _objRet.IsSuccess = false;
            //        _objRet.StatusCode = HttpStatusCode.BadRequest;
            //        return _objRet;
            //    }
            //}

            //if (objInput.Program > 0)
            //{
            //    var Program = objTitleRepositories.Title_Validation(Convert.ToString(objInput.Program), "Program");

            //    if (Program.InputValueCode == 0)
            //    {
            //        _objRet.Message = "Input Paramater 'Program :'" + Program.InvalidValue + " is not Valid";
            //        _objRet.IsSuccess = false;
            //        _objRet.StatusCode = HttpStatusCode.BadRequest;
            //        return _objRet;
            //    }
            //}

            //if (objInput.Country.Count() > 0)
            //{
            //    string strCountry = String.Join(",", objInput.Country.Select(x => x.CountryId.ToString()).ToArray());

            //    var Country = objTitleRepositories.Title_Validation(strCountry, "Country");

            //    if (Country.InputValueCode == 0)
            //    {
            //        _objRet.Message = "Input Paramater 'Country :" + Country.InvalidValue + "' is not Valid";
            //        _objRet.IsSuccess = false;
            //        _objRet.StatusCode = HttpStatusCode.BadRequest;
            //        return _objRet;
            //    }
            //}

            //if (objInput.TitleTalent.Count() > 0)
            //{
            //    string strTitleTalent = String.Join(",", objInput.TitleTalent.Select(x => String.Format("{0}:{1}", x.TalentId.ToString(), x.RoleId.ToString())).ToArray());

            //    var talent = objTitleRepositories.Title_Validation(strTitleTalent, "talent");

            //    if (talent.InputValueCode == 0)
            //    {
            //        _objRet.Message = "Input Paramater 'TitleTalent :" + talent.InvalidValue + "' is not Valid";
            //        _objRet.IsSuccess = false;
            //        _objRet.StatusCode = HttpStatusCode.BadRequest;
            //        return _objRet;
            //    }
            //}

            if (objInput.AssetType == null || objInput.AssetType.id <= 0)
            {
                _objRet.Message = "Input Paramater 'AssetTypeId' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            //else
            //{
            //    var AssetType = objTitleRepositories.Title_Validation(Convert.ToString(objInput.AssetTypeId), "assettype");

            //    if (AssetType.InputValueCode == 0)
            //    {
            //        _objRet.Message = "Input Paramater 'AssetTypeId :" + AssetType.InvalidValue + "' is not Valid";
            //        _objRet.IsSuccess = false;
            //        _objRet.StatusCode = HttpStatusCode.BadRequest;
            //        return _objRet;
            //    }
            //}

            //if (objInput.TitleGenre.Count() > 0)
            //{
            //    string strGenre = String.Join(",", objInput.TitleGenre.Select(x => x.GenreId.ToString()).ToArray());

            //    var Genres = objTitleRepositories.Title_Validation(strGenre, "Genres");

            //    if (Genres.InputValueCode == 0)
            //    {
            //        _objRet.Message = "Input Paramater 'TitleGenre :" + Genres.InvalidValue + "' is not Valid";
            //        _objRet.IsSuccess = false;
            //        _objRet.StatusCode = HttpStatusCode.BadRequest;
            //        return _objRet;
            //    }
            //}

            #endregion

            if (_objRet.IsSuccess)
            {
                Title objTitle = new Title();

                objTitle.Original_Title = objInput.OriginalName;
                objTitle.Title_Name = objInput.Name;
                objTitle.Synopsis = objInput.Synopsis;
                objTitle.Original_Language_Code = (objInput.OriginalLanguage == null || objInput.OriginalLanguage.id <= 0) ? (int?)null : objInput.OriginalLanguage.id;
                objTitle.Title_Language_Code = (objInput.TitleLanguage == null || objInput.TitleLanguage.id <= 0) ? (int?)null : objInput.TitleLanguage.id;
                objTitle.Year_Of_Production = objInput.ProductionYear <= 0 ? (int?)null : objInput.ProductionYear;
                objTitle.Duration_In_Min = objInput.DurationInMin;
                objTitle.Deal_Type_Code = (objInput.AssetType == null || objInput.AssetType.id <= 0) ? (int?)null : objInput.AssetType.id;
                objTitle.Program_Code = (objInput.Program == null || objInput.Program.id <= 0) ? (int?)null : objInput.Program.id;
                objTitle.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objTitle.Inserted_On = DateTime.Now;
                objTitle.Last_UpDated_Time = DateTime.Now;
                objTitle.Is_Active = "Y";

                foreach (var item in objInput.Country)
                {
                    Title_Country objTitle_Country = new Title_Country();
                    objTitle_Country.Country_Code = item.CountryId;
                    objTitle.Title_Country.Add(objTitle_Country);
                }

                foreach (var item in objInput.TitleTalent)
                {
                    Title_Talent objTitle_Talent = new Title_Talent();
                    objTitle_Talent.Talent_Code = item.TalentId;
                    objTitle_Talent.Role_Code = item.RoleId;
                    objTitle.Title_Talent.Add(objTitle_Talent);
                }

                foreach (var item in objInput.Genre)
                {
                    Title_Geners objTitleGeners = new Title_Geners();
                    objTitleGeners.Genres_Code = item.GenreId;
                    objTitle.Title_Geners.Add(objTitleGeners);
                }

                objTitleRepositories.Add(objTitle);
                _objRet.Response = new { id = objTitle.Title_Code };

                if (objTitle.Title_Code != null && objTitle.Title_Code > 0)
                {
                    foreach (var Metadata in objInput.MetaData)
                    {
                        Map_Extended_Columns objMapExtendedColumn = new Map_Extended_Columns();

                        var objExtendedColumn = objExtendedColumnsRepositories.Get(Metadata.ColumnId);

                        objMapExtendedColumn.Record_Code = objTitle.Title_Code;
                        objMapExtendedColumn.Table_Name = "TITLE";
                        objMapExtendedColumn.Columns_Code = new Extended_Columns() { Columns_Code = Metadata.ColumnId };
                        objMapExtendedColumn.Is_Multiple_Select = objExtendedColumn.Is_Multiple_Select;
                        objMapExtendedColumn.Row_No = Metadata.Row_No > 0 ? Metadata.Row_No : (int?)null;

                        if (objExtendedColumn.Is_Ref == "N" && objExtendedColumn.Is_Defined_Values == "N" && objExtendedColumn.Is_Multiple_Select == "N")
                        {
                            string strColumnValue = string.Empty;

                            if (!string.IsNullOrEmpty(Convert.ToString(Metadata.Value)))
                            {
                                strColumnValue = Convert.ToString(Metadata.Value);

                                if (objExtendedColumn.Control_Type == "DATE")
                                {
                                    strColumnValue = GlobalTool.LinuxToDate(Convert.ToDouble(strColumnValue)).ToString("dd-MMM-yyyy");
                                }
                            }
                            objMapExtendedColumn.Column_Value = strColumnValue;
                        }
                        else if (objExtendedColumn.Is_Ref == "Y" && objExtendedColumn.Is_Multiple_Select == "N")
                        {
                            foreach (var details in (List<ExtendedColumnDetails>)Metadata.Value)
                            {
                                objMapExtendedColumn.Columns_Value_Code = details.ColumnValueId;
                            }
                        }
                        else if (objExtendedColumn.Is_Ref == "Y" && objExtendedColumn.Is_Multiple_Select == "Y")
                        {
                            foreach (var details in (List<ExtendedColumnDetails>)Metadata.Value)
                            {
                                Map_Extended_Columns_Details objMapExtendedColumnDetails = new Map_Extended_Columns_Details();
                                objMapExtendedColumnDetails.Columns_Value_Code = details.ColumnValueId;
                                objMapExtendedColumn.Map_Extended_Columns_Details.Add(objMapExtendedColumnDetails);
                            }
                        }
                        objMap_Extended_ColumnsRepositories.Add(objMapExtendedColumn);
                    }
                }
            }

            return _objRet;
        }

        public GenericReturn PutTitle(TitleInput objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.id <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Name))
            {
                _objRet.Message = "Input Paramater 'Name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.TitleLanguage == null || objInput.TitleLanguage.id <= 0)
            {
                _objRet.Message = "Input Paramater 'TitleLanguage' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.AssetType == null || objInput.AssetType.id <= 0)
            {
                _objRet.Message = "Input Paramater 'AssetType' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }


            #endregion

            if (_objRet.IsSuccess)
            {
                Title objTitle = new Title();

                objTitle = objTitleRepositories.GetById(objInput.id);

                objTitle.Original_Title = objInput.OriginalName;
                objTitle.Title_Name = objInput.Name;
                objTitle.Synopsis = objInput.Synopsis;
                objTitle.Original_Language_Code = (objInput.OriginalLanguage == null || objInput.OriginalLanguage.id <= 0) ? (int?)null : objInput.OriginalLanguage.id;
                objTitle.Title_Language_Code = (objInput.TitleLanguage == null || objInput.TitleLanguage.id <= 0) ? (int?)null : objInput.TitleLanguage.id;
                objTitle.Year_Of_Production = objInput.ProductionYear <= 0 ? (int?)null : objInput.ProductionYear;
                objTitle.Duration_In_Min = objInput.DurationInMin;
                objTitle.Deal_Type_Code = (objInput.AssetType == null || objInput.AssetType.id <= 0) ? (int?)null : objInput.AssetType.id;
                objTitle.Program_Code = (objInput.Program == null || objInput.Program.id <= 0) ? (int?)null : objInput.Program.id;
                objTitle.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objTitle.Last_UpDated_Time = DateTime.Now;
                objTitle.Is_Active = "Y";

                #region Title_Country

                objTitle.Title_Country.ToList().ForEach(i => i.EntityState = State.Deleted);

                foreach (var item in objInput.Country)
                {
                    Title_Country objT = (Title_Country)objTitle.Title_Country.Where(t => t.Country_Code == item.CountryId).Select(i => i).FirstOrDefault();

                    if (objT == null)
                        objT = new Title_Country();
                    if (objT.Title_Country_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Title_Code = objInput.id;
                        objT.Country_Code = item.CountryId;
                        objTitle.Title_Country.Add(objT);
                    }
                }

                foreach (var item in objTitle.Title_Country.ToList().Where(x => x.EntityState == State.Deleted))
                {
                    objTitle_CountryRepositories.Delete(item);
                }

                var objCountry = objTitle.Title_Country.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                objCountry.ForEach(i => objTitle.Title_Country.Remove(i));
                //objTitle.Title_Country.ToList().Remove(obj);

                #endregion

                #region Title_Talent

                objTitle.Title_Talent.ToList().ForEach(i => i.EntityState = State.Deleted);

                foreach (var item in objInput.TitleTalent)
                {
                    Title_Talent objT = (Title_Talent)objTitle.Title_Talent.Where(t => t.Talent_Code == item.TalentId).Select(i => i).FirstOrDefault();

                    if (objT == null)
                        objT = new Title_Talent();
                    if (objT.Title_Talent_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Title_Code = objInput.id;
                        objT.Talent_Code = item.TalentId;
                        objT.Role_Code = item.RoleId;
                        objTitle.Title_Talent.Add(objT);
                    }
                }

                foreach (var item in objTitle.Title_Talent.ToList().Where(x => x.EntityState == State.Deleted))
                {
                    objTitle_TalentRepositories.Delete(item);
                }

                var objTalent = objTitle.Title_Talent.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                objTalent.ForEach(i => objTitle.Title_Talent.Remove(i));

                #endregion

                #region Title_Geners

                objTitle.Title_Geners.ToList().ForEach(i => i.EntityState = State.Deleted);

                foreach (var item in objInput.Genre)
                {
                    Title_Geners objT = (Title_Geners)objTitle.Title_Geners.Where(t => t.Genres_Code == item.GenreId).Select(i => i).FirstOrDefault();

                    if (objT == null)
                        objT = new Title_Geners();
                    if (objT.Title_Geners_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Title_Code = objInput.id;
                        objT.Genres_Code = item.GenreId;
                        objTitle.Title_Geners.Add(objT);
                    }
                }

                foreach (var item in objTitle.Title_Geners.ToList().Where(x => x.EntityState == State.Deleted))
                {
                    objTitle_GenersRepositories.Delete(item);
                }

                var objGeners = objTitle.Title_Geners.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                objGeners.ForEach(i => objTitle.Title_Geners.Remove(i));

                #endregion

                objTitleRepositories.AddEntity(objTitle);

                _objRet.Response = new { id = objTitle.Title_Code };

                if (objTitle.Title_Code != null && objTitle.Title_Code > 0)
                {
                    var MapExtendedData = objMap_Extended_ColumnsRepositories.SearchFor(new { Record_Code = objTitle.Title_Code }).ToList();

                    MapExtendedData.ForEach(i => i.EntityState = State.Deleted);

                    foreach (var Metadata in objInput.MetaData)
                    {
                        Map_Extended_Columns objT = (Map_Extended_Columns)MapExtendedData.Where(t => t.Columns_Code.Columns_Code == Metadata.ColumnId && t.EntityState != State.Added && t.EntityState != State.Unchanged).Select(i => i).FirstOrDefault();

                        if (objT == null)
                            objT = new Map_Extended_Columns();
                        if (objT.Map_Extended_Columns_Code > 0)
                        {
                            objT.EntityState = State.Unchanged;

                            objT.Row_No = Metadata.Row_No > 0 ? Metadata.Row_No : (int?)null;

                            if (objT.Columns_Code.Is_Ref == "N" && objT.Columns_Code.Is_Defined_Values == "N" && objT.Columns_Code.Is_Multiple_Select == "N")
                            {
                                string strColumnValue = string.Empty;

                                if (!string.IsNullOrEmpty(Convert.ToString(Metadata.Value)))
                                {
                                    strColumnValue = Convert.ToString(Metadata.Value);

                                    if (objT.Columns_Code.Control_Type == "DATE")
                                    {
                                        strColumnValue = GlobalTool.LinuxToDate(Convert.ToDouble(strColumnValue)).ToString("dd-MMM-yyyy");
                                    }
                                }
                                objT.Column_Value = strColumnValue;
                            }
                            else if (objT.Columns_Code.Is_Ref == "Y" && objT.Columns_Code.Is_Multiple_Select == "N")
                            {
                                foreach (var details in (List<ExtendedColumnDetails>)Metadata.Value)
                                {
                                    objT.Columns_Value_Code = details.ColumnValueId;
                                }
                            }
                            else if (objT.Columns_Code.Is_Ref == "Y" && objT.Columns_Code.Is_Multiple_Select == "Y")
                            {
                                objT.Map_Extended_Columns_Details.ToList().ForEach(i => i.EntityState = State.Deleted);

                                foreach (var details in (List<ExtendedColumnDetails>)Metadata.Value)
                                {
                                    Map_Extended_Columns_Details objMECD = (Map_Extended_Columns_Details)objT.Map_Extended_Columns_Details.Where(t => t.Columns_Value_Code == details.ColumnValueId).Select(i => i).FirstOrDefault();

                                    if (objMECD == null)
                                        objMECD = new Map_Extended_Columns_Details();
                                    if (objMECD.Map_Extended_Columns_Details_Code > 0)
                                        objMECD.EntityState = State.Unchanged;
                                    else
                                    {
                                        objT.EntityState = State.Added;
                                        objMECD.Columns_Value_Code = details.ColumnValueId;
                                        objMECD.Map_Extended_Columns_Code = objT.Map_Extended_Columns_Code;

                                        objT.Map_Extended_Columns_Details.Add(objMECD);
                                    }
                                }

                                foreach (var item in objT.Map_Extended_Columns_Details.ToList().Where(x => x.EntityState == State.Deleted))
                                {
                                    objMap_Extended_Columns_DetailsRepositories.Delete(item);
                                }

                                var objdetails = objT.Map_Extended_Columns_Details.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                                foreach (var deleted in objdetails)
                                {
                                    objT.Map_Extended_Columns_Details.Remove(deleted);
                                }
                            }
                        }
                        else
                        {
                            var objExtendedColumn = objExtendedColumnsRepositories.Get(Metadata.ColumnId);

                            objT.EntityState = State.Added;
                            objT.Record_Code = objInput.id;
                            objT.Table_Name = "TITLE";
                            objT.Columns_Code = objExtendedColumn;
                            objT.Is_Multiple_Select = objExtendedColumn.Is_Multiple_Select;
                            objT.Row_No = Metadata.Row_No > 0 ? Metadata.Row_No : (int?)null;

                            if (objExtendedColumn.Is_Ref == "N" && objExtendedColumn.Is_Defined_Values == "N" && objExtendedColumn.Is_Multiple_Select == "N")
                            {
                                string strColumnValue = string.Empty;

                                if (!string.IsNullOrEmpty(Convert.ToString(Metadata.Value)))
                                {
                                    strColumnValue = Convert.ToString(Metadata.Value);

                                    if (objExtendedColumn.Control_Type == "DATE")
                                    {
                                        strColumnValue = GlobalTool.LinuxToDate(Convert.ToDouble(strColumnValue)).ToString("dd-MMM-yyyy");
                                    }
                                }
                                objT.Column_Value = strColumnValue;
                            }
                            else if (objExtendedColumn.Is_Ref == "Y" && objExtendedColumn.Is_Multiple_Select == "N")
                            {
                                foreach (var details in (List<ExtendedColumnDetails>)Metadata.Value)
                                {
                                    objT.Columns_Value_Code = details.ColumnValueId;
                                }
                            }
                            else if (objExtendedColumn.Is_Ref == "Y" && objExtendedColumn.Is_Multiple_Select == "Y")
                            {
                                foreach (var details in (List<ExtendedColumnDetails>)Metadata.Value)
                                {
                                    Map_Extended_Columns_Details objMapExtendedColumnDetails = new Map_Extended_Columns_Details();
                                    objMapExtendedColumnDetails.Columns_Value_Code = details.ColumnValueId;
                                    objT.Map_Extended_Columns_Details.Add(objMapExtendedColumnDetails);
                                }
                            }

                            objMap_Extended_ColumnsRepositories.Add(objT);

                            MapExtendedData.Add(objT);
                        }
                    }

                    foreach (var item in MapExtendedData.Where(x => x.EntityState == State.Deleted))
                    {
                        objMap_Extended_ColumnsRepositories.Delete(item);
                    }

                    var objMEC = MapExtendedData.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                    objMEC.ForEach(i => MapExtendedData.Remove(i));


                    foreach (var item in MapExtendedData.Where(x => x.EntityState != State.Deleted))
                    {
                        objMap_Extended_ColumnsRepositories.Update(item);
                    }
                }
            }

            return _objRet;
        }

        public GenericReturn ChangeActiveStatus(PutInput objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.id <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Status))
            {
                _objRet.Message = "Input Paramater 'Status' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else if (objInput.Status.ToUpper() != "Y" && objInput.Status.ToUpper() != "N")
            {
                _objRet.Message = "Input Paramater 'Status' is invalid";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                Title objTitle = new Title();

                objTitle = objTitleRepositories.GetById(objInput.id);

                objTitle.Last_UpDated_Time = DateTime.Now;
                objTitle.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objTitle.Is_Active = objInput.Status.ToUpper();

                objTitleRepositories.Update(objTitle);
                _objRet.Response = new { id = objTitle.Title_Code };

            }

            return _objRet;
        }
    }
}
